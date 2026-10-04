# Community Music App

Flutter Android-first prototype for a community music service. The working brand in the prototype is **Soundroom** and should be replaced once the owner chooses a name.

## Current prototype

- Home feed with featured music, local artist discovery, and song cards
- Search view
- Upload flow mock-up for artist submissions
- Library view
- Mini-player interaction mock-up
- Uploads are represented as awaiting review, not published automatically

This is a UI prototype with sample tracks and made-up artist names. Search and navigation work; the mini-player is only a visual interaction. Playback, sign-in, real file selection, uploads, moderation tools, ads, and backend storage are not connected yet.

## Product decisions captured

- Audience: one local community first
- Catalogue: owner's tracks plus submissions from local artists
- Listener price: free
- Revenue direction: advertising or community sponsorship, with a sponsor slot shown in the prototype

## Suggested MVP build order

1. Confirm the app name and first launch community. Create the Play Store, backend, advertising, domain, and source-code accounts in your uncle’s name; give the developer collaborator access and agree on portfolio credit.
2. Add sign-in and a catalogue backend. Keep the owner's catalogue and artist submissions separate in the data model.
3. Build artist submissions with explicit rights confirmation, AI-production disclosure, and `pending / approved / rejected / removed` review states. Do not publish new uploads automatically.
4. Add audio playback and background controls, then measure storage and bandwidth use before opening the service to a larger audience.
5. Add in-app reporting, moderation actions, and public content rules before public user uploads. Google Play requires ongoing moderation and reporting/blocking features for apps with user-generated content.
6. Add advertising after the account and release setup is ready. Use test ads during development; start with a clearly marked sponsor slot.

## Rights and ownership

Every uploader should attest that they control or have permission for the recording and composition, and disclose AI-generated or AI-assisted elements. Suno commercial-use terms do not by themselves guarantee copyright protection. Keep an auditable record of uploader, declarations, review status, and takedown actions. The owner should control production accounts and accept the final source-code transfer in writing.

## Run

Install Flutter, then from this directory run:

```sh
flutter pub get
flutter run
```

The current environment did not have the Flutter SDK installed, so this scaffold has not been compiled or run here.
