import { test, expect } from "bun:test";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { parseFormula, type Cell } from "./parse";

// Characterization guard over the *real* Formula/*.rb set: proves every field the
// site renders is derivable with zero hardcoding, and pins the expected platform
// matrix so a future formula in an unhandled style fails loudly here.

const DIR = join(import.meta.dir, "..", "Formula");
const load = (id: string) => parseFormula(readFileSync(join(DIR, `${id}.rb`), "utf8"), id);

const EXPECTED: Record<string, Cell[]> = {
  dbdump: ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"],
  fedit: ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"],
  glue: ["mac-arm64", "linux-arm64", "linux-x86_64"], // no Intel Mac (odie)
  jake: ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"],
  "sema-lang": ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"],
  "sql-splitter": ["mac-arm64", "mac-x86_64", "linux-arm64", "linux-x86_64"],
  token: ["mac-arm64", "mac-x86_64", "linux-x86_64"], // no Linux arm64
};

test("every formula on disk has an expectation here", () => {
  const ids = readdirSync(DIR).filter((f) => f.endsWith(".rb")).map((f) => f.replace(/\.rb$/, ""));
  expect(ids.sort()).toEqual(Object.keys(EXPECTED).sort());
});

for (const [id, cells] of Object.entries(EXPECTED)) {
  test(`${id}: scalar fields present and platform matrix matches`, () => {
    const f = load(id);
    expect(f.name).toBe(id);
    expect(f.desc.length).toBeGreaterThan(0);
    expect(f.homepage).toMatch(/^https?:\/\//);
    expect(f.version).toMatch(/^\d+\.\d+\.\d+$/);
    expect(f.license).toBe("MIT");
    expect([...f.platforms.keys()].sort()).toEqual([...cells].sort());
  });
}
