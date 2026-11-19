import { test, expect } from "bun:test";
import { mkdtempSync, mkdirSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { loadItems } from "./generate";

const good = `class Good < Formula
  desc "Works"
  homepage "https://example.com"
  version "1.0.0"
  license "MIT"
  on_macos do
    on_arm do
      url "https://example.com/good-aarch64-apple-darwin.tar.xz"
      sha256 "abc"
    end
  end
end
`;

test("a file the parser can't read is skipped, the rest still load", () => {
  const root = mkdtempSync(join(tmpdir(), "tap-"));
  mkdirSync(join(root, "Formula"));
  writeFileSync(join(root, "Formula", "good.rb"), good);
  writeFileSync(join(root, "Formula", "broken.rb"), "class Broken < Formula\nend\n");

  const { items, skipped } = loadItems(root);

  expect(items.map((f) => f.id)).toEqual(["good"]);
  expect(skipped.map((s) => s.file)).toEqual([join(root, "Formula", "broken.rb")]);
});
