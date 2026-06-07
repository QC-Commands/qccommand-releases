# QC Command — Releases

Public download repository for **QC Command**, a menu bar app for controlling Bose QC Ultra headphones (Listening Mode, EQ, battery, automation).

Source code is private — this repo hosts release downloads only.

## Download

Grab the latest `.zip` from the [Releases page](../../releases).

## Installation

1. Download the `.zip` and unzip it
2. Move `QCCommand.app` to `/Applications`
3. **If macOS says "QCCommand is damaged and can't be opened"** — this is a known Gatekeeper quirk with ad-hoc signed apps; the app is *not* actually damaged. Open Terminal and run:
   ```
   xattr -cr /Applications/QCCommand.app
   ```
   Then open the app normally.
4. Grant Bluetooth permission when prompted
