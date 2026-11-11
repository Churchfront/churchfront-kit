# CueKit

The code the Cue apps share. Fix it once here and every app gets it on its next update.

| Module | What it holds | Replaces |
|---|---|---|
| `CueDesign` | Signal colours (the neutral grey ramp), spacing, Figtree, panel labels, button press style | `Theme.swift` in CueStack, CueTracks, CueVideo |
| `CueNDI` | NDI in and out, loading the runtime at run time (no SDK needed to build) | `NDIBridge` in CueScreens and CueVideo |

Planned, in order: `CueATEM` (switcher + PTZ, from CueVideo), `CueMIDI` and `CueOSC`, `CueConnector` (shared Claude connector plumbing), then `CueLink`, the one protocol every Cue app uses to find and follow the others.

### CueCloud (later)

One sign-in to the Churchfront portal (app.churchfront.com) shared by every Cue app on a Mac, tied to the church's account. The use cases aren't decided yet. The ones in view:

- **Sign in once.** Every Cue app on the Mac uses the same portal session, kept in the Keychain.
- **Licensing.** Which apps and tiers a church's plan includes (Stripe stays the record for payment).
- **The church's system.** Venues, gear, patch sheets and schematics from the portal, so the apps know the room they run in.
- **Sync and backup.** Shows, libraries, looks and themes, shared across a church's booth Macs and campuses.
- **Support.** Logs and crash reports to the help desk, and remote help from Churchfront staff with the church's permission.

Rules for when it's built: every Cue app must keep running a service with no internet. The cloud adds things but never stands between the operator and GO. The portal's Supabase row-level security decides what each church can see, same as on the web.

## Using it in an app

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Churchfront/CueKit.git", from: "0.2.0"),
],
targets: [
    .executableTarget(name: "MyApp", dependencies: [
        .product(name: "CueDesign", package: "CueKit"),
        .product(name: "CueNDI", package: "CueKit"),
    ]),
]
```

```swift
import CueDesign
SignalFont.register()                        // once at launch
Text("Program").signalPanelLabel()
view.background(SignalColor.surface)

import CueNDI
ndi_set_app_name("CueVideo")              // the name other NDI devices see
```

To try a CueKit change inside an app before it is released, point the app at your local copy: `swift package edit CueKit --path ../CueKit`, and `swift package unedit CueKit` when done.

## Rules

- **Versions.** Every release is a tag (`0.1.0`, `0.2.0`). Apps pin `from:` a version and move up when they are ready. Breaking changes bump the minor version while we are below 1.0.
- **Names.** Design types start with `Signal` (after the Churchfront Signal design system) so they never clash with app types like CueStack's `CueColor` cue tags.
- **Nothing app-specific.** If only one app needs it, it stays in that app. Things move here once two apps need them.
- **The dark ramp is neutral grey**, never blue-tinted. A test enforces it.
- **Reviews.** Changes here reach every app, so Jake and Matt both review (see `CODEOWNERS`).
- **Platforms.** macOS 14 and iOS 17, the lowest any Cue app targets.

## NDI

NDI is a registered trademark of Vizrt NDI AB. CueKit ships no NDI runtime: it loads one from NDI Tools or the NDI SDK. Set `CUE_NDI_BORROW=1` on a developer Mac to use ProPresenter's copy for testing (that copy is ProPresenter's licence, so never in a release).

Figtree is licensed under the SIL Open Font License 1.1.
