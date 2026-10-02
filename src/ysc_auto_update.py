import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


def resource_root() -> Path:
    if getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS"):
        return Path(sys._MEIPASS)
    return Path(__file__).resolve().parent


def app_root() -> Path:
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


RES = resource_root()
APP = app_root()
CFG = RES / "config.json"


def load_config():
    return json.loads(CFG.read_text(encoding="utf-8"))


def java_path():
    java = shutil.which("java")
    if not java:
        raise RuntimeError("Java 8 or newer was not found. Install Java and try again.")
    return Path(java)


def run(cmd, cwd=None):
    printable = " ".join(f'"{x}"' if " " in str(x) else str(x) for x in cmd)
    print("\n> " + printable, flush=True)
    result = subprocess.run([str(x) for x in cmd], cwd=cwd)
    if result.returncode != 0:
        raise RuntimeError(f"Command failed with exit code {result.returncode}.")


def apktool_decode(apk, work):
    run([java_path(), "-jar", RES / "apktool.jar", "d", "-f", apk, "-o", work])


def apktool_build(work, unsigned):
    run([java_path(), "-jar", RES / "apktool.jar", "b", work, "-o", unsigned])


def patch_project(work, cfg):
    patch_root = RES / "patch"
    if not patch_root.exists():
        raise RuntimeError("Patch directory is missing from the tool package.")
    for src in patch_root.rglob("*"):
        if src.is_file():
            rel = src.relative_to(patch_root)
            dst = work / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)
    assets = work / "assets"
    assets.mkdir(exist_ok=True)
    (assets / "ysc_update_source.txt").write_text(cfg["update_url"], encoding="utf-8")


def sign_and_verify(unsigned, out, cfg):
    keystore = RES / cfg["keystore"]
    if not keystore.exists():
        raise RuntimeError(f"Keystore not found: {keystore}")
    outdir = out.parent
    outdir.mkdir(parents=True, exist_ok=True)

    run([
        java_path(), "-jar", RES / "apksigner.jar", "-a", unsigned,
        "--allowResign", "--ks", keystore,
        "--ksAlias", cfg["alias"],
        "--ksPass", cfg["password"],
        "--ksKeyPass", cfg["password"],
        "-o", outdir,
    ])

    candidates = [
        outdir / (Path(unsigned).stem + "-aligned-signed.apk"),
        outdir / (Path(unsigned).stem + "-aligned-debugSigned.apk"),
    ]
    produced = next((p for p in candidates if p.exists()), None)
    if produced is None:
        signed = sorted(outdir.glob("*-signed.apk"), key=lambda p: p.stat().st_mtime, reverse=True)
        produced = signed[0] if signed else None
    if produced is None:
        raise RuntimeError("The signing tool did not produce a signed APK.")
    if produced.resolve() != out.resolve():
        if out.exists():
            out.unlink()
        produced.replace(out)

    run([java_path(), "-jar", RES / "apksigner.jar", "-a", out, "-y"])


def process(apk):
    cfg = load_config()
    apk = Path(apk).resolve()
    if not apk.is_file() or apk.suffix.lower() != ".apk":
        raise RuntimeError("Input must be an APK file.")

    outdir = APP / "output"
    outdir.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="ysc_update_") as td:
        td = Path(td)
        decoded = td / "decoded"
        unsigned = td / "unsigned.apk"
        apktool_decode(apk, decoded)
        print("\n[1/4] APK decoded.")
        patch_project(decoded, cfg)
        print("[2/4] Update module patched.")
        apktool_build(decoded, unsigned)
        print("[3/4] APK rebuilt.")
        out = outdir / f"{apk.stem}_update_signed.apk"
        sign_and_verify(unsigned, out, cfg)
        print("[4/4] APK aligned, signed and verified.")
        print(f"\nDONE: {out}")
        return out


def main():
    try:
        if len(sys.argv) < 2:
            print("Usage: drag an APK onto YSC_AutoUpdate.exe")
            input("Press Enter to exit...")
            return 2
        process(sys.argv[1])
        input("\nFinished. Press Enter to exit...")
        return 0
    except Exception as exc:
        print(f"\n[ERROR] {exc}")
        input("Press Enter to exit...")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
