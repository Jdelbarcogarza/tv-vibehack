#!/usr/bin/env bash
# Undo everything done to this TV (see restore.ps1). Usage: [TV_HOST=ip] examples/tcl-beyondtv4-android11/restore.sh
here="$(cd "$(dirname "$0")" && pwd)"
TV_HOST="${TV_HOST:-192.168.1.79}" exec "$here/../../tools/restore.sh" "$here/debloat.txt" com.google.android.tvlauncher
