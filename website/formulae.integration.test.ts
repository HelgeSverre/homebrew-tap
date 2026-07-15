import { test, expect } from "bun:test";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { parseFormula, type Cell } from "./parse";

// Characterization guard over the *real* Formula/*.rb set. Everything is derived
// from disk, so adding a formula needs no edits here: each formula must parse
// into the fields the site renders, with a non-empty platform matrix drawn from
// the known set. A formula in a style the parser can't read fails loudly (empty
// or unknown platforms), but a well-formed new formula is covered automatically.

const DIR = join(import.meta.dir, "..", "Formula");
const KNOWN_PLATFORMS: Cell[] = ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"];

const ids = readdirSync(DIR)
  .filter((f) => f.endsWith(".rb"))
  .map((f) => f.replace(/\.rb$/, ""))
  .sort();

test("Formula directory is non-empty", () => {
  expect(ids.length).toBeGreaterThan(0);
});

for (const id of ids) {
  test(`${id}: renders every field the site needs, with a valid platform matrix`, () => {
    const f = parseFormula(readFileSync(join(DIR, `${id}.rb`), "utf8"), id);

    expect(f.name).toBe(id);
    expect(f.desc.length).toBeGreaterThan(0);
    expect(f.homepage).toMatch(/^https?:\/\//);
    expect(f.version).toMatch(/^\d+\.\d+\.\d+$/);
    expect(f.license.length).toBeGreaterThan(0);

    const platforms = [...f.platforms.keys()];
    expect(platforms.length).toBeGreaterThan(0);
    for (const p of platforms) {
      expect(KNOWN_PLATFORMS).toContain(p);
    }
  });
}
