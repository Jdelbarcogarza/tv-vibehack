# TCL Smart TV Pro (BeyondTV4), Android TV 11

What was done to this TV, and how to change or undo any of it. Commands assume the repo root as the
working directory and the TV at `192.168.1.79`; replace the IP if your router hands it a new one
(Settings → Network & Internet on the TV shows it).

One-time setup on a new computer:

```powershell
python -m venv tools\venv; tools\venv\Scripts\python.exe -m pip install -r tools\requirements.txt
```

The first connection shows "Allow USB debugging?" on the TV. Tick "Always allow" and press OK.

## What changed

- **Disabled** (not uninstalled) the 28 packages in [`debloat.txt`](debloat.txt): TCL telemetry,
  TCL Channel and other content and ad services, T-Guard, and preloaded apps you don't use.
- **Kept**: Live TV and HDMI, the remote, Bluetooth, the keyboard, Play Store, Google Assistant,
  Chromecast, the phone remote, and **TCL firmware updates** (the TV still offers updates on
  screen as before).
- **Installed** the launcher `com.gathin.tvhome` as home and disabled the stock
  `com.google.android.tvlauncher`.
- **Screensaver** set to the launcher's Clock.

## Re-enable one app

```powershell
$env:TV_HOST = '192.168.1.79'
tools\venv\Scripts\python.exe -I tools\tv.py 'pm enable com.tcl.ui_mediaCenter'
```

Use the package name from `debloat.txt`; each line says what the app is. To keep it enabled the
next time the list is applied, put a `#` in front of its line. You can also do it on the TV:
Settings → Apps → See all apps → Show system apps → the app → Enable.

## Undo everything

```powershell
powershell -ExecutionPolicy Bypass -File examples\tcl-beyondtv4-android11\restore.ps1
```

`restore.sh` next to it does the same from macOS, Linux or Git Bash. Pass `-TvHost <ip>` (or set
`TV_HOST`) if the TV's address has changed.

This re-enables every package in the list and the stock launcher, and makes the stock launcher home
again. The packages that were already disabled at the factory (the Freeview UK apps, Stan, Rakuten,
Reminder) aren't in the list and stay as they were. To also remove the new launcher:
`tools\tv.py 'pm uninstall com.gathin.tvhome'`.

The backup taken before any change (package lists, getprop, all settings) and a copy of this
restore script are in `backup\tcl-beyondtv4-20261016-1351\` on the computer that did the setup.

## Re-apply after a firmware update

A TCL update can re-enable packages or bring the stock home screen back. Run both:

```powershell
powershell -ExecutionPolicy Bypass -File tools\disable.ps1 -TvHost 192.168.1.79 examples\tcl-beyondtv4-android11\debloat.txt
powershell -ExecutionPolicy Bypass -File launcher\build-and-install.ps1 -TvHost 192.168.1.79
```

## Change the dock order

Edit `dock_apps` in
[`launcher/app/src/main/res/values/config.xml`](../../launcher/app/src/main/res/values/config.xml).
It's a priority list: the dock shows the **first four that are installed**, left to right. The
current list is Netflix, Prime Video, YouTube, ViX, Disney+, HBO Max, DAZN, MLB, so after you
install ViX it replaces MLB on its own without a rebuild. To change the order, move the lines and
rebuild:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-21'
powershell -ExecutionPolicy Bypass -File launcher\build-and-install.ps1 -TvHost 192.168.1.79
```

To find an app's package name: `tools\tv.py 'pm list packages'`. Apps listed in `hidden_apps`
never get a tile (Live TV is hidden there because the Inputs menu covers it).

## Change the wallpaper

The background is pitch black by default. To use an image:

1. Save a **dark** 1920×1080 JPEG as `launcher\app\src\main\res\drawable-nodpi\wallpaper_image.jpg`
   (white text sits on top of it, and the image is stretched to the screen, so use 16:9).
2. In `config.xml`, replace `<drawable name="wallpaper">#FF000000</drawable>` with
   `<item name="wallpaper" type="drawable">@drawable/wallpaper_image</item>`.
3. Rebuild with the command above.

To go back to black, undo step 2 and delete only `wallpaper_image.jpg`. The same folder holds
`banner.jpg`, which the launcher needs.

## Screensaver

```powershell
tools\venv\Scripts\python.exe -I tools\tv.py 'settings put secure screensaver_components com.gathin.tvhome/.ClockDream'
```

For the plain stock one, use `com.android.dreams.basic/.Colors` instead.

## Notes for this model

- Screenshots come out blank while an HDMI source or Live TV is on screen. Press Home first.
- Play Protect blocks sideloaded apps that target an old Android version ("built for an older
  version of Android"). The launcher now targets SDK 34, so it installs without that prompt.
- Long-press OK on a tile to open that app's settings page (force stop, clear data, disable).
