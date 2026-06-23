#!/usr/bin/env bun
// Regenerate dist/index.html from Formula/*.rb.
// Usage: bun run website/generate.ts

import { readdirSync, readFileSync, writeFileSync, mkdirSync, cpSync, existsSync } from "node:fs";
import { execSync } from "node:child_process";
import { join, dirname, basename } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = dirname(HERE);
const FORMULA_DIR = join(ROOT, "Formula");
const TEMPLATE = join(HERE, "template.html");
const DIST = join(ROOT, "dist");
const CNAME = join(HERE, "CNAME");

type Triple =
  | "aarch64-apple-darwin"
  | "x86_64-apple-darwin"
  | "aarch64-unknown-linux-gnu"
  | "x86_64-unknown-linux-gnu";

interface Formula {
  id: string;             // basename without .rb
  name: string;           // display/install name == formula id (the .rb basename)
  desc: string;
  homepage: string;
  version: string;
  license: string;
  artifacts: Map<Triple, { url: string; sha256: string }>;
  sourceRepo: string;     // github.com/<owner>/<repo> derived from any url
  releaseUrl: string;     // url to GitHub release tag
}

function readField(src: string, field: string): string {
  // Matches e.g.  desc "Some text"
  const re = new RegExp(`^\\s*${field}\\s+"([^"]*)"`, "m");
  const m = src.match(re);
  if (!m) throw new Error(`missing field '${field}'`);
  return m[1];
}

function readFieldOpt(src: string, field: string): string | undefined {
  const re = new RegExp(`^\\s*${field}\\s+"([^"]*)"`, "m");
  return src.match(re)?.[1];
}

// Platform suffix (on the extension-stripped asset filename) -> canonical Rust triple.
// Covers cargo-dist triples (fedit, sema, token, sql-splitter), Go-style GOOS-GOARCH
// (dbdump: darwin-arm64), Zig-style os-aarch64/x86_64 (jake: macos-aarch64), and the
// short os-arch form (glue: macos-arm64), so the site renders tools regardless of how
// their release assets are named or whether they are archives or raw binaries.
const SUFFIX_TO_TRIPLE: Record<string, Triple> = {
  // cargo-dist target triples
  "aarch64-apple-darwin": "aarch64-apple-darwin",
  "x86_64-apple-darwin": "x86_64-apple-darwin",
  "aarch64-unknown-linux-gnu": "aarch64-unknown-linux-gnu",
  "x86_64-unknown-linux-gnu": "x86_64-unknown-linux-gnu",
  // Go style (GOOS-GOARCH)
  "darwin-arm64": "aarch64-apple-darwin",
  "darwin-amd64": "x86_64-apple-darwin",
  "linux-arm64": "aarch64-unknown-linux-gnu",
  "linux-amd64": "x86_64-unknown-linux-gnu",
  // Zig style (os + aarch64/x86_64)
  "macos-aarch64": "aarch64-apple-darwin",
  "macos-x86_64": "x86_64-apple-darwin",
  "linux-aarch64": "aarch64-unknown-linux-gnu",
  "linux-x86_64": "x86_64-unknown-linux-gnu",
  // Short os-arch form
  "macos-arm64": "aarch64-apple-darwin",
  "macos-x64": "x86_64-apple-darwin",
  "linux-x64": "x86_64-unknown-linux-gnu",
};

// Longest suffix first so the most specific match wins.
const SUFFIXES_BY_LENGTH = Object.keys(SUFFIX_TO_TRIPLE).sort((a, b) => b.length - a.length);

function stripArchiveExt(name: string): string {
  return name.replace(/\.(tar\.[a-z0-9]+|tgz|tbz2?|zip)$/i, "");
}

function tripleForUrl(url: string): Triple | undefined {
  const stem = stripArchiveExt(basename(url));
  for (const suffix of SUFFIXES_BY_LENGTH) {
    if (stem === suffix || stem.endsWith(`-${suffix}`)) return SUFFIX_TO_TRIPLE[suffix];
  }
  return undefined;
}

function parseArtifacts(src: string): Map<Triple, { url: string; sha256: string }> {
  // Pair every `url "..."` with the next `sha256 "..."` on a subsequent line.
  // Each url filename ends in `<triple>.tar.<ext>` (Rust triple) or
  // `<os>-<arch>.tar.<ext>` short form — both are mapped to a Rust triple.
  const out = new Map<Triple, { url: string; sha256: string }>();
  const tokenRe = /^\s*(url|sha256)\s+"([^"]+)"/gm;
  let pendingUrl: string | undefined;
  let m: RegExpExecArray | null;
  while ((m = tokenRe.exec(src))) {
    const [, kind, value] = m;
    if (kind === "url") {
      pendingUrl = value;
    } else if (kind === "sha256" && pendingUrl) {
      const triple = tripleForUrl(pendingUrl);
      if (triple) out.set(triple, { url: pendingUrl, sha256: value });
      pendingUrl = undefined;
    }
  }
  return out;
}

