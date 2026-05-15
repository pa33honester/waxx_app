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
  - **Currently hidden** behind the `kSignupAssistantEnabled` flag
    ([lib/custom/signup_assistant_chip.dart](lib/custom/signup_assistant_chip.dart),
    `false` by default) — the chip renders nothing and the bot is unreachable
    until the flag is flipped to `true`. The backend `/accountRequest` endpoints
    and the admin **Account Requests** page stay live regardless (harmless).

## [1.1.14+31] — May 2026

### Changed
- **Seller payouts now release only when admin marks an order Complete.** Previously, the seller wallet was credited the instant the seller themselves marked an item Delivered — there was no buyer confirmation step and no admin gating, so a missed/wrong "Delivered" tap shipped funds out before anyone had verified the buyer actually received the item. The flow is now: `Pending → Confirmed → Out Of Delivery (seller, with tracking) → Delivered (buyer taps "Accept Delivery") → Complete (admin)`. The `SellerWallet` deposit row + `Seller.netPayout` `$inc` moved from the Delivered branch in `order/updateOrder` to a new admin-only `order/completeOrderByAdmin` endpoint. A new buyer-owned `order/acceptDeliveryByBuyer` endpoint flips Out Of Delivery → Delivered. The Delivered transition itself is now a pure status change.
  ([waxxapp_admin/backend/server/order/order.controller.js](../waxxapp_admin/backend/server/order/order.controller.js),
  [waxxapp_admin/backend/server/order/order.route.js](../waxxapp_admin/backend/server/order/order.route.js),
  [waxxapp_admin/backend/server/order/order.model.js](../waxxapp_admin/backend/server/order/order.model.js))

### Added
- **Buyer "Accept Delivery" button on the My Order list.** Per-item, only shown when item status is `Out Of Delivery`. Tapping it calls the new `order/acceptDeliveryByBuyer` endpoint and refreshes the list. The endpoint is buyer-owned (it asserts `findOrder.userId === req.query.userId`), FCMs the seller ("Buyer confirmed delivery — awaiting admin completion"), and bumps the product's `sold` counter.
  ([lib/View/MyApp/Profile/MyOrder/my_order.dart](lib/View/MyApp/Profile/MyOrder/my_order.dart),
  [lib/Controller/GetxController/user/my_order_controller.dart](lib/Controller/GetxController/user/my_order_controller.dart),
  [lib/ApiService/user/accept_delivery_service.dart](lib/ApiService/user/accept_delivery_service.dart))
- **New "Complete" status everywhere.** Added to the Mongoose enum, the buyer's My Order tabs/status maps, status badge colors (green), the admin Order list filter dropdown + status badge, and the EditOrder dialog. The Delivered row's edit icon in the admin order table — previously disabled — is now enabled so admin can promote Delivered → Complete; the Complete row's icon is disabled (terminal state).
  ([waxxapp_admin/frontend/src/Component/Table/Order/Order.js](../waxxapp_admin/frontend/src/Component/Table/Order/Order.js),
  [waxxapp_admin/frontend/src/Component/Table/Order/EditOrder.js](../waxxapp_admin/frontend/src/Component/Table/Order/EditOrder.js),
  [waxxapp_admin/frontend/src/Component/store/order/order.action.js](../waxxapp_admin/frontend/src/Component/store/order/order.action.js))
- **Idempotency guard** on `completeOrderByAdmin`: the first thing the handler checks is `if (itemToUpdate.status === "Complete") return`. No Mongo transaction wraps the four writes (status set, `SellerWallet.save`, `Seller.$inc.netPayout`, populated re-fetch), so the early-return is the only thing standing between a fast double-click and a double-credit.
- **One-shot migration script** `backend/scripts/migrate_delivered_to_complete.js` that relabels every order item currently at `Delivered` to `Complete`. **Status-only — does NOT touch `SellerWallet` or `Seller.netPayout`.** Historical orders had their wallet credit fire at the original Delivered transition under the old code path; re-crediting them here would double-pay every legacy seller. The script comment spells this out explicitly.
- New localization keys: `complete`, `acceptDelivery`, `acceptDeliveryConfirm`, `deliveryAccepted`. Localized in English and French; seeded with English placeholders in the other 16 locales pending translation.

### Notes
- The `/updateOrder` endpoint still handles Delivered transitions (for admins who want to force a state change), but no longer credits the wallet on that branch — the Delivered FCM still fires there. Buyer-driven Delivered transitions go through the new `acceptDeliveryByBuyer` endpoint, which FCMs the seller instead of the buyer (the buyer just confirmed, so notifying them is redundant).
- Past behavior is preserved for already-shipped orders via the migration: every `Delivered` row gets relabeled `Complete`, keeping their wallet credit history intact and matching the new vocabulary.

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
- **Spurious "No Internet Connection" dialog when taking a selfie.** The root
  `_MyAppState` polled connectivity every 5s by doing a `InternetAddress.lookup('google.com')`
  with a 3s timeout. While `image_picker`'s system camera activity is in front
  (or an OS permission prompt), the app is backgrounded and that lookup
  routinely times out — the OS deprioritises a backgrounded process's network —
  so the poll popped the blocking, non-dismissible "No Internet" dialog over
  the camera / on return. `_MyAppState` mixed in `WidgetsBindingObserver` but
  never implemented `didChangeAppLifecycleState`, so it had no idea it was
  backgrounded. Fixes: poll only while the app is `resumed` (cancel the timer +
  ignore connectivity events otherwise, and run one check on resume so a real
  outage that ended while away — or a dialog we suppressed — is reconciled
  immediately); require two consecutive failed checks before showing the
  dialog so a single transient lookup hiccup can't trigger it; guard against a
  timer tick overlapping an in-flight check and against acting on a check that
  completed after we went to the background.
  ([lib/main.dart](lib/main.dart))
