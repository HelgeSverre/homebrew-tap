// Pure parsing for Homebrew formulae — no filesystem access, so it stays unit-testable.
//
// Platform support is derived from the Ruby OS/CPU *block structure*
// (`if OS.mac?` / `on_macos` + `Hardware::CPU.arm?` / `on_arm`), never from the
// release filename: the tap mixes four filename schemes (Rust triples, macos-arm64,
// darwin-amd64, and extensionless raw binaries) and some have no archive extension
// at all, so any filename-based scheme is fragile.

export type Cell = "mac-arm64" | "mac-x86_64" | "linux-arm64" | "linux-x86_64";

export interface Artifact {
  url: string;
  sha256: string;
}

export type Kind = "formula" | "cask";

export interface Formula {
  kind: Kind;
  id: string; // basename without .rb — also the `brew install helgesverre/tap/<id>` target
  name: string; // display/install name (== id)
  desc: string;
  homepage: string;
  version: string;
  license: string;
  platforms: Map<Cell, Artifact>;
}

function readField(src: string, field: string): string {
  const m = src.match(new RegExp(`^\\s*${field}\\s+"([^"]*)"`, "m"));
  if (!m) throw new Error(`missing field '${field}'`);
  return m[1];
}

function readFieldOpt(src: string, field: string): string | undefined {
  return src.match(new RegExp(`^\\s*${field}\\s+"([^"]*)"`, "m"))?.[1];
}

type Os = "mac" | "linux" | undefined;
type Arch = "arm64" | "x86_64" | undefined;

function cell(os: Os, arch: Arch): Cell | undefined {
  if (!os || !arch) return undefined;
  return `${os}-${arch}` as Cell;
}

export function parsePlatforms(src: string): Map<Cell, Artifact> {
  const out = new Map<Cell, Artifact>();
  let os: Os;
  let arch: Arch;
  let pendingUrl: string | undefined;
  let pendingCell: Cell | undefined;

  for (const line of src.split("\n")) {
    // OS context first — entering an OS block resets the arch context.
    // (handles compound one-liners like `if OS.linux? && Hardware::CPU.intel?`)
    if (line.includes("OS.mac?") || line.includes("on_macos")) {
      os = "mac";
      arch = undefined;
    } else if (line.includes("OS.linux?") || line.includes("on_linux")) {
      os = "linux";
      arch = undefined;
    }
    // Arch context — may co-occur with the OS token on a compound line.
    if (line.includes("Hardware::CPU.arm?") || line.includes("on_arm")) {
      arch = "arm64";
    } else if (line.includes("Hardware::CPU.intel?") || line.includes("on_intel")) {
      arch = "x86_64";
    }

    const u = line.match(/\burl\s+"([^"]+)"/);
    if (u) {
      pendingUrl = u[1];
      pendingCell = cell(os, arch);
      continue;
    }
    const s = line.match(/\bsha256\s+"([^"]+)"/);
    if (s && pendingUrl && pendingCell) {
      out.set(pendingCell, { url: pendingUrl, sha256: s[1] });
      pendingUrl = undefined;
      pendingCell = undefined;
    }
  }
  return out;
}

/** Display host for a homepage URL: drop the scheme, a leading `www.`, and any trailing slash. */
export function homepageHost(url: string): string {
  return url.replace(/^https?:\/\//, "").replace(/^www\./, "").replace(/\/+$/, "");
}

/** Human summary of which OSes have at least one build, e.g. "macOS + Linux". */
export function osLabel(cells: Cell[]): string {
  const parts: string[] = [];
  if (cells.some((c) => c.startsWith("mac"))) parts.push("macOS");
  if (cells.some((c) => c.startsWith("linux"))) parts.push("Linux");
  return parts.join(" + ");
}

export function parseFormula(src: string, id: string): Formula {
  return {
    kind: "formula",
    id,
    name: id,
    desc: readField(src, "desc"),
    homepage: readField(src, "homepage"),
    version: readField(src, "version"),
    license: readFieldOpt(src, "license") ?? "—",
    platforms: parsePlatforms(src),
  };
}

/**
 * Cask platforms. A cask is macOS by definition, so only the arch context
 * matters: `on_arm` / `on_intel` blocks each carry a `url`; a bare `url` with
 * no arch block is a universal build and counts for both. Hashes live in a
 * single `sha256 arm: "…", intel: "…"` stanza (possibly wrapped over two
 * lines), a plain `sha256 "…"`, or `sha256 :no_check` — the site never renders
 * them, so a missing hash must not drop the platform.
 */
export function parseCaskPlatforms(src: string): Map<Cell, Artifact> {
  const sha = (label: string) => src.match(new RegExp(`\\b${label}:\\s*"([^"]*)"`))?.[1];
  const plain = src.match(/^\s*sha256\s+"([^"]*)"/m)?.[1];
  const shaFor: Record<"arm64" | "x86_64", string> = {
    arm64: sha("arm") ?? plain ?? "",
    x86_64: sha("intel") ?? plain ?? "",
  };

  const out = new Map<Cell, Artifact>();
  let arch: Arch;
  for (const line of src.split("\n")) {
    if (line.includes("on_arm")) arch = "arm64";
    else if (line.includes("on_intel")) arch = "x86_64";

    const u = line.match(/\burl\s+"([^"]+)"/);
    if (!u) continue;
    const arches: ("arm64" | "x86_64")[] = arch ? [arch] : ["arm64", "x86_64"];
    for (const a of arches) out.set(`mac-${a}` as Cell, { url: u[1], sha256: shaFor[a] });
  }
  return out;
}

export function parseCask(src: string, id: string): Formula {
  return {
    kind: "cask",
    id,
    name: id,
    desc: readField(src, "desc"),
    homepage: readField(src, "homepage"),
    version: readField(src, "version"),
    license: "—",
    platforms: parseCaskPlatforms(src),
  };
}