function deriveSourceRepo(anyUrl: string): { repo: string; releaseUrl: string } {
  // https://github.com/<owner>/<repo>/releases/download/<tag>/<asset>
  // Independent of asset naming so it works for archives and raw binaries alike.
  const re = /^(https:\/\/github\.com\/[^/]+\/[^/]+)\/releases\/download\/([^/]+)\//;
  const m = anyUrl.match(re);
  if (!m) throw new Error(`cannot parse release url: ${anyUrl}`);
  return { repo: m[1], releaseUrl: `${m[1]}/releases/tag/${m[2]}` };
}

function loadFormula(file: string): Formula {
  const src = readFileSync(file, "utf8");
  const id = basename(file, ".rb");
  const artifacts = parseArtifacts(src);
  if (artifacts.size === 0) throw new Error(`${id}: no url/sha256 pairs found`);
  const anyUrl = artifacts.values().next().value!.url;
  const { repo, releaseUrl } = deriveSourceRepo(anyUrl);
  return {
    id,
    name: id,
    desc: readField(src, "desc"),
    homepage: readField(src, "homepage"),
    version: readField(src, "version"),
    license: readFieldOpt(src, "license") ?? "—",
    artifacts,
    sourceRepo: repo,
    releaseUrl,
  };
}

const TICK = `<span class="tick">●</span>`;
const NOPE = `<span class="nope">○</span>`;

function shaRowsHtml(f: Formula): string {
  return Array.from(f.artifacts.entries())
    .map(([triple, a]) => `      <li><span class="triple">${triple}</span><code>${a.sha256}</code></li>`)
    .join("\n");
}

function footLinksHtml(f: Formula): string {
  const homepageIsRepo = f.homepage === f.sourceRepo;
  const formulaUrl = `https://github.com/HelgeSverre/homebrew-tap/blob/main/Formula/${f.id}.rb`;
  const links: [string, string][] = [];
  if (!homepageIsRepo) links.push(["Homepage", f.homepage]);
  links.push(["Source", f.sourceRepo]);
  links.push(["Formula", formulaUrl]);
  links.push(["Release", f.releaseUrl]);
  return links.map(([label, href]) => `    <a href="${href}">${label}</a>`).join("\n");
}

function extractCardTemplate(template: string): { shell: string; card: string } {
  const m = template.match(/<template id="formula-card">([\s\S]*?)<\/template>/);
  if (!m) throw new Error("template.html: missing <template id=\"formula-card\">");
  const card = m[1].trim();
  // Strip the entire trailing block (HTML comment + <template>) from the shell.
  const shell = template.slice(0, template.indexOf("<!--")).trimEnd() + "\n";
  return { shell, card };
}

function renderCard(card: string, f: Formula): string {
  const has = (t: Triple) => (f.artifacts.has(t) ? TICK : NOPE);
  return card
    .replaceAll("{{ID}}", f.id)
    .replaceAll("{{NAME}}", f.name)
    .replaceAll("{{VERSION}}", f.version)
    .replaceAll("{{LICENSE}}", f.license)
    .replaceAll("{{DESC}}", escapeHtml(f.desc))
    .replaceAll("{{MAC_ARM}}", has("aarch64-apple-darwin"))
    .replaceAll("{{MAC_X64}}", has("x86_64-apple-darwin"))
    .replaceAll("{{LINUX_ARM}}", has("aarch64-unknown-linux-gnu"))
    .replaceAll("{{LINUX_X64}}", has("x86_64-unknown-linux-gnu"))
    .replaceAll("{{SHA_ROWS}}", shaRowsHtml(f))
    .replaceAll("{{FOOT_LINKS}}", footLinksHtml(f));
}

function escapeHtml(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function todayUtc(): string {
  try {
    const iso = execSync("git log -1 --format=%cI -- Formula/", { cwd: ROOT }).toString().trim();
    return iso ? iso.slice(0, 10) : new Date().toISOString().slice(0, 10);
  } catch {
    return new Date().toISOString().slice(0, 10);
  }
}

function tapTagline(formulas: Formula[]): string {
  // Used in <meta description>; one-line summary of what's in the tap.
  return formulas.map((f) => f.name).join(", ") + ".";
}

function main() {
  const files = readdirSync(FORMULA_DIR)
    .filter((f) => f.endsWith(".rb"))
    .sort()
    .map((f) => join(FORMULA_DIR, f));

  const formulas = files.map(loadFormula);
  const template = readFileSync(TEMPLATE, "utf8");
  const { shell, card } = extractCardTemplate(template);

  const cards = formulas.map((f) => renderCard(card, f)).join("\n\n");

  const html = shell
    .replaceAll("{{FORMULA_COUNT}}", String(formulas.length))
    .replaceAll("{{FORMULAS_HTML}}", cards)
    .replaceAll("{{UPDATED_AT}}", todayUtc())
    .replaceAll("{{TAP_DESC}}", `Install ${tapTagline(formulas)}`);

  mkdirSync(DIST, { recursive: true });
  writeFileSync(join(DIST, "index.html"), html);
  if (existsSync(CNAME)) cpSync(CNAME, join(DIST, "CNAME"));

  // Tell GitHub Pages not to run Jekyll (otherwise underscore-prefixed paths break).
  writeFileSync(join(DIST, ".nojekyll"), "");

  console.log(`wrote ${formulas.length} formulae to ${join(DIST, "index.html")}`);
}

main();
