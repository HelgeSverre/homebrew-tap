#!/usr/bin/env bun
// Regenerate dist/index.html from Formula/*.rb and Casks/*.rb.
// Usage: bun run website/generate.ts
//
// All parsing lives in ./parse.ts (unit-tested). This file is the IO + templating shell.

import { readdirSync, readFileSync, writeFileSync, mkdirSync, cpSync, existsSync } from "node:fs";
import { join, dirname, basename } from "node:path";
import { fileURLToPath } from "node:url";
import { parseFormula, parseCask, homepageHost, osLabel, type Formula, type Cell } from "./parse";

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = dirname(HERE);
const FORMULA_DIR = join(ROOT, "Formula");
const CASK_DIR = join(ROOT, "Casks");
const TEMPLATE = join(HERE, "template.html");
const DIST = join(ROOT, "dist");
const CNAME = join(HERE, "CNAME");

const TAP = "helgesverre/tap";
const FIRST_PAGE = 201;

const TICK = `<span class="on">✓</span>`;
const TICK_OFF = `<span class="no">·</span>`;
const YES = `<span class="yes">✓ yes</span>`;
const NO = `<span class="nope">· no</span>`;

function escapeHtml(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function loadDir(dir: string, parse: (src: string, id: string) => Formula): Formula[] {
  if (!existsSync(dir)) return [];
  return readdirSync(dir)
    .filter((f) => f.endsWith(".rb"))
    .sort()
    .map((f) => parse(readFileSync(join(dir, f), "utf8"), basename(f, ".rb")));
}

function loadItems(): Formula[] {
  // One mixed alphabetical index; casks are marked with an APP tag.
  return [...loadDir(FORMULA_DIR, parseFormula), ...loadDir(CASK_DIR, parseCask)].sort((a, b) =>
    a.id.localeCompare(b.id),
  );
}

function title(): string {
  // The hero/title is the site's own domain, taken from the deployed CNAME.
  return existsSync(CNAME) ? readFileSync(CNAME, "utf8").trim() : TAP;
}

function extractItemTemplate(tpl: string): { shell: string; item: string } {
  const m = tpl.match(/<template id="formula-item">([\s\S]*?)<\/template>/);
  if (!m) throw new Error('template.html: missing <template id="formula-item">');
  const shell = tpl.slice(0, tpl.indexOf("<!--")).trimEnd() + "\n";
  return { shell, item: m[1].trim() };
}

function renderItem(item: string, f: Formula, page: number): string {
  const has = (c: Cell) => f.platforms.has(c);
  const macAny = has("mac-arm64") || has("mac-x86_64");
  const lnxAny = has("linux-arm64") || has("linux-x86_64");
  const cask = f.kind === "cask";
  return item
    .replaceAll("{{TAP}}", TAP)
    .replaceAll("{{ID}}", f.id)
    .replaceAll("{{INSTALL}}", `brew install ${cask ? "--cask " : ""}${TAP}/${f.id}`)
    .replaceAll("{{SRC_DIR}}", cask ? "Casks" : "Formula")
    .replaceAll("{{KIND_TAG}}", cask ? `<span class="kind">APP</span>` : "")
    .replaceAll("{{PAGE}}", String(page))
    .replaceAll("{{NAME}}", escapeHtml(f.name))
    .replaceAll("{{DESC}}", escapeHtml(f.desc))
    .replaceAll("{{VERSION}}", escapeHtml(f.version))
    .replaceAll("{{LICENSE}}", escapeHtml(f.license))
    .replaceAll("{{HOMEPAGE}}", escapeHtml(f.homepage))
    .replaceAll("{{HOMEPAGE_HOST}}", escapeHtml(homepageHost(f.homepage)))
    .replaceAll("{{MAC}}", macAny ? TICK : TICK_OFF)
    .replaceAll("{{LNX}}", lnxAny ? TICK : TICK_OFF)
    .replaceAll("{{MAC_ARM}}", has("mac-arm64") ? YES : NO)
    .replaceAll("{{MAC_X64}}", has("mac-x86_64") ? YES : NO)
    .replaceAll("{{LNX_ARM}}", has("linux-arm64") ? YES : NO)
    .replaceAll("{{LNX_X64}}", has("linux-x86_64") ? YES : NO);
}

function main() {
  const formulae = loadItems();
  const { shell, item } = extractItemTemplate(readFileSync(TEMPLATE, "utf8"));

  const rows = formulae.map((f, i) => renderItem(item, f, FIRST_PAGE + i)).join("\n");
  const allCells = formulae.flatMap((f) => [...f.platforms.keys()]);
  const tools = formulae.filter((f) => f.kind === "formula").length;
  const apps = formulae.length - tools;
  const counts = `${tools} command-line tools` + (apps ? ` + ${apps} ${apps === 1 ? "app" : "apps"}` : "");
  const subtitle = `${counts} · ${osLabel(allCells)}`;

  const html = shell
    .replaceAll("{{TITLE}}", escapeHtml(title()))
    .replaceAll("{{SUBTITLE}}", escapeHtml(subtitle))
    .replaceAll("{{COUNT}}", String(formulae.length))
    .replaceAll("{{TAP}}", TAP)
    .replaceAll("{{ROWS}}", rows);

  mkdirSync(DIST, { recursive: true });
  writeFileSync(join(DIST, "index.html"), html);
  if (existsSync(CNAME)) cpSync(CNAME, join(DIST, "CNAME"));
  // Tell GitHub Pages not to run Jekyll (otherwise underscore-prefixed paths break).
  writeFileSync(join(DIST, ".nojekyll"), "");

  console.log(`wrote ${formulae.length} items to ${join(DIST, "index.html")}`);
}

main();
