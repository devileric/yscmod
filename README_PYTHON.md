# YSC APK Auto Update Tool - Python Edition

## First time

1. Install Python 3 on Windows and enable "Add Python to PATH".
2. Put the required local tools and signing JKS beside the script.
3. Copy `config.example.json` to `config.json` and fill in the local signing configuration.
4. Double-click `build_exe.bat`.

## Normal use

Drag an APK onto `YSC_AutoUpdate.exe`.

The tool decodes, patches, rebuilds, aligns, signs and verifies the APK.

Output is written to the `output` folder.

**Never publish `config.json` or your signing keystore.**
