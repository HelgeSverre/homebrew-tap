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

const ALL_TRIPLES: Triple[] = [
  "aarch64-apple-darwin",
  "x86_64-apple-darwin",
  "aarch64-unknown-linux-gnu",
  "x86_64-unknown-linux-gnu",
];

interface Formula {
  id: string;             // basename without .rb
  name: string;           // first url's binary-name segment (matches install line)
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

function parseArtifacts(src: string): Map<Triple, { url: string; sha256: string }> {
  // Pair every `url "..."` with the next `sha256 "..."` on a subsequent line.
  // Each url filename ends in `<triple>.tar.xz` — we extract the triple from there.
  const out = new Map<Triple, { url: string; sha256: string }>();
  const tokenRe = /^\s*(url|sha256)\s+"([^"]+)"/gm;
  let pendingUrl: string | undefined;
  let m: RegExpExecArray | null;
  while ((m = tokenRe.exec(src))) {
    const [, kind, value] = m;
    if (kind === "url") {
      pendingUrl = value;
    } else if (kind === "sha256" && pendingUrl) {
      const triple = ALL_TRIPLES.find((t) => pendingUrl!.includes(`-${t}.tar.`));
      if (triple) out.set(triple, { url: pendingUrl, sha256: value });
      pendingUrl = undefined;
    }
  }
  return out;
}

function deriveSourceRepo(anyUrl: string): { repo: string; releaseUrl: string; binaryName: string } {
  // e.g. https://github.com/HelgeSverre/fedit/releases/download/v0.0.1-test/fedit-aarch64-apple-darwin.tar.xz
  const m = anyUrl.match(/^(https:\/\/github\.com\/[^/]+\/[^/]+)\/releases\/download\/(v[^/]+)\/([^/]+)-[a-z0-9_]+-[a-z0-9_]+-[a-z0-9_]+\.tar\.[a-z]+$/);
  if (!m) throw new Error(`cannot parse release url: ${anyUrl}`);
  return { repo: m[1], releaseUrl: `${m[1]}/releases/tag/${m[2]}`, binaryName: m[3] };
}

function loadFormula(file: string): Formula {
  const src = readFileSync(file, "utf8");
  const id = basename(file, ".rb");
  const artifacts = parseArtifacts(src);
  if (artifacts.size === 0) throw new Error(`${id}: no url/sha256 pairs found`);
  const anyUrl = artifacts.values().next().value!.url;
  const { repo, releaseUrl, binaryName } = deriveSourceRepo(anyUrl);
  return {
    id,
    name: binaryName,
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
