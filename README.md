# FH_AutoPatch
a Powershell script for auto patch creation (made for Fiesta Heroes Launcher IIS-Setup).

**This Script only works for files pulled from a git repository that is setup in your Shine-directory.**

**Make sure the Fiesta Heros Launcher is set Extension=.zip**

## How2Use
```bash
1. Put "autopatchFiles.txt" & "createPatch.ps1" into Server Main directory (E.g. NA2016-main/Server)

2. If your patch directory is NOT in default IIS-path replace "$destinationRootPath"-value with the actual directory.

3. If a file you want to include to AutoPatch is missing simply add it to "autopatchFiles.txt" 
```

