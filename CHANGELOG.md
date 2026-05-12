# Changelog

All notable changes to the Waxxapp Flutter app are documented here.

## [Unreleased]

### Added
- **In-app sign-up / login assistant chatbot.** A fixed, step-by-step
  conversational helper (no AI) for new users who get stuck on the sign-up or
  login screens. A "Need help signing up?" chip on the entry / Sign In /
  Sign Up / Create Account / email-login screens and on the onboarding pager
  opens a full-screen chat assistant (`/SignupAssistant`, styled like the
  existing Support Chat).
  - **Sign-up branch:** the bot collects first name, last name, email, an
    optional phone number and a password (8+ chars, confirmed), shows a
    summary, then submits a **pending account request** to the backend
    (`POST accountRequest/create`). An admin reviews it in the admin panel
    and approves it, which creates the real account and emails the user.
  - **Login branch:** hands off to the existing flows — "Reset my password"
    routes into the Forgot Password flow; "Chat with support" opens the
    in-app Support Chat.
  - The password is collected client-side, sent over HTTPS, and stored
    Cryptr-encrypted at rest by the backend — the same reversible scheme
    every existing user password uses.
  - New: `lib/user_pages/signup_assistant/` (controller + view),
    `lib/custom/signup_assistant_chip.dart`,
    `lib/ApiService/login/signup_assistant_service.dart`,
    `lib/ApiModel/login/account_request_model.dart`,
    `Api.submitAccountRequest`, the `/SignupAssistant` route, and the
    `signupAssistant*` / `bot*` localization keys (English; other locales
    seeded with English placeholders pending translation).
  - Backend (`waxxapp_admin/backend`): new `server/accountRequest/` feature
    (`create` / list / `approve` / `reject` / `delete`, all behind
    `checkAccessWithSecretKey()`), mounted at `/accountRequest`; light
    per-device rate-limit on `create`; `accountApproved` / `accountRejected`
    email templates.
  - Admin panel (`waxxapp_admin/frontend`): new **Account Requests** page
    (under *User Management* in the sidebar) — list pending requests with
    Approve / Reject / Delete actions.

## [1.1.13+30] — May 2026

### Fixed
- **Selfie verification: "Couldn't submit. Please try again." on every upload.**
  `SubmitSelfieVerificationApi.submit` built the multipart `selfie` part via
  `http.MultipartFile.fromPath(...)` without an explicit `contentType`, so the
  Flutter `http` package sent it as `application/octet-stream`. The backend's
  KYC multer `fileFilter` (`waxxapp_admin/backend/util/multer.js`) only accepts
  `image/*` MIME types, so it rejected the upload before the controller ran and
  the app surfaced the generic submit-failed toast. Fixed by deriving an
  `image/*` `MediaType` from the file extension (defaulting to `image/jpeg`,
  which is what `ImagePicker` produces with `imageQuality` set) and passing it
  as `contentType:` — matching the pattern already used by the seller
  registration and product upload services.
  ([lib/ApiService/user/submit_selfie_verification_service.dart](lib/ApiService/user/submit_selfie_verification_service.dart))
- **"Verify your account" row in Profile appeared only sometimes.** The row is
  gated by `isSelfieVerificationActive`, which was a non-reactive global `bool`
  (default `false`) hydrated in exactly one place — `SplashScreenController.storageData()`,
  which only runs its body when the app cold-started already logged in *and*
  `/setting` returned `status == true`. A fresh sign-in (logged-out → login,
  which never fetches `/setting`) or a transient `/setting` failure at splash
  left the flag `false` for the rest of the session, and the bottom-bar's own
  `/setting` re-fetch (`BottomBarController.settingApiCall`) re-hydrated ~20
  other feature flags but **skipped this one**, so it couldn't recover. The
  Profile tab is kept alive in the bottom-bar `PageView`, so a value read as
  `false` before `/setting` landed stayed hidden permanently. Fixes:
  `isSelfieVerificationActive` is now an `RxBool`; `settingApiCall` re-hydrates
  it (and `isSelfieVerificationRequired`) on every `BottomTabBar` mount, with
  `int.parse(zegoAppId)` → `int.tryParse(...) ?? 0` so a blank Zego ID can't
  abort that block first; the Profile row is wrapped in `Obx` keyed on the flag
  + `verificationStatus` so it appears as soon as the flag flips.
  ([lib/utils/globle_veriables.dart](lib/utils/globle_veriables.dart),
  [lib/Controller/GetxController/login/splash_screen_controller.dart](lib/Controller/GetxController/login/splash_screen_controller.dart),
  [lib/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart](lib/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart),
  [lib/View/MyApp/Profile/main_profile.dart](lib/View/MyApp/Profile/main_profile.dart))
