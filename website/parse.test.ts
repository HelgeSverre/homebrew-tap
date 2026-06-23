import { test, expect } from "bun:test";
import { parsePlatforms, parseFormula } from "./parse";

// Platform detection must come from the Ruby OS/CPU block structure,
// NOT the release filename — the tap uses four different filename schemes.

test("if-blocks with Rust-triple filenames map all four cells", () => {
  const src = `
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://x/foo-aarch64-apple-darwin.tar.xz"
      sha256 "macarm"
    end
    if Hardware::CPU.intel?
      url "https://x/foo-x86_64-apple-darwin.tar.xz"
      sha256 "macx64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://x/foo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "lnxarm"
    end
    if Hardware::CPU.intel?
      url "https://x/foo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "lnxx64"
    end
  end`;
  const p = parsePlatforms(src);
  expect(p.get("mac-arm64")?.sha256).toBe("macarm");
  expect(p.get("mac-x86_64")?.sha256).toBe("macx64");
  expect(p.get("linux-arm64")?.sha256).toBe("lnxarm");
  expect(p.get("linux-x86_64")?.sha256).toBe("lnxx64");
  expect(p.size).toBe(4);
});

test("if-blocks with extensionless raw-binary filenames (jake) map all four cells", () => {
  // jake ships bare binaries: no `.tar.*` — the old filename parser found zero artifacts here.
  const src = `
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://x/jake-macos-aarch64"
      sha256 "macarm"
    end
    if Hardware::CPU.intel?
      url "https://x/jake-macos-x86_64"
      sha256 "macx64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://x/jake-linux-aarch64"
      sha256 "lnxarm"
    end
    if Hardware::CPU.intel?
      url "https://x/jake-linux-x86_64"
      sha256 "lnxx64"
    end
  end`;
  const p = parsePlatforms(src);
  expect(p.size).toBe(4);
  expect(p.get("mac-arm64")?.sha256).toBe("macarm");
  expect(p.get("linux-x86_64")?.url).toBe("https://x/jake-linux-x86_64");
});

test("on_macos/on_arm blocks with an odie gap (glue) skip the unshipped cell", () => {
  const src = `
  on_macos do
    on_arm do
      url "https://x/glue-macos-arm64.tar.gz"
      sha256 "macarm"
    end
    on_intel do
      odie "glue does not ship Intel Mac binaries. Apple Silicon (arm64) only."
    end
  end
  on_linux do
    on_intel do
      url "https://x/glue-linux-x64.tar.gz"
      sha256 "lnxx64"
    end
    on_arm do
      url "https://x/glue-linux-arm64.tar.gz"
      sha256 "lnxarm"
    end
  end`;
  const p = parsePlatforms(src);
  expect(p.size).toBe(3);
  expect(p.get("mac-arm64")?.sha256).toBe("macarm");
  expect(p.has("mac-x86_64")).toBe(false);
  expect(p.get("linux-arm64")?.sha256).toBe("lnxarm");
  expect(p.get("linux-x86_64")?.sha256).toBe("lnxx64");
});

test("compound single-line guard (token) maps only its one cell", () => {
  const src = `
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://x/token-aarch64-apple-darwin.tar.xz"
      sha256 "macarm"
    end
    if Hardware::CPU.intel?
      url "https://x/token-x86_64-apple-darwin.tar.xz"
      sha256 "macx64"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://x/token-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "lnxx64"
  end`;
  const p = parsePlatforms(src);
  expect(p.size).toBe(3);
  expect(p.get("mac-arm64")?.sha256).toBe("macarm");
  expect(p.get("mac-x86_64")?.sha256).toBe("macx64");
  expect(p.get("linux-x86_64")?.sha256).toBe("lnxx64");
  expect(p.has("linux-arm64")).toBe(false);
});

test("parseFormula reads scalar fields and uses the basename as the install name", () => {
  const src = `class SqlSplitter < Formula
  desc "High-performance CLI tool for splitting large SQL dump files into individual table files"
  homepage "https://github.com/helgesverre/sql-splitter"
  version "1.13.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://x/sql-splitter-aarch64-apple-darwin.tar.xz"
      sha256 "macarm"
    end
  end
  license "MIT"
end`;
  const f = parseFormula(src, "sql-splitter");
  expect(f.id).toBe("sql-splitter");
  expect(f.name).toBe("sql-splitter"); // install target = basename, not the URL-derived "sql"
  expect(f.version).toBe("1.13.6");
  expect(f.license).toBe("MIT");
  expect(f.homepage).toBe("https://github.com/helgesverre/sql-splitter");
  expect(f.desc).toContain("splitting large SQL dump files");
  expect(f.platforms.get("mac-arm64")?.sha256).toBe("macarm");
});

test("missing license falls back to a dash", () => {
  const src = `class X < Formula
  desc "d"
  homepage "https://x"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://x/x-aarch64-apple-darwin.tar.xz"
      sha256 "a"
    end
  end
end`;
  const f = parseFormula(src, "x");
  expect(f.license).toBe("—");
});

import { homepageHost, osLabel } from "./parse";

test("homepageHost strips protocol, leading www and trailing slash", () => {
  expect(homepageHost("https://github.com/helgesverre/dbdump")).toBe("github.com/helgesverre/dbdump");
  expect(homepageHost("https://www.jakefile.dev/")).toBe("jakefile.dev");
  expect(homepageHost("https://getglue.dev")).toBe("getglue.dev");
  expect(homepageHost("http://token-editor.com/")).toBe("token-editor.com");
});

test("osLabel summarises which operating systems have builds", () => {
  expect(osLabel(["mac-arm64", "linux-x86_64"])).toBe("macOS + Linux");
  expect(osLabel(["mac-arm64", "mac-x86_64"])).toBe("macOS");
  expect(osLabel(["linux-arm64", "linux-x86_64"])).toBe("Linux");
  expect(osLabel([])).toBe("");
});
