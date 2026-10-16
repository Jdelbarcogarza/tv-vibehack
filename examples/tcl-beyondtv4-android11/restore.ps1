# Undo everything done to this TV: re-enables every package in debloat.txt and the stock launcher,
# and makes the stock launcher home again. Run from anywhere:
#   powershell -ExecutionPolicy Bypass -File examples\tcl-beyondtv4-android11\restore.ps1 [-TvHost 192.168.1.79]
# Needs the venv once: python -m venv tools\venv; tools\venv\Scripts\python.exe -m pip install -r tools\requirements.txt
param([string]$TvHost = $(if ($env:TV_HOST) { $env:TV_HOST } else { '192.168.1.79' }))
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
& (Join-Path $repo 'tools\restore.ps1') -TvHost $TvHost -Stock com.google.android.tvlauncher (Join-Path $PSScriptRoot 'debloat.txt')
