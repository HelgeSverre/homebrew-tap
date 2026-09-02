import { test, expect } from "bun:test";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { parseFormula, parseCask, type Cell } from "./parse";

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

// Same guard over Casks/*.rb (macOS apps). The directory may not exist yet;
// the first cask is pushed by the app's own release workflow.

const CASK_DIR = join(import.meta.dir, "..", "Casks");
const caskIds = existsSync(CASK_DIR)
  ? readdirSync(CASK_DIR)
      .filter((f) => f.endsWith(".rb"))
      .map((f) => f.replace(/\.rb$/, ""))
      .sort()
  : [];

for (const id of caskIds) {
  test(`cask ${id}: renders every field the site needs, mac-only platforms`, () => {
    const c = parseCask(readFileSync(join(CASK_DIR, `${id}.rb`), "utf8"), id);

    expect(c.kind).toBe("cask");
    expect(c.name).toBe(id);
    expect(c.desc.length).toBeGreaterThan(0);
    expect(c.homepage).toMatch(/^https?:\/\//);
    // Cask versions may carry a build suffix, e.g. "1.2.3,456".
    expect(c.version).toMatch(/^\d+(\.\d+)*(,[\w.-]+)?$/);

    const platforms = [...c.platforms.keys()];
    expect(platforms.length).toBeGreaterThan(0);
    for (const p of platforms) {
      expect(p).toMatch(/^mac-/);
    }
  });
}
