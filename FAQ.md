# QC Command — FAQ & Troubleshooting

## "QCCommand is damaged and can't be opened"

This is **not** real damage — it's a Gatekeeper quirk with apps that aren't notarized by Apple (QC Command is currently ad-hoc signed). macOS shows this scary message instead of the normal "from an unidentified developer" prompt because the quarantine flag set by your browser conflicts with the app's signature.

**Fix:**
1. Move `QCCommand.app` to `/Applications`
2. Open Terminal and run:
   ```
   xattr -cr /Applications/QCCommand.app
   ```
3. Open the app normally — the warning is gone for good

---

## Bluetooth: the app can't find my headphones

1. Make sure your Bose QC Ultra / QC Ultra 2 are connected via Bluetooth in System Settings → Bluetooth
2. Grant Bluetooth access: System Settings → Privacy & Security → Bluetooth → enable QC Command
3. **Close the Bose Music app** — it can hold the connection and block QC Command from sending mode commands
4. If you just granted permission, fully quit and relaunch QC Command (menu bar icon → Quit, then reopen)

---

## Keyboard shortcuts don't trigger (or only work while the app is open)

Global shortcuts need **two separate permissions** — both must be granted:

| Permission | Why it's needed | Where to enable |
|---|---|---|
| **Input Monitoring** | Lets QC Command see key presses system-wide | System Settings → Privacy & Security → Input Monitoring |
| **Accessibility** | Lets QC Command react to key presses while another app is active | System Settings → Privacy & Security → Accessibility |

Open the **Shortcuts** tab in QC Command — it detects which of these is missing and shows a button that opens the right settings pane directly.

### "I already enabled it, but shortcuts still don't work outside the app"

This happens after updating QC Command. Each build has a slightly different app signature, and macOS can leave a **stale permission entry** bound to the old version — the toggle looks "on," but it's actually denied for the new build.

**Fix:**
1. Open the relevant Settings pane (Input Monitoring and/or Accessibility)
2. Select **QC Command** in the list and remove it with the **−** button
3. Quit and relaunch QC Command
4. Re-grant the permission when prompted (or use the button in the Shortcuts tab)

This will be fixed permanently once the app is signed with an Apple Developer ID — for now, it can recur after each update.

---

## Battery percentage isn't showing / isn't accurate

Battery is read directly over Bluetooth from your headphones. If it's missing:
- Make sure the headphones are connected and powered on
- Wait a few seconds after connecting — the first read can take a moment
- Reconnecting the headphones (toggle Bluetooth off/on) usually resolves stale readings

---

## My trial ended — what now?

QC Command includes a 14-day free trial. Once it ends, you'll see a locked screen where you can:
- **Enter a license key** if you've already purchased one, or
- **Purchase a license** via the link provided (opens the checkout page in your browser)

A license activates on **one device at a time**. To move it to a new Mac, deactivate it first from the About tab on the old device, then activate it on the new one.

---

## How do I check for updates?

Open the **About** tab → **Software Update** section → **Check for Updates**. If a newer version is available, you'll get a direct download link.

---

## Still stuck?

Open an issue or reach out — include:
- Your macOS version (Apple menu → About This Mac)
- Your headphone model (QC Ultra / QC Ultra 2)
- Whatever you see in the relevant Settings → Privacy & Security pane for QC Command
