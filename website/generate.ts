#!/usr/bin/env bun
// Regenerate dist/index.html from Formula/*.rb.
// Usage: bun run website/generate.ts
//
// All parsing lives in ./parse.ts (unit-tested). This file is the IO + templating shell.

import { readdirSync, readFileSync, writeFileSync, mkdirSync, cpSync, existsSync } from "node:fs";
import { join, dirname, basename } from "node:path";
import { fileURLToPath } from "node:url";
import { parseFormula, homepageHost, osLabel, type Formula, type Cell } from "./parse";

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = dirname(HERE);
const FORMULA_DIR = join(ROOT, "Formula");
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

function loadFormulae(): Formula[] {
  return readdirSync(FORMULA_DIR)
    .filter((f) => f.endsWith(".rb"))
    .sort()
    .map((f) => parseFormula(readFileSync(join(FORMULA_DIR, f), "utf8"), basename(f, ".rb")));
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
  return item
    .replaceAll("{{TAP}}", TAP)
    .replaceAll("{{ID}}", f.id)
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
  const formulae = loadFormulae();
  const { shell, item } = extractItemTemplate(readFileSync(TEMPLATE, "utf8"));

  const rows = formulae.map((f, i) => renderItem(item, f, FIRST_PAGE + i)).join("\n");
  const allCells = formulae.flatMap((f) => [...f.platforms.keys()]);
  const subtitle = `${formulae.length} command-line tools · ${osLabel(allCells)}`;

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

  console.log(`wrote ${formulae.length} formulae to ${join(DIST, "index.html")}`);
}

main();
