# Release Notes — Waxx App

---
## ✨ Unreleased — In-app sign-up / login assistant chatbot

**Version:** _(no bump yet — pending next cut)_
**Type:** Feature, on top of v1.1.13+30

### Suggested Play Console release name
`v1.1.x — Sign-up help assistant`

### English (Default)

```
✨ New — Sign-up help

✓ Stuck signing up or logging in? Tap "Need help signing up?" on the login
  screen — our assistant will walk you through it and our team sets up your
  account
```

### 📋 Full Internal Release Notes

**New in-app sign-up / login assistant chatbot.**

New buyers sometimes get stuck on the sign-up / login screens (Firebase
"blocked all requests from this device", OTP failures, mistyped emails, etc.)
and abandon. This adds a small **in-app chatbot** — a fixed, deterministic
step-by-step flow, no AI, no WhatsApp — reachable from a "Need help signing
up? 💬" chip on the entry screen, Sign In, Sign Up, Create Account, the
email-login screen, and the onboarding pager. The chip opens a full-screen
chat assistant (`/SignupAssistant`) styled like the existing Support Chat.

The bot greets the user and asks whether they're stuck on **Signing up**,
**Logging in**, or **Something else**:

- **Signing up** → the bot collects first name, last name, email, an optional
  phone number, and a password (8+ chars, confirmed; never echoed in the
  transcript), shows a summary, then `POST`s a **pending account request** to
  the backend. The conversation state machine lives entirely on the client —
  there is no server-side bot.
- **Logging in** → the bot hands off to the existing flows: "Reset my
  password" → the Forgot Password flow; "Chat with support" → the in-app
  Support Chat (already wired to a human admin). No new backend for this
  branch.

An admin reviews each pending request in the admin panel (new **Account
Requests** page under *User Management*) and **Approves** it — which creates
the real `User` (`loginType: 3`, the password the user chose, a fresh
9-digit `uniqueId`), marks the request approved, and emails the user that
their account is ready (the password is *not* included in the email). Admins
can also **Reject** (optional reason → email) or **Delete** a request.

Security notes: the `create` endpoint is gated by the app's shared secret
(`checkAccessWithSecretKey()`) plus a light per-device rate-limit (≤ 3
pending requests per device per day) and a duplicate-email guard. The
password is collected client-side, sent over HTTPS, and stored
Cryptr-encrypted at rest — the same reversible scheme every existing user
password uses (not a regression).

#### 📁 Files Changed (relative to 1.1.13+30)

**Flutter (`waxx_app`)**
- `lib/user_pages/signup_assistant/controller/signup_assistant_controller.dart` — new; the conversation state machine.
- `lib/user_pages/signup_assistant/view/signup_assistant_view.dart` — new; the chat UI.
- `lib/custom/signup_assistant_chip.dart` — new; the launcher pill.
- `lib/ApiService/login/signup_assistant_service.dart`, `lib/ApiModel/login/account_request_model.dart` — new; submit DTO + HTTP.
- `lib/utils/api_url.dart` — `Api.submitAccountRequest = "accountRequest/create"`.
- `lib/utils/routes_pages.dart` — registered `/SignupAssistant`.
- `lib/View/UserLogin/demo_sign_in.dart`, `sign_in_email.dart`, `sign_up.dart`, `create_account.dart`, `lib/View/OnboardingScreens/page_manage.dart` — added the `SignupAssistantChip`.
- `lib/utils/Strings/strings.dart` + all 18 `lib/localization/language/*.dart` — `signupAssistant*` / `bot*` keys (English; other locales seeded with English placeholders).

**Backend (`waxxapp_admin/backend`)**
- `server/accountRequest/accountRequest.model.js`, `.controller.js`, `.route.js` — new feature folder.
- `route.js` — mounted `/accountRequest`.
- `util/emailSender.js` — added `templates.accountApproved` and `templates.accountRejected`.

**Admin panel (`waxxapp_admin/frontend`)**
- `src/Component/store/accountRequest/{type,reducer,action}.js` — new Redux slice; combined in `src/Component/store/index.js`.
- `src/Component/Table/accountRequest/AccountRequests.js` — new page (table + Approve / Reject / Delete).
- `src/Component/Pages/Admin.js` — route `/admin/accountRequests`.
- `src/Component/Pages/Sidebar.js` — "Account Requests" entry under *User Management*.

#### 🚀 Deploy

1. Backend deploy required (`waxxapp_admin/backend` — `pm2 restart`). Mongo
   creates the `accountrequests` collection on first write; no migration.
2. Admin panel rebuild + deploy (`waxxapp_admin/frontend` — `npm run build`,
   `./deploy.sh`).
3. App: cut a new `app-release.aab` whenever the next version is bumped and
   upload to the Production track.

---
## 🛠 Version 1.1.14+31 — Buyer-confirmed delivery + admin-released seller payouts

**Version:** 1.1.14
**Build Number:** 31
**Release Date:** May 2026
**Type:** Behavior change on top of v1.1.13+30 (payout flow)

### Suggested Play Console release name
`v1.1.14 — Confirm delivery to release seller funds`

### English (Default)

```
✨ Update — v1.1.14

✓ When your order is out for delivery, tap "Accept Delivery" once it
  arrives — the seller is paid only after admin confirms completion
```

### 📋 Full Internal Release Notes

**Seller payouts now release only when admin marks an order Complete.**

The order flow used to be `Pending → Confirmed → Out Of Delivery → Delivered`,
and the seller's wallet was credited the instant the **seller themselves**
marked an item Delivered. There was no buyer confirmation step and no admin
gating — a mistaken or premature "Delivered" tap shipped funds out before
anyone had verified the buyer received the item. A live order on production
surfaced the issue (the seller in question had `netPayout` updated but no
real-world confirmation of delivery).

The flow is now:

```
Pending → Confirmed (seller)
       → Out Of Delivery (seller, with tracking — unchanged)
       → Delivered (buyer taps "Accept Delivery")
       → Complete (admin only; this is when the seller wallet is credited)
```

The `SellerWallet` deposit row + `Seller.$inc.netPayout` were lifted out of
the Delivered branch in `order/updateOrder` and moved into a new admin-only
endpoint `order/completeOrderByAdmin`. A new buyer-owned endpoint
`order/acceptDeliveryByBuyer` handles the Out Of Delivery → Delivered
transition; it asserts the caller owns the order, flips the status, bumps
the product's `sold` counter, and FCMs the seller ("Buyer confirmed delivery
— awaiting admin completion"). The Delivered branch in `/updateOrder` is now
a pure status change with no wallet side-effects (admins can still force it
from the panel if needed).

Auth caveat: the codebase has no JWT-based role middleware — every endpoint
is gated by the shared `secretKey` header (`util/checkAccess.js`). So role
separation is enforced by **per-actor endpoints** (matching the existing
`cancelOrderByUser` pattern), and the trust boundary for the admin-only
Complete action is the admin panel itself. The same security posture as
every other admin endpoint in this codebase — not a regression.

Idempotency: `completeOrderByAdmin`'s very first check is
`if (itemToUpdate.status === "Complete") return`. No Mongo transaction wraps
the four writes (status `$set`, `SellerWallet.save`, `Seller.$inc.netPayout`,
populated re-fetch), so a fast double-click in the admin panel could
otherwise double-credit. The early-return is the only thing preventing that.

**Buyer UI:** the My Order list now renders an inline **Accept Delivery**
button per item when that item's status is `Out Of Delivery`. A new
**Complete** tab joins the existing tabs (All / Pending / Confirmed / Out
Of Delivery / Delivered / Complete / Cancelled). Status badges get a green
"Complete" colorway. Localization seeded with English placeholders in the
other 16 locales pending translation; French localized.

**Admin UI:** the Order table's edit icon for Delivered rows — previously
disabled — is now enabled. Clicking it opens the EditOrder dialog with the
status dropdown offering Delivered or Complete. Complete is wired through a
new `completeOrder(userId, orderId, itemId)` Redux thunk that hits
`order/completeOrderByAdmin`, then dispatches the existing `UPDATE_ORDER`
reducer (the response shape matches `orderUpdate`). The Order list gets a
new Complete filter chip + green Complete status badge. Complete rows show
a disabled edit icon (terminal state).

**Migration:** `backend/scripts/migrate_delivered_to_complete.js` relabels
every existing `Delivered` order item to `Complete`. **Status-only — no
SellerWallet inserts, no netPayout changes.** Historical credits already
fired at the original Delivered transition under the old code path; touching
wallets in this script would double-pay every legacy seller. The script
comment spells this out, and re-running is a no-op.

#### 📁 Files Changed (relative to 1.1.13+30)

**Flutter (`waxx_app`)**
- `pubspec.yaml` — `1.1.13+30` → `1.1.14+31`.
- `lib/ApiService/user/accept_delivery_service.dart` — new; PATCH `order/acceptDeliveryByBuyer`.
- `lib/Controller/GetxController/user/my_order_controller.dart` — `acceptDelivery()` method (in-flight guard + list refresh); `getStatusFromTabIndex` extended with Complete.
- `lib/View/MyApp/Profile/MyOrder/my_order.dart` — Complete tab + status badge colors; inline Accept Delivery button per item when `Out Of Delivery`.
- `lib/utils/api_url.dart` — `Api.acceptDeliveryByBuyer = "order/acceptDeliveryByBuyer"`.
- `lib/utils/Strings/strings.dart` + all 18 `lib/localization/language/*.dart` — `complete`, `acceptDelivery`, `acceptDeliveryConfirm`, `deliveryAccepted` keys.

**Backend (`waxxapp_admin/backend`)**
- `server/order/order.model.js` — `"Complete"` added to the `items[].status` enum.
- `server/order/order.controller.js` — Delivered branch stripped of wallet-credit code (status `$set` + `Product.$inc.sold` stay); guards in earlier branches now reject transitions out of Complete; new `exports.acceptDeliveryByBuyer` and `exports.completeOrderByAdmin` handlers.
- `server/order/order.route.js` — PATCH `acceptDeliveryByBuyer` + PATCH `completeOrderByAdmin`.
- `scripts/migrate_delivered_to_complete.js` — new; one-shot Delivered → Complete relabel (status-only).

**Admin panel (`waxxapp_admin/frontend`)**
- `src/Component/store/order/order.action.js` — `completeOrder` thunk.
- `src/Component/Table/Order/EditOrder.js` — Complete option; for Delivered rows only Delivered/Complete are offered; submit routes Complete through the new thunk.
- `src/Component/Table/Order/Order.js` — Complete filter chip; Delivered row's edit icon enabled; Complete row's edit icon disabled; green Complete status badge.

#### 🚀 Deploy

1. `git pull` in `waxxapp_admin` on the server, then `pm2 restart backend` (new endpoints + Complete in the enum).
2. **Run the migration once on prod:** `cd waxxapp_admin/backend && node scripts/migrate_delivered_to_complete.js`. Output is the count of order docs whose items were relabeled.
3. `cd waxxapp_admin/frontend && ./deploy.sh` (rebuilds and copies to `backend/public`, then PM2-restarts the SPA route).
4. Upload `app-release.aab` (1.1.14+31) to the Play Console Production track.

---
## 🛠 Version 1.1.13+30 — Selfie verification submit fixed

**Version:** 1.1.13
**Build Number:** 30
**Release Date:** May 2026
**Type:** Bug-fix cut on top of v1.1.12+29

### Suggested Play Console release name
`v1.1.13 — Selfie verification submit fixed`

### English (Default)

```
🔧 Update — v1.1.13

✓ "Verify Your Account" — taking and submitting a selfie now works
```

### 📋 Full Internal Release Notes

**Selfie verification: "Couldn't submit. Please try again." on every upload.**

`SubmitSelfieVerificationApi.submit` (`lib/ApiService/user/submit_selfie_verification_service.dart`) built the multipart `selfie` part with `http.MultipartFile.fromPath('selfie', path)` and **no `contentType`**. Dart's `http` package does not infer a MIME type from the filename — it sends `application/octet-stream`. The selfie endpoint (`POST /verification/submitSelfie`) wraps the upload in multer with the strict KYC `fileFilter` in `waxxapp_admin/backend/util/multer.js`, which only accepts `image/jpeg|png|gif|webp|jpg`. So multer rejected the file *before* the `submitSelfie` controller ran, the request came back non-200, and the app showed its generic submit-failed toast — every time. The camera/preview/ML-Kit gate all worked; only the upload failed.

Why other uploads were unaffected: every other multipart image upload in the app (`seller_login_service.dart`, `add_product_service.dart`, `product_edit_service.dart`, `seller_edit_profile_service.dart`) already has a `_getMediaType(path)` helper and passes `contentType:`. The selfie service was the one that never got it.

Fix: added the same `_getMediaType(path)` helper to `SubmitSelfieVerificationApi` (maps the file extension to an `image/*` `MediaType`, defaulting to `image/jpeg` — what `ImagePicker` produces with `imageQuality` set) and passed it as `contentType:` to `MultipartFile.fromPath`. No backend change needed.

#### 📁 Files Changed (relative to 1.1.12+29)

- `pubspec.yaml` — `1.1.12+29` → `1.1.13+30`.
- `lib/ApiService/user/submit_selfie_verification_service.dart` — `_getMediaType` helper; `contentType:` passed on the `selfie` multipart part.
- `CHANGELOG.md` — added (new file) with the 1.1.13+30 entry.

#### 🚀 Deploy

1. No backend deploy required.
2. Upload `app-release.aab` (1.1.13+30) to the Production track.

---
## 🛠 Version 1.1.12+29 — Cart +/- now reliable on Buy Now path; selfie-menu hydration hardened

**Version:** 1.1.12
**Build Number:** 29
**Release Date:** May 2026
**Type:** Bug-fix cut on top of v1.1.11+28

### English (Default)

```
🔧 Update — v1.1.12

🛒 Cart +/- now works reliably whether you opened Cart via Buy Now or the tab
✓ Selfie verification menu now shows consistently when enabled
```

### 📋 Full Internal Release Notes

**1. Buy Now → Cart: +/- intermittently no-op (worked from the bottom-tab Cart, not after Buy Now)**

Root cause was a controller-instance race. On the Buy Now path, Product Detail's State `Get.put`s a `GetAllCartProductController` (instance A), then `Get.back()` pops Product Detail, then `/CartPage` is pushed. The cart page's State field initializer and the cart-tile States each independently run `Get.isRegistered ? Get.find : Get.put` — and depending on timing/disposal, the page and a tile could end up holding **different** instances. The tile's `+/-` did its refetch on *its* controller; the page rendered from *its* controller — they never synced, so the quantity (and Amount) didn't update. The bottom-tab Cart is stable, so there both always resolved to the same instance.

Fix: the cart tile no longer keeps a `GetAllCartProductController` at all. On `+/-` it triggers the mutation API (`addToCart` / `removeFromCart`) then calls `onCartChanged`, which the parent implements to refetch on **its own** controller and `setState`. One canonical controller; the tile's displayed quantity is always `widget.productQuantity` re-passed by the parent. A per-tile `_busy` flag (dims the buttons + shows a tiny spinner on the count) still blocks overlapping taps.

> Also note (already shipped, separate cut): the backend's cart-line matching now uses a structural `sameAttributes()` compare instead of `JSON.stringify` equality (commit `56c2528`) — that was a *separate* intermittency: `removeFromCart` silently rejected and `addToCart` duplicated lines for any product with attributes, because Mongoose's array-subdoc `_id` made the stringified arrays never match. Needs `pm2 restart backend`.

**2. Selfie verification menu didn't always appear (even though `/setting` returns `selfieVerification.isActive: true`)**

`SplashScreenController.storageData()` assigned `getStorage.read(...)` (dynamic, possibly null) straight to non-nullable `String` globals (`loginUserId`, `editFirstName`, `uniqueID`, …). One missing login key — an old login, a partial write, a version-update gap — threw a `TypeError` there, abandoning the rest of the method, so the `/setting` fetch + feature-flag hydration (`isSelfieVerificationActive`, `isAddressProofActive`, …) below it never ran and the flag stayed `false` → menu hidden. Whether it worked depended on whether the stored login data was complete → the intermittency. Also `int.parse(zegoAppId ?? '')` threw a `FormatException` if `zegoAppId` were ever blank, skipping the rest of the same block.

Fix: every `getStorage.read` in `storageData()` is coerced to a safe default and the block is wrapped in try/catch so it can't take down the settings fetch; `int.parse` → `int.tryParse`. The `/setting` fetch + flag hydration now always run as long as the user is logged in.

#### 📁 Files Changed (relative to 1.1.11+28)

- `pubspec.yaml` — `1.1.11+28` → `1.1.12+29`.
- `lib/View/MyApp/AppPages/cart_page.dart` — tile drops its own cart controller; `onCartChanged` is now an async callback the parent implements (refetch on the parent's controller + setState); `_runMutation` helper; `_busy` lock.
- `lib/Controller/GetxController/login/splash_screen_controller.dart` — null-safe `storageData` reads + try/catch + `int.tryParse` so the `/setting` hydration always runs.

(Backend `sameAttributes` fix is in `waxxapp_admin` commit `56c2528` — deploy with `pm2 restart backend`.)

#### 🚀 Deploy

1. `pm2 restart backend` on the server (for the cart attribute-matching fix).
2. Upload `app-release.aab` (1.1.12+29) to the Production track.

---
## 🛠 Version 1.1.11+28 — Responsive home top bar

**Version:** 1.1.11
**Build Number:** 28
**Release Date:** May 2026
**Type:** UI fix on top of v1.1.10+27 (carries all of v1.1.10's fixes — see below)

### Suggested Play Console release name
`v1.1.11 — Home header handles long names`

### English (Default)

```
🔧 Update — v1.1.11

📱 Home header no longer overflows when your display name is long
```

### 📋 Full Internal Release Notes

**Home top bar — responsive name section.** The greeting row on Home (`home_view.dart`) put the avatar + "Hi, <name>" + "Explore the latest live deals!" in an unconstrained `Row`/`Column`, so a long display name ("Hi, Unique Quick Tutorials") pushed the search / wishlist / etc. action buttons off the right edge — the yellow-black overflow stripes. Fix: the left section (avatar + name column) is now wrapped in `Expanded`, and the name column itself in `Expanded`, so a long name ellipsizes ("Hi, Unique Quick…") instead of overflowing. The subtitle line also gets `maxLines: 1` + `overflow: ellipsis`. Action buttons always stay on screen.

**Note on the "+/- not working" and "Selfie menu missing" reports:** both of those fixes already shipped in earlier cuts — the cart +/- quantity-sync rewrite in v1.1.9+26 / v1.1.10+27, the Selfie menu hydration in v1.1.6+23. They work in a local `flutter run` because that builds the current source. If they're not working "after published", the build on the store/internal track is older than those cuts — uploading this AAB (1.1.11+28, which includes all of them) fixes it. R8 minification is off (`minifyEnabled false`), so there's no release-only stripping at play.

#### 📁 Files Changed (relative to 1.1.10+27)

- `pubspec.yaml` — `1.1.10+27` → `1.1.11+28`.
- `lib/user_pages/home_page/view/home_view.dart` — left section + name column wrapped in `Expanded`; subtitle `maxLines: 1` + ellipsis.

#### 🚀 Deploy

Upload `app-release.aab` (1.1.11+28) to the Production track. No server-side action needed for this cut.

---
## 🛠 Version 1.1.10+27 — Followed-seller push opens the product, cart quantity sync, selfie crash fix

**Version:** 1.1.10
**Build Number:** 27
**Release Date:** May 2026
**Type:** Bug-fix cut on top of v1.1.9+26

### Suggested Play Console release name
`v1.1.10 — Cart quantity fix + selfie stability + product-push deep link`

### English (Default)

```
🔧 Update — v1.1.10

🔔 Tapping a "new product" notification now opens that exact product
🛒 Cart quantity & total now stay in sync — no more wrong amounts on +/-
📸 Fixed the selfie screen crashing on repeated captures
```

### 📋 Full Internal Release Notes

#### 🐛 Bug fixes

**1. Followed-seller "new product" notification didn't open the product page**
The `FOLLOWED_SELLER_NEW_PRODUCT` push (sent when a seller you follow lists a product) had no case in the Flutter FCM handler, so taps fell through to the default route (Home). Added:
- Warm tap → sets the global `productId` then `Get.toNamed('/ProductDetail')`.
- Foreground → snackbar with a "tap to view" CTA.
- Cold-start tap → stashed in `getStorage` (`pendingDeepLinkProductId`) and replayed by `SplashScreenController` after the `BottomTabBar` nav lands, so the `ProductDetail` push isn't clobbered (same race-avoidance pattern as `LIVE_STARTED`).
- No backend change — the backend already sends `data.type` + `productId`.

**2. Buy Now → Cart: total amount counted wrong on +/-**
The tile kept its own optimistic `localQuantity` that incremented instantly on tap, but rapid taps pushed it ahead of what actually persisted server-side — only some of the async `addToCart` calls land before the next tap. The tile would show e.g. "4" while the cart truly had 2, and the Amount line (computed from the cart payload) said 2's worth. Fixes:
- Removed the optimistic `localQuantity` — the tile now displays `widget.productQuantity`, the authoritative value the parent re-passes after each refetch. A per-tile `_busy` flag blocks a second +/- until the first op's refetch lands; the +/- buttons dim and a tiny spinner replaces the number while an op is in flight. Quantity, line price, and Amount can no longer disagree.
- The Amount line already computes `_visibleSubTotal` client-side from the qty-filtered visible items (from v1.1.9) rather than trusting the backend's stored `subTotal`, which drifted out of sync with stale qty-0 rows.

**3. "Product Removed" toast firing on plain quantity reductions**
`removeFromCart` returns `status: true` for a 4 → 3 decrement too, so the controller toasted "Product Removed" on every decrement, even when the item stayed in the cart. Now it only toasts when the item actually left (backend deleted the cart / `data == null` / message says "cart deleted"). Plain reductions are silent — the quantity change is feedback enough.

**4. Selfie screen crashed on repeated captures (~3rd attempt restarted the app)**
Two native-memory leaks plus an over-strict gate:
- `_readImageSize` (added in v1.1.9 for the H3 face-area fix) disposed `frame.image` but **not** the `ui.Codec` — leaking native memory on every capture until OOM → app restart. Now both are disposed in a `finally` block.
- The view called `Get.put(SelfieVerificationController())` inside `build()`, replacing the controller — and its native ML Kit `FaceDetector` — on every rebuild, churning create/close cycles. Converted the view to a `StatefulWidget` that creates the controller in `initState` and `Get.delete()`s it in `dispose`, so the FaceDetector is created once per page mount and torn down once on pop.
- Relaxed the ML Kit gate: the eye-open / face-area heuristics (flaky — ML Kit's classification probabilities swing with lighting and EXIF orientation) are now **non-blocking soft hints** ("Tip: move a little closer…"). Only zero-faces / multiple-faces still block the Submit button. The ML Kit error string is now captured in `autoCheckResult.mlKitError` for the admin reviewer.

#### 📁 Files Changed (relative to 1.1.9+26)

**Flutter** (`waxx_app/`):
- `pubspec.yaml` — `1.1.9+26` → `1.1.10+27`.
- `lib/services/push_notification_service.dart` — `FOLLOWED_SELLER_NEW_PRODUCT` warm-tap + foreground + cold-start stash.
- `lib/Controller/GetxController/login/splash_screen_controller.dart` — `pendingDeepLinkProductId` replay.
- `lib/View/MyApp/AppPages/cart_page.dart` — dropped optimistic `localQuantity`, `_busy` lock, spinner-while-busy, displays `widget.productQuantity`.
- `lib/Controller/GetxController/user/remove_product_to_cart_controller.dart` — "Product Removed" toast only on real removal.
- `lib/user_pages/selfie_verification/controller/selfie_verification_controller.dart` — Codec disposal in `finally`, relaxed gate (`gateError` vs `softHint`), `mlKitError` capture.
- `lib/user_pages/selfie_verification/view/selfie_verification_view.dart` — `StatefulWidget` lifecycle (`Get.put` in `initState`, `Get.delete` in `dispose`), soft-hint card.

**No backend / admin changes in this cut.**

#### 🚀 Deploy checklist for v1.1.10

1. Upload `app-release.aab` (1.1.10+27) to the Production track.
2. No server-side action needed for these fixes (backend already sends the right push payload; the v1.1.9 backend `removeFromCart` clamp + `pm2 restart` is still on the v1.1.9 checklist if not done yet).

---
## 🛠 Version 1.1.9+26 — Selfie verification hardening + new notifications + cart removal fixes

**Version:** 1.1.9
**Build Number:** 26
**Release Date:** May 2026
**Type:** Hardening + feature cut on top of v1.1.8+25 (consolidates the patches that had been riding on the same build number)

### Suggested Play Console release name
`v1.1.9 — Verification hardening + followed-seller alerts + cart fixes`

### English (Default)

```
🔧 Update — v1.1.9

🛡 Hardened the new identity-verification flow ahead of go-live
🔔 Get notified when a seller you follow lists a new product
🛒 Cart removal fixes — decreasing to 0 now removes the item cleanly
✅ Verified badge updates instantly when an admin approves you
🏙 Seller "My Address" city field now shows the value the moment you pick it
```

### 📋 Full Internal Release Notes

#### 🆕 New features

**Push notification when a seller you follow lists a new product** — Whenever an `Approved` product goes live (created directly or admin-approved from a Pending request), `notifyFollowersOfNewProduct(product)` in `product.controller.js` queries the `Follower` collection by `sellerId`, writes a `Notification` row per follower (`insertMany`, `ordered:false`), hydrates FCM tokens from `User`, and sends a `sendEachForMulticast` with `data.type: "FOLLOWED_SELLER_NEW_PRODUCT"`. Best-effort — errors log + swallow. Hooked from `createProduct` (when `createStatus === "Approved"`) and `acceptCreateRequest` (when admin approves). No Flutter change required — the existing FCM handler routes the `productId` payload.

**Admin Broadcast page** — New `/admin/broadcast` standalone React page lets the admin compose title / message / optional image and broadcast it to all buyers or all sellers via the existing `notification/send?notificationType=User|Seller` endpoint. New "Broadcast" sidebar entry (lucide `Megaphone` icon). No backend change — the endpoint already supported the multicast pattern; it just wasn't exposed in the UI. `BroadcastNotification.js` is a fresh inline form; the legacy modal-style `Notification.js` stays untouched.

#### 🛡 Selfie verification hardening (audit follow-up)

Six fixes from the pre-go-live audit of the v1.1.6+23 selfie verification feature. C1-C3 were blocking; H1-H5 landed in the same cut.

| ID | Sev | What |
|---|---|---|
| C1 | 🔴 | **User-delete cascade now removes Verification rows + selfie files.** `_purgeUserCascade` was leaving biometric data on disk forever after account deletion. Now finds the user's `Verification` rows, deletes each selfie file from `private_storage/`, and `Verification.deleteMany({ userId })`. |
| C2 | 🔴 | **`adminReview` is now atomic.** Snapshots the Verification row's prior state before `save()`; if the follow-up `User.verificationStatus` update fails, rolls the Verification back so the two records can't desync (the "verified row but badge never appears" scenario). |
| C3 | 🔴 | **FCM handler updates the badge live.** New `_applyVerificationStatusFromPush()` mutates the global `verificationStatus.value` on `VERIFICATION_APPROVED` / `VERIFICATION_REJECTED` data pushes, wired into both `onMessage` (foreground) and `handleRemoteMessage` (warm tap / cold-start replay). Before this, admin approvals were invisible until a cold restart or a manual status refetch. |
| H1 | 🟠 | **Resubmission cleans up the previous selfie file.** `submitSelfie` now deletes the user's previous `rejected` / `pending_review` selfie files from disk before saving the new row. Verified rows' files stay (audit trail). |
| H2 | 🟠 | **Admin queue uses server-side pagination.** Was fetching `limit=200` once and paginating client-side, so pending rows beyond 200 were invisible. Now refetches on every page change with the proper `page` + `limit`; `Table` + `Pagination` switched to `type="server"` with `count={total}`. |
| H3 | 🟠 | **ML Kit face-area ratio uses real image dimensions.** Was assuming 1280×1280 (square), which underestimated portrait selfies' area ratio by ~25% and made the 18% gate threshold harder to pass. New `_readImageSize()` reads the actual pixel dimensions via `dart:ui`'s `instantiateImageCodec`. |
| H4 | 🟠 | **`/private-file` validates `userId` + escapes the regex.** Rejects any `userId` that isn't a valid ObjectId; escapes the filename inside the ownership-lookup regex so multer's `.` in the random suffix can't be exploited. |
| H5 | 🟠 | **KYC migration script rolls back on partial failure.** If `Model.updateOne` throws after `fs.renameSync` succeeded, the file is moved back to `storage/` so the static handler doesn't permanently 404 the URL. |

#### 🐛 Cart removal fixes

| Issue | Fix |
|---|---|
| **Decrement from quantity 1 → "Something Wrong Please Try Again" toast while the cart was actually already empty** | `remove_product_to_cart_controller` now treats benign "cart not found" / "product not found in cart" backend responses as already-removed (success toast) instead of a generic failure. Those fire when a stale tile click sends a duplicate remove after a previous tap already deleted the cart server-side. |
| **Cart tile flashed "1" while the API + refetch round-tripped on the last-item decrement** | `cart_page.dart`'s tile decrement from 1 optimistically zeros `localQuantity` via `setState` so the tile stops showing "1" immediately; the parent's `onCartChanged` → `setState((){})` then rebuilds the list from the refetched payload (tile unmounts if cart empty, re-mounts with fresh data otherwise). |
| **Cart kept showing a tile at quantity 0 (un-decrementable, Amount line wrong)** | Two-sided fix. **Backend** `removeFromCart` now clamps the effective decrement to the stored quantity instead of rejecting on `storedQty >= requestedQty` — so a stale qty-0 row (where a prior decrement zeroed it but the `$pull` cleanup didn't run) gets removed cleanly rather than returning "Product's productQuantity does not found in the cart." **Flutter** also defensively filters any `productQuantity == 0` cart items out of the rendered list, and renders the no-data state inline if that empties the visible list. |
| **Buy Now → Cart: Amount + Sub Total not recalc'ing on +/-** (carried over from the v1.1.8+25 patch series) | `CartListTileWidget` gained an `onCartChanged` `VoidCallback`; the tile `await`s the refetch then fires it, and the parent passes `() { if (mounted) setState((){}); }` so the page rebuilds via Flutter's setState — route-independent, no GetBuilder propagation reliance. |

#### 🐛 Other fixes

| Issue | Fix |
|---|---|
| **Seller "My Address" city input stayed blank after picking a city** (value still saved correctly — only the visual binding was broken) | The `PrimaryTextField`'s `controllerTypes()` switch had no case for `"updateCityController"`, so the field rendered with no `TextEditingController` bound. The picker's `onStateTap` was correctly setting `sellerEditProfileController.cityCountroller.text` (which the save reads), but the widget wasn't listening to it. Added the missing mapping → field updates the instant the user picks (preset or custom). |
| **Checkout Delivery Location card showed the buyer's signup phone for ship-to-someone-else cases** | `_buildContactPhone()` now returns ONLY the address's saved `phoneNumber` — no fallback to the buyer's signup `mobileNumber`. The recipient phone is what a courier needs, and falling back leaked the buyer's personal number. Row hides itself when the address has no phone. |

#### 📁 Files Changed (relative to 1.1.8+25)

**Backend** (`waxxapp_admin/backend/`):
- `server/user/user.controller.js` — C1: Verification cascade in `_purgeUserCascade`.
- `server/verification/verification.controller.js` — C2 atomic `adminReview`, H1 resubmit cleanup.
- `server/privateFile/privateFile.controller.js` — H4 ObjectId validation + regex escape.
- `scripts/migrateKycToPrivate.js` — H5 rollback on partial failure.
- `server/product/product.controller.js` — `notifyFollowersOfNewProduct` + invocations.
- `server/cart/cart.controller.js` — `removeFromCart` clamps decrement to stored qty.

**Admin frontend** (`waxxapp_admin/frontend/`):
- `src/Component/Table/verification/Verification.js` — H2 server-side pagination.
- `src/Component/Table/admin/BroadcastNotification.js` (new) — broadcast composer.
- `src/Component/Pages/Admin.js` — `/admin/broadcast` route.
- `src/Component/Pages/Sidebar.js` — "Broadcast" entry.

**Flutter** (`waxx_app/`):
- `pubspec.yaml` — `1.1.8+25` → `1.1.9+26`.
- `lib/services/push_notification_service.dart` — C3 verification-status FCM handler.
- `lib/user_pages/selfie_verification/controller/selfie_verification_controller.dart` — H3 real image dimensions.
- `lib/View/MyApp/AppPages/cart_page.dart` — qty-0 filter, `onCartChanged` callback, optimistic zero on last-item decrement.
- `lib/Controller/GetxController/user/remove_product_to_cart_controller.dart` — benign-not-found → success toast.
- `lib/utils/CoustomWidget/App_theme_services/textfields.dart` — `"updateCityController"` mapping.
- `lib/View/MyApp/AppPages/cheak_out.dart` — `_buildContactPhone()` address-only.

#### 🚀 Deploy checklist for v1.1.9

1. `cd waxxapp_admin/backend && git pull && pm2 restart backend` — picks up C1/C2/H1/H4, the followed-seller push, and the `removeFromCart` clamp.
2. `cd ../frontend && git pull && npm install --f && ./deploy.sh` — exposes H2 pagination + the `/admin/broadcast` page.
3. Re-run the KYC migration script if it hasn't been run yet (H5 rollback applies to that run).
4. Upload `app-release.aab` (1.1.9+26) to the Production track.
5. (Selfie verification still gated behind `Setting.selfieVerification.isActive` — flip it on once you've sanity-checked the queue with internal accounts.)

#### ⚠️ Out-of-scope

- The MEDIUM/LOW items from the selfie audit (rejection-reason can be empty, settings toggle invariant, English-only strings, GetX binding on the route, the remaining 4 badge surfaces) are still in the backlog.
- Throttling on the followed-seller push (a seller listing N products fires N pushes per follower) — acceptable for v1.

---
## 🛠 Version 1.1.8+25 — Item Location custom city + per-address phone number

**Version:** 1.1.8
**Build Number:** 25
**Release Date:** May 2026
**Type:** Patch on top of v1.1.7+24

### Suggested Play Console release name
`v1.1.8 — Item Location custom city + address phone`

### English (Default)

```
🔧 Update — v1.1.8

🏙 Sellers can type a custom city on Item Location when not in the list
📞 Buyers can save a contact phone number per delivery address
✓ Custom cities persist for next time (same as New / Update Address)
```

### 📋 Full Internal Release Notes

#### 🐛 / 🆕 Changes

| Item | Detail |
|---|---|
| **Item Location accepts custom city** (sellers, listing flow) | The item-location picker was gated on `selectedStateData!.cities!.isNotEmpty` — for states with no preset cities (and many that have them but miss the seller's town), the city field didn't even render. Dropped the `cities.isNotEmpty` gate so the picker shows for any selected state. Wired `allowCustomEntry: true` + `onCustomEntry` so typed-but-unmatched values land via the "Use '<typed>'" CTA, persisted to local storage under `customCities|<country>|<state>` and merged into the list on subsequent picker opens. New `mergeCustomCities()` + `persistCustomCity()` helpers on `ListingController`, mirroring the existing `new_address.dart` / `update_address.dart` / `seller_edit_address.dart` flow. |
| **Per-address phone number** (buyers, New + Update Address) | The Address backend model had no phone field, so buyers shipping to someone else (friend / office) couldn't supply a recipient phone — Checkout's Delivery Location card was always falling back to the buyer's signup mobile. Added `phoneNumber: String` (nullable, default null) to `Address.model.js`. Address controller's store + update read & normalize it. Flutter Address models on both `UserAddressSelectModel` and `GetAllUserAddressModel` carry the new field. New `phoneNumberController` on `UserAddAddressController`, threaded through both the add + update API services. |
| **New Phone Number input on New Address & Update Address forms** | Added below the Zip Code field. Numeric phone keyboard via the existing `PrimaryTextField` `controllerType: "UserPhoneNumber"` (registered in `textfields.dart` with `TextInputType.phone`). Pre-fills on Update Address when `data.phoneNumber` is set. The Address list screen now passes `getPhoneNumber:` into `UpdateAddress(...)` so existing values persist across edits. |
| **Checkout Delivery Location card shows ONLY the per-address phone** | `_buildContactPhone()` in `cheak_out.dart` returns the address's saved `phoneNumber` and nothing else. No fallback to the buyer's signup `mobileNumber` — that would leak the buyer's personal number for ship-to-someone-else cases, and the recipient phone is what a courier actually needs. When the selected address has no phone set, the row hides itself (the surrounding `if (...isNotEmpty)` already gates it). The `Database` import is no longer needed and is dropped. |
| **Buy Now → Cart: Amount + Sub Total still not recalc'ing on +/-** (v1.1.7+24 + v1.1.8+25 guarded-find-or-put fix didn't fully repair this) | The guarded `Get.isRegistered ? find : put` ensured page + tile shared one controller instance, but the GetBuilder's `update()`-driven rebuild was still flaky on the Buy Now push path (likely a stale subscription from the about-to-dispose Product Detail State). Added an explicit `onCartChanged` `VoidCallback` on `CartListTileWidget`. The tile's increment/decrement now `await`s the refetch and then fires the callback. The parent passes `() { if (mounted) setState((){}); }` so the page rebuilds via Flutter's setState (route-independent), not via GetBuilder propagation. Works for both Buy Now → Cart and bottom-tab Cart. |
| **Seller "My Address" city input stays blank after selecting from picker** (value still saved correctly, only the visual binding was broken) | The `PrimaryTextField`'s `controllerTypes()` switch had no case for `"updateCityController"`, so the field rendered with no `TextEditingController` bound. The picker's `onStateTap` callback was correctly setting `sellerEditProfileController.cityCountroller.text = value` — and the save action read from that same controller — but the TextField widget itself wasn't listening to it. Added the missing case mapping `"updateCityController"` → `sellerEditProfileController.cityCountroller`. Field now updates the instant the user picks a city. |

#### 🆕 New features

**Push notification when a seller you follow lists a new product** — Whenever an `Approved` product goes live (either created directly by the seller or just approved by the admin from a Pending request), every user following that seller receives an FCM push (`type: "FOLLOWED_SELLER_NEW_PRODUCT"`) and a row in their in-app Notifications feed. Implemented as a `notifyFollowersOfNewProduct(product)` helper in `product.controller.js`: queries the `Follower` collection by `sellerId`, hydrates the followers' FCM tokens from the `User` collection, writes `Notification` rows in bulk via `insertMany`, and sends an FCM multicast. Best-effort — failures log + swallow so they don't block the response.

Files: `waxxapp_admin/backend/server/product/product.controller.js` (`notifyFollowersOfNewProduct` helper + invocation from `createProduct` when `createStatus === "Approved"` and from `acceptCreateRequest` when admin approves).

**Admin broadcast page** — New `/admin/broadcast` page lets the admin compose a push notification (title / message / optional image) and broadcast it to all buyers or all sellers at once. The page reuses the existing `notification/send?notificationType=User|Seller` backend endpoint (no new route — the endpoint already supported the multicast pattern; just wasn't exposed in the UI). Added a "Broadcast" sidebar entry with the lucide `Megaphone` icon.

Files: `waxxapp_admin/frontend/src/Component/Table/admin/BroadcastNotification.js` (new standalone page), `src/Component/Pages/Admin.js` (route registered at `/admin/broadcast`), `src/Component/Pages/Sidebar.js` (nav entry).

**No version bump needed for these — they're backend-only (Feature A) and admin-React-only (Feature B). Flutter app picks up Feature A push notifications automatically; no rebuild required.**

#### 📁 Files Changed (relative to 1.1.7+24)

**Backend** (`waxxapp_admin/backend/`):
- `server/address/address.model.js` — added `phoneNumber` field.
- `server/address/address.controller.js` — store + update read `req.body.phoneNumber`, normalise empty → null.

**Flutter** (`waxx_app/`):
- `pubspec.yaml` — version bump.
- `lib/seller_pages/listing/view/item_location_screen.dart` — drop `cities.isNotEmpty` gate, wire `allowCustomEntry`/`onCustomEntry`.
- `lib/seller_pages/listing/controller/listing_controller.dart` — `mergeCustomCities()` + `persistCustomCity()` helpers; `getStorage` import via `Theme/theme_service`.
- `lib/Controller/GetxController/user/user_add_address_controller.dart` — `phoneNumberController` + threaded through `userAddAddressData`.
- `lib/Controller/GetxController/user/user_update_address_controller.dart` — threaded `phoneNumber` through `userUpdateAddressData`.
- `lib/ApiService/user/user_add_address_service.dart` + `user_update_address_service.dart` — accept `phoneNumber`, send in JSON body (empty string when blank; backend normalises to null).
- `lib/ApiModel/user/UserAddressSelectModel.dart` + `GetAllUserAddressModel.dart` — `phoneNumber` field on `Address` (ctor / fromJson / toJson / copyWith / getter).
- `lib/utils/CoustomWidget/App_theme_services/textfields.dart` — new `controllerType: "UserPhoneNumber"` mapping to `userAddAddressController.phoneNumberController` + `TextInputType.phone` keyboard.
- `lib/View/MyApp/Profile/MyAddress/new_address.dart` — Phone Number field below Zip Code; `phoneNumberController.clear()` on initState.
- `lib/View/MyApp/Profile/MyAddress/update_address.dart` — `getPhoneNumber` constructor arg, prefill on initState, Phone Number field below Zip Code.
- `lib/View/MyApp/Profile/MyAddress/address.dart` — passes `getPhoneNumber: data.phoneNumber` into `UpdateAddress(...)` from the address list.
- `lib/View/MyApp/AppPages/cheak_out.dart` — `_buildContactPhone()` returns ONLY the per-address phone (no fallback). Drops the now-unused `Database` import.

**No `flutter pub get` needed** (no new packages).

---
## 🛠 Version 1.1.7+24 — Cart calc on Buy Now, seller-edit custom city, floating hearts on live

**Version:** 1.1.7
**Build Number:** 24
**Release Date:** May 2026
**Type:** Patch on top of v1.1.6+23

### Suggested Play Console release name
`v1.1.7 — Cart math fix + floating hearts`

### English (Default)

```
🔧 Update — v1.1.7

🛒 Cart totals now recalc correctly when reaching Cart via Buy Now
🏙 Seller "My Address" lets you type a custom city when not in the list
❤️ Floating hearts on live streams — your taps + every viewer's likes drift up
```

### 📋 Full Internal Release Notes

#### 🐛 Bug fixes

| Issue | Fix |
|---|---|
| **Buy Now → Cart: +/- buttons didn't recalc the Amount total** (worked fine on bottom-tab Cart) | Cascade of `Get.put(GetAllCartProductController())` calls in `_CartPageState` field init, `build()`, and `_CartListTileWidgetState` — each Get.put REPLACED the singleton, killing the parent GetBuilder's subscription. On the Buy Now flow, Product Detail had already put the controller, so Cart's Get.put was the second-or-later replacer; on the bottom-tab flow the State is stable and re-puts don't fire. Switched all three controllers in `cart_page.dart` to guarded `Get.isRegistered ? Get.find : Get.put`, removed the redundant `Get.put` inside `build()`, and added explicit `init: getAllCartProductController` to the `GetBuilder`. Same root cause as the saved `feedback_get_find_in_descendants.md` memory. |
| **Seller "My Address" couldn't add a city not in the preset list** (the user-side New Address / Update Address pages already had the "Use '<typed>'" CTA from v1.1.5) | Mirrored the same pattern on `seller_edit_address.dart`: added `_mergeCustomCities()` + `_persistCustomCity()` helpers, wired `allowCustomEntry: true` + `onCustomEntry` into the city sheet. Custom cities persist to local storage keyed by `customCities|<country>|<state>` so they appear alongside preset cities the next time the picker opens for the same state. |

#### 🆕 New on live streams

**Floating hearts** — TikTok-style. Whenever the room-wide `liveLikeCount` socket event ticks up (your tap or any other viewer's), a heart spawns near the bottom-right and drifts up ~55% of screen height with a sin-wave lateral sway, fades out. Up to 5 hearts per delta to keep catch-up bursts from flooding the scene. Varied size + colour palette (pink / red / orange / amber / brand blue). Wrapped in `IgnorePointer` so taps fall through to the action column / comments below.

#### 📁 Files Changed (relative to 1.1.6+23)

- `lib/View/MyApp/AppPages/cart_page.dart` — guarded find-or-put for the three cart controllers (page-level + tile-level), `init:` on the parent `GetBuilder`, removed redundant `Get.put` inside `build()`.
- `lib/View/MyApp/Seller/SellerProfile/seller_edit_address.dart` — `_mergeCustomCities` / `_persistCustomCity` helpers, `allowCustomEntry: true` + `onCustomEntry` on the city sheet, `getStorage` import.
- `lib/seller_pages/live_page/widget/floating_hearts_overlay.dart` (new) — listens to `SocketServices.liveLikeCount`, spawns animated hearts on every increase. Owns its own AnimationControllers + cleans them up on dispose.
- `lib/seller_pages/live_page/widget/live_widget.dart` — mounts `FloatingHeartsOverlay` in the LiveUi root Stack between the gradient and the action column.

**No backend changes.**

---
## 🛡 Version 1.1.6+23 — Selfie verification (admin-issued blue tick) + private storage for KYC docs

**Version:** 1.1.6
**Build Number:** 23
**Release Date:** May 2026
**Type:** Feature cut on top of v1.1.5+22

### Suggested Play Console release name
`v1.1.6 — Verify your account (blue tick)`

### English (Default)
*(Max 500 characters on Play Store)*

```
🆕 Update — v1.1.6

🛡 New "Verify your account" flow — submit a selfie, get a blue tick on your profile
🔒 Identity documents (selfies + seller KYC) now stored privately, not on a public URL
✓ Existing buyers AND sellers can verify
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 Selfie verification — opt-in, admin-issued blue tick

A new identity-verification flow for both buyers and sellers. Optional / encouraged from Profile (no blocking). Six small PRs landed in this cut, sequenced so each could be reviewed independently:

1. **Backend schema + settings toggle + private storage controller.** New `Verification` Mongo collection (one row per submission, history preserved). New `User.verificationStatus` denormalized field for hot-path badge reads. New `Setting.selfieVerification: { isRequired, isActive }` field, off by default. Reuses the existing `handleFieldSwitch` toggle endpoint by whitelisting the new field name.
2. **Verification endpoints + KYC migration.** New `/verification/submitSelfie` (multipart, 3/24h rate-limit, ML Kit `autoCheckResult` stored as admin context), `/verification/myStatus`, `/verification/admin/list`, `/verification/admin/review` (admin-JWT-gated, FCM push on decision). New `kycAwareStorage` multer config + `fileUrlFor` helper that route fields named `selfie` / `govId` / `addressProof` / `registrationCert` to a non-public `private_storage/` dir served via the auth-gated `/private-file/:filename` controller. Existing seller KYC uploads migrated via `scripts/migrateKycToPrivate.js` (idempotent, `--dry` mode). Logo + profile images keep using the public `storage/` path.
3. **Admin React: Verifications queue + Settings toggle row.** New `/admin/verification` page — paginated queue with a default `pending_review` filter (switchable to `verified` / `rejected` / `all`). Per-row Approve / Reject (with rejection-reason textarea modal). Selfie thumbnail click shows full-size preview. ML Kit autoCheckResult shown inline so admins can triage quickly. New "Selfie Verification" toggle row on the Settings page mirrors the existing Address Proof / Government ID layout.
4. **Flutter capture flow + Profile entry.** New `/SelfieVerification` route with a feature folder (view + controller). Front-camera-only `ImagePicker` (no gallery — defeats the purpose). On-device `google_mlkit_face_detection` 0.13.x gates the Submit button: face count == 1, both eyes open above 0.4 probability, face area ≥ 18% of the frame. Failures show a friendly retake CTA; ML Kit is NOT used for auto-pass — admin reviews every submission. After submit, the screen shows "Pending review" with copy explaining the ~24h SLA; rejection reasons surface on the next visit so users can fix and retry. Profile main page gains a status-aware tile ("Verify your account" / "Pending" / "Verified ✓" / "Retry"), gated by the admin's `selfieVerification.isActive` flag.
5. **Verified badge rollout.** New generic `VerifiedUserBadge` widget driven by a status string — renders the existing blue tick only when `status == "verified"`. Existing `VerifiedSellerBadge` kept for backwards compat but now delegates to the new widget, which means the soft `businessTag != ""` trigger that everyone could fake by typing a tag is gone — the badge now only appears when admin has actually approved the user. Initial surfaces: own Profile header, seller-profile preview. The seller profile API now joins `User.verificationStatus` into its aggregate so the badge can render server-driven. Other surfaces (product detail seller row, live host card, search results, order detail "sold by") are tracked as a backend-payload follow-up.
6. **Ship.** Default `Setting.selfieVerification.isActive` stays `false` after deploy so admins can sanity-check the queue with internal accounts before users see the entry tile. Flip the toggle on the new Setting row to enable in production.

#### 🔒 Private storage for KYC documents

Selfies are biometric PII. Backend `/storage/` is publicly served — anyone with a URL could fetch any selfie, gov ID, address proof, or registration cert. This cut closes that hole for **all four document types**:

- New `private_storage/` dir, NOT served by the static `/storage` middleware.
- New `/private-file/:filename` controller — auth-gated. Admin (JWT in Authorization header) OR document owner (`userId` in request body/query, validated against ownership across `Verification` / `Seller` / `SellerRequest` collections) can fetch; everyone else gets 401/403.
- One-shot migration script `scripts/migrateKycToPrivate.js` moves existing files and rewrites the URL fields on `Seller` and `SellerRequest`. Run BEFORE deploying so the static `/storage` handler can't serve them publicly anymore. Idempotent + has a `--dry` mode.

#### 📁 Files Changed (relative to 1.1.5+22)

**Backend** (`waxxapp_admin/backend/`):
- `server/verification/{verification.model,verification.controller,verification.route}.js` (new)
- `server/privateFile/{privateFile.controller,privateFile.route}.js` (new)
- `server/user/user.model.js` — `verificationStatus`
- `server/setting/{setting.model,setting.controller}.js` — `selfieVerification` field + `validFields` whitelist
- `server/seller/seller.controller.js` — `fetchSellerProfile` aggregate joins `User.verificationStatus`
- `server/sellerRequest/{sellerRequest.route,sellerRequest.controller}.js` — `mixedUpload` (kycAwareStorage) + `fileUrlFor`
- `util/multer.js` — `privateStorage`, `kycAwareStorage`, `fileUrlFor` helper, `KYC_FIELDNAMES`
- `route.js` — mounts `/private-file` and `/verification`
- `scripts/migrateKycToPrivate.js` (new, one-shot, `--dry` mode)
- `.gitignore` — `/private_storage/*`

**Flutter** (`waxx_app/`):
- `pubspec.yaml` — `google_mlkit_face_detection: ^0.13.1` + version bump
- `ios/Runner/Info.plist` — `NSCameraUsageDescription` mentions identity verification
- `lib/user_pages/selfie_verification/{view,controller}/...` (new)
- `lib/ApiService/user/{submit_selfie_verification,get_selfie_verification_status}_service.dart` (new)
- `lib/ApiModel/user/SelfieVerificationModel.dart` (new)
- `lib/custom/verified_user_badge.dart` (new), `verified_seller_badge.dart` (delegates)
- `lib/utils/api_url.dart`, `globle_veriables.dart`, `routes_pages.dart`
- `lib/Controller/GetxController/login/{splash_screen,login}_controller.dart` — hydrate `verificationStatus`
- `lib/View/MyApp/Profile/main_profile.dart` — entry tile + badge in header
- `lib/user_pages/preview_seller_profile_page/{view,model}/...` — badge swap
- `lib/ApiModel/login/{SettingApiModel,WhoLoginModel}.dart` — new fields

**Admin** (`waxxapp_admin/frontend/`):
- `src/Component/Table/verification/Verification.js` (new)
- `src/Component/store/verification/{verification.action,verification.reducer,verification.type}.js` (new)
- `src/Component/store/index.js` — register slice
- `src/Component/Pages/{Admin,Sidebar}.js` — route + nav
- `src/Component/Table/setting/Setting.js` — toggle row

#### 🚀 Deploy checklist for v1.1.6

1. **Run migration BEFORE deploy.** On the server: `cd waxxapp_admin/backend && node scripts/migrateKycToPrivate.js --dry` to preview, then re-run without `--dry` to actually move files. Restart the backend.
2. **Deploy backend + admin React.** `git pull`, `pm2 restart backend`, `cd ../frontend && npm install --f && ./deploy.sh`.
3. **Sanity-check the admin queue.** Sign up an internal test account, take a selfie via the app, confirm it lands in `/admin/verification` with the auto-check details + selfie preview. Approve. Confirm `User.verificationStatus` is now `verified` and the badge appears on the user's profile header.
4. **Sanity-check the migration.** Open a SellerRequest record's `govId` URL — it should be `/private-file/<filename>` not `/storage/<filename>`. Try to fetch it without admin JWT → 401/403.
5. **Flip the feature on.** In the admin Settings page, toggle "Selfie Verification → Active" on. The Profile entry tile now appears for all users.
6. **Upload `app-release.aab` (1.1.6+23) to Production.**

#### ⚠️ Risks / out-of-scope

- **Globals only refresh on cold start.** Toggling `selfieVerification.isActive` won't propagate mid-session — existing logged-in users keep their previous tile state until kill + reopen. Matches existing settings-toggle behavior.
- **No auto-pass.** Admins shoulder every decision. ML Kit only gates submission for usability. If queue volume becomes unwieldy, the next iteration can add a paper-code + head-turn challenge for an `auto_verified` lane.
- **Right-to-erasure.** When a user deletes their account, `Verification` rows + the underlying selfie files should be removed. Wire this into the existing user-deletion controller as a follow-up if not already covered.
- **Other 18 locales.** New strings (entry tile, status chip, capture screen copy, rejection-reason text) are English-only on first ship; matches the v1.1.4 momo-placeholder pattern (known follow-up).
- **Other badge surfaces** (product detail seller row, live host card, search results, order detail "sold by") are tracked as a follow-up — each needs the relevant backend payload to also expose `verificationStatus`.

---
## ⚡ Version 1.1.5+22 — Buy Now → Cart, quantity counter, custom cities, distinct Help/Contact/Support labels

**Version:** 1.1.5
**Build Number:** 22
**Release Date:** May 2026
**Type:** Patch cluster on top of v1.1.4+21 (Buy Now flow re-routing + checkout polish + address polish + label cleanup)

### Suggested Play Console release name
`v1.1.5 — Buy Now via Cart + quantity + city polish`

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.1.5

🛒 Buy Now now goes through Cart so you can review before paying
🔢 Quantity counter on the product page (works for Buy Now & Add to Cart)
📞 Buyer phone now visible on Checkout's Delivery Location card
🏙 Type your own city when it's not in the list — saved for next time
↩️ Cart page now has a back arrow when reached via Buy Now
✨ Distinct Help / Contact Us / Customer Support labels + new icon
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 Changes in v1.1.5

**Buy Now flow change + product-detail quantity counter**

Two product-direction tweaks bundled on top of the v1.1.4+21 cut:

- **Buy Now now lands on Cart, not Checkout.** Tapping Buy Now on Product Detail still adds the product to cart, but the post-add navigation goes to `/CartPage` instead of `/CheckOut`. Buyers review the cart (line items + per-item delivery picker + promo input) and tap Checkout from there. This restores the "review before pay" step that the v1.1.4 fast lane bypassed when going directly to Checkout. The cart-tab Continue → Paystack auto-launch is unchanged — only the Buy Now entry point shifts.
- **Quantity selector on Product Detail.** A new "Quantity − N +" row sits above the Buy Now / Add to Cart action buttons. Both buttons honour the chosen quantity (was hardcoded to 1). Min is 1; no upper cap (matching cart-page UX). Resets to 1 each time the page is opened.

**Files touched**: `lib/View/MyApp/AppPages/product_detail.dart` (added `_quantity` state + `_buildQuantitySelector()` widget; `addToCart()` passes `productQuantity: _quantity`; `onBuyNow()` navigates to `/CartPage` instead of `/CheckOut`).

**Phone number on Checkout's Delivery Location card**

The Address model has no phone field, but the seller still wants the buyer's contact number visible at checkout. Surfaced the buyer's signup `mobileNumber` + `dialCode` (already in global state from login) below the address text, with a phone-icon prefix. Hidden when no address is selected or the user has no phone on file. No backend change.

**Files touched**: `lib/View/MyApp/AppPages/cheak_out.dart` (new `_buildContactPhone()` helper + phone row inside the Delivery Location `Container`).

**Cart back arrow + system-back routing for Buy Now → Cart**

The Cart page is reached two ways: as a bottom-tab (no previous route — back should switch to Home tab, the existing `BottomBarController.onChangeBottomBar(0)` behavior) and via `Get.toNamed("/CartPage")` from Buy Now (Product Detail is below — back should pop normally back to the product). The previous build hard-coded `PopScope(canPop: false)` and rendered no back arrow, leaving Buy Now buyers trapped on Cart.

- The `PopScope` now uses `Navigator.canPop(context)` so system-back pops normally when there's a route below, and falls through to the home-tab switch only on the bottom-tab path.
- `CartAppBarWidget` accepts an optional `showBack` flag and renders a left-aligned back arrow that calls `Get.back()` when set. The cart-tab presentation still has no arrow (canPop is false there).

**Files touched**: `lib/View/MyApp/AppPages/cart_page.dart` (`PopScope.canPop` derived from `Navigator.canPop(context)`; `CartAppBarWidget` gains `showBack` param and renders an `IconButton(arrow_back_ios_new)` when true).

**New Address — type a custom city when the preset list doesn't have it**

The New Address city picker is keyed off the bundled `country_state_city.json` dataset. Many Ghana cities (and small towns elsewhere) aren't in that dataset, so users either had to pick a wrong approximation or got stuck. Added a "Use '<typed>'" CTA: when the user types a city that doesn't match any preset entry, an `+ add` tile appears in place of the empty-results message. Tapping it accepts the typed value AND persists it to local storage keyed by `customCities|<country>|<state>` so it appears alongside preset cities the next time the picker opens for the same state. The picker also now opens for any selected state (previously gated on `cities.isNotEmpty`), so users can add cities even for states whose preset list is empty.

**Files touched**: `lib/View/MyApp/Profile/MyAddress/new_address.dart` (`_mergeCustomCities()` + `_persistCustomCity()` helpers, custom-entry params on the city sheet call, picker shown for any selected state), `lib/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart` (new `allowCustomEntry` + `onCustomEntry` params; renders a "Use '<typed>'" tile in the empty-results state).

**Update Address — same picker-with-add-custom UX as New Address**

Previously Update Address's city field was a plain text input (per the v1.1.2 fix) while New Address used a dropdown picker. Sellers/buyers expected the same UX on both screens. Update Address's city field now opens the same `addressSelectSheet` with `allowCustomEntry: true` — preset cities for the chosen country/state PLUS any custom cities the user previously typed (persisted via `_persistCustomCity`). Empty-results state shows a "Use '<typed>'" tile that accepts the typed value AND saves it to local storage.

**Files touched**: `lib/View/MyApp/Profile/MyAddress/update_address.dart` (replace plain text city input with picker; add `_mergeCustomCities()` + `_persistCustomCity()` helpers; switch import from `globle_veriables` to `Theme/theme_service` for `getStorage`).

**Phone number on Checkout's Delivery Location card — fallback to profile model**

The phone row added in the previous fix only showed when the global `mobileNumber` / `dialCode` were non-empty, but `login_controller` never wrote them — so existing logged-in users never saw the phone. Two-part fix: (1) `_buildContactPhone()` in `cheak_out.dart` now falls back to `Database.fetchLoginUserProfileModel?.user?.mobileNumber` + `.countryCode` when the globals are empty (works immediately for existing sessions, since the splash refreshes that profile model on every app start). (2) `login_controller.dart` now captures the phone + dial code from the profile after the WhoLoginApi call into the globals AND persists them to `getStorage` (`mobileNumber` / `dialCode` keys), so future logins populate the global directly without needing the fallback.

**Files touched**: `lib/View/MyApp/AppPages/cheak_out.dart` (fallback in `_buildContactPhone()` + `Database` import), `lib/Controller/GetxController/login/login_controller.dart` (capture + persist `mobileNumber` and `dialCode` on login).

**DeliveryOptionsPicker — guarded find-or-put for hot-reload safety**

A bare `Get.find<GetAllCartProductController>()` deep inside the cart-list and checkout-list trees threw "controller not found" on hot-reload — the in-memory widget tree is preserved by hot-reload but GetX's instance registry can clear, and the leaf widget rebuilds before the ancestor re-runs `Get.put`. Switched to `Get.isRegistered<T>() ? Get.find<T>() : Get.put(T())` so the widget self-heals: idempotent (returns existing instance if registered) and harmless when called multiple times. Not reproducible on a release build with a fresh start; only hot-reload triggers it. Added `feedback_get_find_in_descendants.md` memory so this pattern is on the radar for similar widgets going forward.

**Files touched**: `lib/custom/delivery_options_picker.dart` (`Get.find` → `isRegistered ? find : put` with comment explaining why).

**Three distinct labels for Help / Contact Us / Customer Support**

The Settings page entry, the Profile page entry, and the support-chat AppBar all shared one string key (`helpAndSupport`) and rendered the same label everywhere. Per product direction, each surface now reads differently:

- **Settings → "Help and Support"** — unchanged label, still uses `St.helpAndSupport.tr`. Icon stays as `icHelp` (question-mark / help glyph, fits the FAQ-style "Help and Support" page that opens beneath it).
- **Profile → "Contact Us"** — new `contactUs` string key + new `ic_phone_mail.webp` icon registered as `AppAsset.icPhoneMail` (the asset already lived in `assets/icons/` but wasn't wired into `app_asset.dart`). The Profile entry that opens the live support chat thread uses both.
- **Support chat thread AppBar → "Customer Support"** — new `customerSupport` string key. Distinguishes the actual conversation page from the entry-point label that got the user there.

The two new keys are English-only (other 18 locales fall through to displaying the raw key, same known follow-up as the v1.1.4 momo placeholders and `support_*` chat strings).

**Files touched**: `lib/utils/Strings/strings.dart` (new `contactUs` + `customerSupport` keys), `lib/localization/language/english_language.dart` (English values for the new keys), `lib/View/MyApp/Profile/main_profile.dart` (Profile entry switches to `St.contactUs.tr` + `AppAsset.icPhoneMail`), `lib/user_pages/support_chat/view/support_chat_view.dart` (AppBar title switches to `St.customerSupport.tr`), `lib/utils/app_asset.dart` (new `icPhoneMail` constant pointing at `ic_phone_mail.webp`).

#### 📁 Files Changed (relative to 1.1.4+21)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.1.4+21` → `1.1.5+22`) |
| Buy Now → Cart + quantity selector | `lib/View/MyApp/AppPages/product_detail.dart` |
| Cart back arrow + system-back routing | `lib/View/MyApp/AppPages/cart_page.dart` |
| Checkout phone row + profile fallback | `lib/View/MyApp/AppPages/cheak_out.dart`, `lib/Controller/GetxController/login/login_controller.dart` |
| New + Update Address custom city | `lib/View/MyApp/Profile/MyAddress/new_address.dart`, `lib/View/MyApp/Profile/MyAddress/update_address.dart`, `lib/View/MyApp/Profile/MyAddress/widget/address_select_sheet.dart` |
| DeliveryOptionsPicker hot-reload safety | `lib/custom/delivery_options_picker.dart` |
| Help / Contact Us / Customer Support split | `lib/utils/Strings/strings.dart`, `lib/localization/language/english_language.dart`, `lib/View/MyApp/Profile/main_profile.dart`, `lib/user_pages/support_chat/view/support_chat_view.dart`, `lib/utils/app_asset.dart` |

#### 🚀 Deploy checklist for v1.1.5

1. Upload `app-release.aab` (1.1.5+22) to the Production track.
2. Smoke test on the new build:
   - Tap Buy Now on a product → lands on Cart, not Checkout. Tap the back arrow → returns to Product Detail (no tab switch).
   - Use the quantity counter on Product Detail → both Buy Now and Add to Cart respect the chosen quantity.
   - Open Checkout while logged in → Delivery Location card shows the buyer's phone (with dial code) below the address. Existing sessions show it without re-login.
   - New Address → state with cities → type a city not in the list → "Use 'X'" tile appears → tap → city saves → reopen the picker, the typed city is in the list.
   - Update Address → same custom-city UX as New Address.
   - Settings page → "Help and Support" entry (icon: question-mark / `icHelp`).
   - Profile page → "Contact Us" entry (icon: phone+mail / `icPhoneMail`) → tap → support thread AppBar reads "Customer Support".

**No backend changes.** No DB migration needed.

---
## ⚡ Version 1.1.4+21 — Buy Now → Paystack fast lane + checkout polish + support chat read receipts

**Version:** 1.1.4
**Build Number:** 21
**Release Date:** May 2026
**Type:** Patch cluster on top of v1.1.2+19 / v1.1.3+20 (the +20 cut was a partial fix that bounced users back to Home for Buy Now — superseded by the patches in this cut)

### Suggested Play Console release name
`v1.1.4 — Buy Now → Paystack one-tap + chat receipts`

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.1.4

⚡ Buy Now → review → straight to Paystack (no extra picker step)
🛒 Cart Checkout also auto-launches Paystack — fewer taps to pay
✓✓ Support chat read receipts — see when admin reads your message
🟢 "Support is online" banner shows when an admin is viewing
↩️ Cancel from Paystack now correctly returns to Checkout
🛍 Complete Seller form: Momo Number / Network Name / Momo Name labels
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New features in v1.1.4

**Buy Now → review → Paystack (no payment-method picker)**
- Tapping Buy Now on Product Detail now goes through Checkout (so the buyer can review address, line items, and totals) and then directly into Paystack on Continue. The `/PaymentPage` payment-method picker is hidden when `autoStartGateway` is set.
- Same fast path for **cart-tab** purchases — Cart → Checkout → Continue → Paystack opens immediately. Payment-method tiles + Pay Now button are hidden in this mode; users see "Opening Paystack…" briefly, then the Paystack webview.
- `paymentReference` is threaded through end-to-end so the backend webhook (`/payment/paystack/webhook`) can mark the order paid even if the app dies mid-checkout.
- Easy to revert when other gateways are turned on for a market: drop the `"autoStartGateway": "Paystack"` key from Checkout's Continue button — the picker comes back unchanged.

**Customer-support chat — WhatsApp-style read receipts + presence**
- Each user-sent bubble shows ✓ (sent) or ✓✓ (read by admin). The double-tick flips sky-blue when an admin opens the conversation OR receives a new message while already viewing it.
- Same on the admin React panel — admin-sent bubbles show ✓/✓✓ for "read by user".
- New "Support is online" banner with a green dot shows on the buyer's chat view while an admin has the conversation open. Clears when the admin closes the thread, switches threads, or leaves the inbox page.
- Live mark-read: a new `supportMarkRead` socket event fires whenever an opposite-side message lands during an active session, so receipts flip in real time without re-opening the chat.

#### 🐛 Bug fixes in v1.1.4

| Issue | Fix |
|---|---|
| **Buy Now took users back to Home instead of opening Pay Now** (introduced in v1.1.2+19's fast-path commit) | The route name was wrong — I shipped `/OrderPayment`, the actual route is `/PaymentPage`. GetX silently falls back to the unknown-route handler (which lands on Home) when you `Get.toNamed` an unregistered name. Switched to `/PaymentPage` — same route Cart's existing Continue button uses. |
| **Cart-tab → Checkout crashed with "setState() called during build"** | The earlier "show shimmer immediately" fix mutated the singleton cart controller's `firstLoading.value = true` synchronously in Checkout's initState. Cart page was still in the route stack below with an Obx subscribed to that flag, and Flutter rejected the mid-build dirty-mark. Reverted; the empty-cart fallback now handles the underlying "blank Checkout" symptom by popping back if items are empty. |
| **Checkout body crashed with "Null check operator used on a null value" inside GetBuilder** | The four `GetBuilder<GetAllCartProductController>` wrappers I added (Order Info, Sub Total, Shipping charge, Total) relied on Get's implicit `Get.find`. The Get package's internal `!` unwrap on the find path tripped a null even though the controller was registered. Pass `init: getAllCartProductController` to all four GetBuilders. |
| **Pressing back from Paystack webview left users stuck on "Opening Paystack…" forever** | `paystack_for_flutter` 1.0.4 closes the webview on Android system-back without firing `onSuccess` OR `onCancelled` — `pay()` just returns silently. Added a `paystackHandled` flag set inside each callback; if `pay()` resolves with the flag still false, treat as cancel and pop `/PaymentPage`. |
| **Email "Open the app" CTA opened the backend website instead of the app** | The `sellerApproved` + `productApproved` templates had `ctaUrl: config.baseURL || ""` which resolves to the backend root. Replaced with a hardened `appOpenLink()` helper that returns the Play Store URL by default and rejects backend-domain overrides if `global.settingJSON.appOpenLink` somehow contains them. |
| **Empty Checkout page after Buy Now when add-to-cart silently failed** | `addProductToCartData` swallowed backend rejections (e.g. user trying to buy own product, blocked accounts, network errors); Buy Now navigated to /CheckOut with an unchanged cart. `onBuyNow` now checks the response status and toasts the rejection message before navigating. Checkout's initState also pops back with an empty-cart toast if the fetch returns no items. |
| **Complete Seller form had pre-momo placeholders** | "Enter account number", "Enter Ifsc", "Enter branch" → "Enter Momo Number", "Enter Network Name", "Enter Momo Name" (English only; the 18 other locales still carry the old strings as a known follow-up). |

#### 📁 Files Changed (relative to 1.1.2+19)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.1.2+19` → `1.1.4+21`; `+20` was a partial fix superseded by the patches in this cut) |
| Buy Now → Paystack fast lane | `lib/View/MyApp/AppPages/product_detail.dart` (`onBuyNow` checks addToCart success + navigates to `/CheckOut` with `isBuyNow: true`), `lib/View/MyApp/AppPages/cheak_out.dart` (`autoStartGateway: "Paystack"` always passed on Continue), `lib/seller_pages/order_payment_page/controller/order_payment_controller.dart` (auto-fires Paystack on init when `autoStartGateway` set; silent-return fallback for system-back), `lib/seller_pages/order_payment_page/view/order_payment_view.dart` (hides picker tiles + Pay Now button in autoStart mode, shows "Opening Paystack…" spinner), `lib/PaymentMethod/paystack/paystack_service.dart` (new `onCancelled` callback) |
| Checkout reactivity | `lib/View/MyApp/AppPages/cheak_out.dart` (4 GetBuilders pass `init:` explicitly; empty-cart fallback in initState; `isBuyNow` flag from Get.arguments) |
| Support chat read receipts | `backend/server/support/support.controller.js` (`supportRead` broadcast on user/admin open), `backend/socket.js` (new `supportMarkRead` socket handler for live read-receipts), `lib/utils/socket_services.dart` (`supportReadStream` + `onSupportMarkRead` emit helper), `lib/user_pages/support_chat/controller/support_chat_controller.dart` (live mark-read on incoming admin messages + presence + tick state), `lib/user_pages/support_chat/view/support_chat_view.dart` (✓ / ✓✓ rendering + "Support is online" banner), `frontend/src/Component/Table/support/SupportInbox.js` (presence emit + tick rendering + live mark-read on incoming user messages + `type="button"` on every button to fix reload-on-send) |
| Email CTA hardening | `backend/util/emailSender.js` (defensive `appOpenLink()` rejects backend-domain overrides), `backend/package.json` (`1.18.x` → `1.19.x`) |
| Complete Seller momo placeholders | `lib/localization/language/english_language.dart` |

#### 🚀 Deploy checklist for v1.1.4

1. `git pull` in `waxxapp_admin/backend` and `pm2 restart backend` so the support read-receipt socket handler + the hardened email link are live.
2. `cd waxxapp_admin/frontend && npm install --f && ./deploy.sh` so the admin panel's read-receipts + tick rendering land. (Or rely on the GitHub Action — already wired.)
3. Upload `app-release.aab` (1.1.4+21) to the Production track.
4. Smoke test on the new build:
   - Buy Now → Checkout → Continue → Paystack webview opens.
   - Press back from Paystack → returns to Checkout (not stuck on spinner).
   - Buy Now on a product the buyer can't add to cart (e.g. their own listing) → toast surfaces the rejection, no blank Checkout.
   - Cart-tab → Checkout → Continue → Paystack webview opens.
   - Help & Support chat: send a message → ✓ (sent). Open admin panel and read it → ✓✓ (sky blue). Send another while admin is still viewing → also ticks to ✓✓ in real time.

---
## ⚡ Version 1.1.2+19 — Buy Now fast path + city is free-text + empty Checkout fix

**Version:** 1.1.2
**Build Number:** 19
**Release Date:** May 2026
**Type:** UX patch on top of v1.1.1+18

### Suggested Play Console release name
`v1.1.2 — Buy Now one-tap + address polish`

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.1.2

⚡ Buy Now goes straight to payment — one fewer step
🏙 Type your city directly on the address form (no fixed list)
✨ Smoother loading on Cart → Checkout
```

### 📋 Full Internal Release Notes (for your team)

#### 🛠 UX changes in v1.1.2

**Buy Now bypasses Checkout — straight to Pay Now**
- Tapping Buy Now on a product detail now adds the product to cart and routes directly to `/OrderPayment` with the computed `finalTotal` (sub-total + shipping). The intermediate `/CheckOut` step is skipped for Buy Now purchases.
- The Cart tab → Checkout → Pay Now path is unchanged. Full Checkout still runs when the buyer explicitly opens Cart to review items, where the address row, promo-code input, per-item delivery-option picker, and totals breakdown all stay reachable.
- Trade-offs the fast path skips:
  - **No promo-code input** — Buy Now applies no promo. Cart-based buyers still get the input.
  - **No per-item delivery-option picker** — Buy Now uses whatever default the cart auto-picks (`resolveCartShipping` server-side picks the first available option). Cart-based buyers still get the picker.
  - **No address review** — `/order/create` looks the buyer's selected `Address` up server-side via `Address.findOne({ userId, isSelect: true })`, so the order proceeds with the same address Checkout would have shown. Buyers without a selected address can still set one from Profile → My Address.

**City is now a plain text input on Update Address**
- The Update Address page used to force users through a fixed city dropdown keyed off the bundled `country_state_city.json` dataset. Many Ghana cities (and small towns elsewhere) aren't in that dataset, so users either picked a wrong approximation or got stuck.
- Replaced with a plain text input — users can now type any city name. The state-keyed city-list helper stays in the file but is unused, so re-enabling the picker later is a one-line revert.

#### 🐛 Bug fixes in v1.1.2

| Issue | Fix |
|---|---|
| Buy Now → Checkout briefly rendered an empty page (no Order Info, no totals) before the Pay Now button could be tapped | Independent of the Buy Now redirect above — useful for cart-based buyers too. The Checkout body's `Obx` was only watching `getOnlySelectedUserAddressController.isLoading`. Address loaded fast → Obx flipped → body rendered against still-empty cart data while the cart fetch was in flight. Now also watches `getAllCartProductController.firstLoading` so the existing `checkoutShimmer` covers the gap until BOTH data sources are loaded. |

#### 📁 Files Changed (relative to 1.1.1+18)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.1.1+18` → `1.1.2+19`) |
| Buy Now fast path | `lib/View/MyApp/AppPages/product_detail.dart` (`onBuyNow` awaits cart fetch, navigates to `/OrderPayment` with `finalTotal` in arguments — no controller change needed since `OrderPaymentController` already reads `finalTotal` from `Get.arguments`) |
| Empty Checkout shimmer fix | `lib/View/MyApp/AppPages/cheak_out.dart` (body `Obx` now also waits on `cart.firstLoading`) |
| City as free-text | `lib/View/MyApp/Profile/MyAddress/update_address.dart` (drop `readOnly: true` + `addressSelectSheet` onTap, use plain `PrimaryTextField`) |

#### 🚀 Deploy checklist for 1.1.2+19

1. Upload `app-release.aab` (1.1.2+19) to the Production track. Same release-notes flow as the +18 cut — paste the English block above + auto-translate the rest.
2. No backend deploy needed — Flutter-only patch.

---
## ✂️ Version 1.1.1+18 — Drop Terms & Conditions step from seller signup

**Version:** 1.1.1
**Build Number:** 18
**Release Date:** May 2026
**Type:** Small UX patch on top of v1.1.0+17

### Suggested Play Console release name
`v1.1.1 — Streamlined seller signup`

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.1.1

✂️ Streamlined seller signup — fewer steps to start selling
```

### 📋 Full Internal Release Notes (for your team)

#### 🛠 UX changes in v1.1.1

**Seller signup no longer asks you to accept Terms & Conditions**
- Sellers used to land on a Terms & Conditions screen between submitting their documents and creating the account. Per product direction, that step was redundant — the only thing it gated was the same `onSubmitTermsAndCondition()` call that creates the seller. Inlined that call into `onSubmitDocumentsDetails`, so finishing the documents step submits the seller account directly. One tap, not two.
- Demo-user check is preserved — demo accounts still see the "this is a demo user" toast instead of submitting.
- The `TermsAndConditions` screen file + `/TermsAndConditions` route stay in the codebase but are no longer reachable from the signup flow. Re-adding the gate is a one-line revert if compliance ever needs it.

#### 📁 Files Changed (relative to 1.1.0+17)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.1.0+17` → `1.1.1+18`) |
| Seller signup flow | `lib/Controller/GetxController/seller/seller_common_controller.dart` (`onSubmitDocumentsDetails` calls `onSubmitTermsAndCondition` directly) |

#### 🚀 Deploy checklist for 1.1.1+18

1. Upload `app-release.aab` (1.1.1+18) to the Production track. Same release-notes flow as the +17 cut — paste the English block above + auto-translate the rest.
2. No backend deploy needed — this is a Flutter-only patch.

---
## 💬 Version 1.1.0+17 — Live customer support + cold-start push deep-link fix

**Version:** 1.1.0
**Build Number:** 17 (was 15 at first prod cut, 16 was a re-upload)
**Release Date:** May 2026
**Type:** Feature drop + critical bugfix on top of the v1.1.0 production launch
**Note:** Same version name as the production launch (1.1.0) — versionCode 17 just lets us upload a fresh AAB with the new fixes. Promote via Play Console as a normal release on the Production track.

### Suggested Play Console release name
`v1.1.0 — Build 17 (Live Support + push fix)`

### English (Default)
*(Max 500 characters on Play Store — what users see in "What's New")*

```
🔧 Update — v1.1.0 (Build 17)

💬 Live customer support chat — talk to our team in-app
📲 Live push notification tap reliably opens the broadcast
🛒 Tap a product name on Checkout to re-view it
💳 Fixed Paystack "Initialize payment again" black screen
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New features in 1.1.0+17

**Live customer-support chat**
- New "Help and Support" entry on the buyer Profile menu opens a realtime 1:1 chat with the Waxxapp support pool. Persistent — one conversation per user, ever; reopens to full message history every time.
- Built on the existing Socket.io connection. No new realtime infrastructure: backend `server/support/` (new feature folder) adds `SupportConversation` model + 6 endpoints + 4 socket events (`supportJoin`/`supportLeave` for the per-conversation room, `supportInboxJoin`/`supportInboxLeave` for the admin-wide listing room).
- Admin React panel adds a `/admin/supportInbox` route with a two-pane inbox: filterable list (open / closed / all) + user search on the left, full thread + composer on the right. Live-updates via `socket.io-client` (added to `frontend/package.json`).
- FCM push to user on every admin reply (`type: SUPPORT_REPLY`); foreground-tap shows in-app snackbar, background/cold-start tap routes straight to `/SupportChat`.
- 3 new locale strings (`supportEmptyTitle`, `supportEmptySubtitle`, `supportComposeHint`) translated across all 18 language files via the new `scripts/_add_support_keys.py` helper.

**Tappable product name on Checkout's Order Info**
- Each line item on Checkout now has a tappable, primary-underlined product name that opens `/ProductDetail` so buyers can re-check the description / images before confirming the order. Uses the same productId-global pattern other surfaces use; defensive against empty / `"null"` ids.

#### 🐛 Bug fixes in 1.1.0+17

| Issue | Fix |
|---|---|
| **Tap on a "Seller is live now" push reliably dropped users on Home instead of the broadcast** — even after the v1.0.11 stash + replay machinery shipped | Two compounding bugs in the `LIVE_STARTED` cold-start path: (a) `getStorage.write('pendingDeepLinkLiveId', ...)` was followed on the very next synchronous line by `getStorage.remove(...)` — same JS tick, no awaits — so the splash controller's `_replayPendingDeepLink` always read AFTER the remove and saw nothing; (b) the same branch ALSO called `AppLinkService.openLive()` inline, which raced against splash's `Get.offAllNamed("/BottomTabBar")` and got wiped half the time. Split the cold path completely: `registerInteractionHandlers` no longer calls `handleRemoteMessage` on the cold-start initial message — a tiny new `_stashColdStartTap` writes the deep-link target and returns. The splash controller's `_replayPendingDeepLink` consumes it 200ms AFTER `Get.offAllNamed` lands. Warm taps (`onMessageOpenedApp` + foreground local-notification tap) are now a single direct `openLive` call with no stash dance. Same mechanism extended to `SUPPORT_REPLY` cold-start. |
| Paystack checkout dumped users on a black "Initialize payment again" screen with `'List<Map<String, dynamic>>' is not a subtype of 'String' of 'value'` | The `paystack_for_flutter 1.0.4` SDK's metadata serializer/parser pair are mutually inconsistent — flat `{"userId": "..."}` shape blows up one branch, the canonical `{"custom_fields": [{display_name, variable_name, value}]}` shape blows up the other. Removed the `metaData` field entirely (the package's own README sample omits it). The Paystack `reference` correlates back to Waxxapp via the `paymentReference` field on the Order doc, which is searchable in the Paystack dashboard — so no functional loss. |

#### 📁 Files Changed (relative to 1.1.0+15)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.1.0+15` → `1.1.0+17`; `+16` was a routine re-upload with no code changes) |
| Live customer support — backend | `backend/server/support/{support.model.js,support.controller.js,support.route.js}` (new), `backend/route.js` (mount), `backend/socket.js` (4 new events) |
| Live customer support — admin panel | `frontend/src/Component/Table/support/SupportInbox.js` (new), `frontend/src/Component/Pages/Admin.js` (route mount), `frontend/src/Component/Pages/Sidebar.js` (sidebar entry), `frontend/package.json` (+`socket.io-client ^4.7.5`) |
| Live customer support — Flutter | `lib/ApiModel/user/support_conversation_model.dart` (new), `lib/ApiService/user/support_chat_service.dart` (new), `lib/user_pages/support_chat/{controller,view}/*` (new), `lib/utils/socket_services.dart` (`supportMessageStream` + emit helpers), `lib/utils/api_url.dart`, `lib/utils/Strings/strings.dart`, `lib/utils/routes_pages.dart` (route), `lib/View/MyApp/Profile/main_profile.dart` (entry point), `lib/services/push_notification_service.dart` (SUPPORT_REPLY handler), `lib/localization/language/*.dart` (×18), `scripts/_add_support_keys.py` (new) |
| Tappable Order Info product name | `lib/View/MyApp/AppPages/cheak_out.dart` |
| Push deep-link cold-start race fix | `lib/services/push_notification_service.dart` (new `_stashColdStartTap` + cleaned `LIVE_STARTED` branch), `lib/Controller/GetxController/login/splash_screen_controller.dart` (`_replayPendingDeepLink` extended for support tap) |
| Paystack metaData crash fix | `lib/PaymentMethod/paystack/paystack_service.dart` (drop `metaData`) |

### 🚀 Deploy checklist for 1.1.0+17

1. `git pull` in `waxxapp_admin/backend` to HEAD and `pm2 restart backend` so the new `/support/*` endpoints + the `supportJoin`/`supportInboxJoin` socket events are live. Without this the in-app support chat will fail to bootstrap.
2. `cd waxxapp_admin/frontend && npm install --f && ./deploy.sh` so the admin panel gets `socket.io-client` and the new `/admin/supportInbox` route.
3. Upload `app-release.aab` (1.1.0+17) to Production. Same release-notes flow as the +15 launch — paste the English block above + auto-translate the rest.
4. Force-quit and relaunch the Flutter app once after install — the cold-start tap fix only takes effect on a fresh process launch.
5. Smoke test on the new build: kill the app, tap a `LIVE_STARTED` push from another seller's account, confirm the app opens directly into the live broadcast (NOT Home). Then tap "Help and Support" from the Profile menu, send a test message, confirm it appears in the admin Support Inbox in real time.

---
## 🚀 Version 1.1.0 — Production launch (promotion from Closed Testing)

**Version:** 1.1.0
**Build Number:** 15
**Release Date:** April 2026
**Type:** Production launch (Play Console: Production track)
**Note:** First public production release. Carries everything that has been validated through Closed Testing in v1.0.4 → v1.0.11. The minor version bump to **1.1.0** marks the public milestone — there are no new features in v1.1.0 over v1.0.11+14, just the production cut so the versionCode is fresh and the version name reflects "we're live."

### Suggested Play Console release name
`v1.1.0 — Production launch`

### English (Default)
*(Max 500 characters on Play Store — what users see in "What's New")*

```
🎉 Waxx App is here — v1.1.0

Live shopping, video reels, and auctions in one place.

🛍 Shop live with sellers in real-time
🎥 Discover products through short videos
💬 Chat in live shows + see who joined
❤️ Tap-to-cheer hearts during live streams
🚚 Per-option shipping (Local / Nationwide / International)
💳 Pay with Paystack (GHS, momo, card, bank transfer)
🌍 14+ languages
```

### 📋 What's bundled in this production cut

This is a *promotion* cut — no new code beyond v1.0.11+14, so the changelog is the running list of everything that landed during testing:

| Track | Versions | Highlights |
|---|---|---|
| Closed Testing kickoff | 1.0.0–1.0.3 | Initial release, Firebase Auth fix, dropdown crash fix, gallery picker null-safety |
| Whatnot-parity feature drop | 1.0.4 | Live tab + reel-style swipe between live shows, in-show auctions + auto-bid, combined shipping (bundles), Make-an-Offer, unified search, Wishlist top bar |
| Live reliability + Deep links | 1.0.5 | Heartbeat-based zombie sweep, deep links for `/short/<id>`, scheduled-shows empty state, reels card overflow fix |
| MoMo payouts + Live links + Promo codes | 1.0.6 | Mobile Money (MTN / Vodafone / AirtelTigo / Telecel Cash) replaces bank fields, `/live/<id>` deep links, mid-stream Add Product, multi-product reels + Shop pill, promo codes on listings, Auction/Offer UI removed |
| Live push routing + chat history | 1.0.7 | Live push tap opens broadcast directly, late joiners see chat history, share copies clean URL |
| Reels-style live feed + reel views | 1.0.8 | Vertical swipe between live shows, like/mute/share/report on the buyer-side live page, per-user reel view dedupe, 720p live broadcast, Country/Address on Profile |
| Paystack payments + onboarding refresh | 1.0.9 | Paystack (GHS) — card/momo/bank/USSD, server-side verify against tampering, delivery-scope picker on Pricing, refreshed onboarding art, host-side live like indicator, room-wide share count |
| Per-option shipping (Shape B) | 1.0.10 | Three optional delivery prices on Pricing, buyer cart picker, live "user joined" chat row, host-can-remove products mid-stream, reel share+view counts, seller sold/⭐/reviews, notification swipe-delete + Clear all, pending-review banner for sellers, per-viewer reel `isLike` |
| v1.0.10 hotfixes (this cut's working surface) | 1.0.11 | Live push deep-link cold-start replay, multi-tap likes (Whatnot/TikTok-Live style), chat replay for hosts, buyer Product Detail delivery-options pills, Listing Summary validator, Checkout picker reactivity, seller's own product detail delivery pills, live like/share host-room fallback, atomic JOIN dedupe, Paystack callback page + signed webhook + paymentReference plumbing, Paystack metaData crash fix |

#### 📁 Files Changed (relative to 1.0.11+14)

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.11+14` → `1.1.0+15`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.18.1` → `1.19.0`) |

No code changes — this entry exists solely to bump the versionCode so the production track can accept a fresh AAB.

### 🚀 Production launch checklist

> Review every box once before promoting. Most of these were already configured during Closed/Open Testing — this list is the cross-check, not new work.

#### Play Console — Production track
- [ ] **App release** → Production → Create new release → Upload `app-release.aab` (1.1.0+15)
- [ ] **Release name**: `v1.1.0 — Production launch` (internal label only)
- [ ] **What's new in this release**: paste the English block above; localize to as many of the 18 supported languages as you can (Spanish / French / Arabic / German / Turkish samples below). The Play Console's translation widget is fine for the rest.
- [ ] **Rollout %**: start at **20%** for the first 24-48h, watch the pre-launch report + crash dashboard, then ramp to 100%.

#### Play Console — Store listing (verify, not change)
- [ ] App name: `Waxxapp` (or your final brand)
- [ ] Short description (≤80 chars)
- [ ] Full description (≤4000 chars)
- [ ] App icon (512×512)
- [ ] Feature graphic (1024×500)
- [ ] Screenshots (8 max per device type — phone screenshots required, tablet/wear/etc. only if you target those form factors)

#### Play Console — Policy / declarations (one-time, must be Approved)
- [ ] **Privacy policy URL** populated and reachable
- [ ] **App content** → Target audience: Adults / 18+ (live commerce + payments)
- [ ] **App content** → Content rating: completed (likely PEGI 3 / IARC equivalent for shopping)
- [ ] **App content** → Data safety form: data collected = email, phone, name, address, payment info, photos; data shared with third parties = Firebase, Zego, Paystack, Stripe, Razorpay, Flutterwave; encryption in transit = Yes; deletion request flow = Yes
- [ ] **App content** → Ads: declare "No, my app does not contain ads" if true
- [ ] **App content** → Government apps: No
- [ ] **Financial features**: declare "Allows users to make payments" + "Money transfer" — link your Paystack/Razorpay/Stripe/Flutterwave merchant accounts as the payment provider
- [ ] **News apps**: No
- [ ] **Health apps**: No
- [ ] **Real-money gambling**: No (auctions are not gambling — but be ready to defend that distinction if Play asks)

#### Play Console — App access (test credentials)
- [ ] Provide a test phone number + OTP that bypasses real SMS, OR a demo-account toggle Google reviewers can flip on. Otherwise reviewers can't get past your Phone Auth signup.
- [ ] Note: the codebase has an `isDemoSeller` flag in `lib/utils/globle_veriables.dart` — if reviewers should land in a pre-populated state, document the demo entry path on the Tester Notes field.

#### Backend (`waxxapp_admin/backend`)
- [ ] `git pull` to HEAD on the production server
- [ ] `pm2 restart backend`
- [ ] Confirm `pm2 status` shows backend running, `pm2 logs backend --lines 50` is clean
- [ ] All v1.0.11 deploy items already applied: `productDetail` `deliveryOptions` projection, `liveLike`/`liveShare` host fallback, atomic JOIN dedupe + LiveSellingView unique index, Paystack callback + webhook + `paymentReference` field
- [ ] In Mongo, confirm the LiveSellingView unique index built without errors after the dedupe cleanup query
- [ ] Paystack dashboard (Live Mode → API Keys & Webhooks) — verify both URLs saved:
  - Callback: `https://www.waxxapp.com/payment/paystack/callback`
  - Webhook: `https://www.waxxapp.com/payment/paystack/webhook`
- [ ] Test webhook end-to-end: charge a small amount via the app, confirm Paystack dashboard shows the webhook delivered + the Order doc has `paymentStatus: 2`

#### Smoke test on the new AAB BEFORE submitting
- [ ] Phone OTP signup (real device, not emulator — reCAPTCHA must succeed via Play Integrity in release mode)
- [ ] Buy Now → Cart → Checkout → Paystack pay flow lands on the right Order with `paymentStatus: 2`
- [ ] Live push notification tap (cold + warm start) routes into the broadcast, not Home
- [ ] Live like spam — count climbs on both buyer and seller sides
- [ ] "<name> joined" appears once per buyer per live, even after rejoins
- [ ] Buyer Product Detail shows the per-scope shipping pill chips
- [ ] Cart picker tap re-renders selection + total
- [ ] Checkout picker tap does the same

### 🌍 Localized "What's New" text (v1.1.0)

**Spanish:**
```
🎉 ¡Waxx App está aquí — v1.1.0!

Compras en vivo, reels de video y subastas en un solo lugar.

🛍 Compra en directo con vendedores
🎥 Descubre productos en videos cortos
💬 Chatea en vivo y ve quién entró
❤️ Toca-para-vitorear corazones en vivo
🚚 Envío por zona (Local / Nacional / Internacional)
💳 Paga con Paystack (GHS, momo, tarjeta, banco)
🌍 14+ idiomas
```

**French:**
```
🎉 Waxx App est là — v1.1.0 !

Shopping en direct, reels vidéo et enchères en un seul endroit.

🛍 Achetez en direct avec les vendeurs
🎥 Découvrez les produits via de courtes vidéos
💬 Chattez pendant les lives + voyez qui a rejoint
❤️ Tap-pour-acclamer les cœurs en direct
🚚 Livraison par zone (Local / National / International)
💳 Payez via Paystack (GHS, momo, carte, banque)
🌍 14+ langues
```

**Arabic:**
```
🎉 Waxx App هنا — v1.1.0

التسوق المباشر، الريلز، والمزادات في مكان واحد.

🛍 تسوّق مباشرةً مع البائعين
🎥 اكتشف المنتجات عبر فيديوهات قصيرة
💬 دردش أثناء البث وشاهد من انضم
❤️ انقر-للتشجيع بالقلوب أثناء البث
🚚 الشحن حسب المنطقة (محلي / وطني / دولي)
💳 ادفع عبر Paystack (GHS، موبايل موني، بطاقة، بنك)
🌍 أكثر من 14 لغة
```

**German:**
```
🎉 Waxx App ist da — v1.1.0!

Live-Shopping, Video-Reels und Auktionen an einem Ort.

🛍 Kaufe live bei Verkäufern in Echtzeit
🎥 Entdecke Produkte über Kurzvideos
💬 Chatte in Live-Shows + sieh, wer beigetreten ist
❤️ Tap-to-cheer-Herzen während Live-Streams
🚚 Versand nach Zone (Lokal / National / International)
💳 Zahle mit Paystack (GHS, Mobile Money, Karte, Bank)
🌍 14+ Sprachen
```

**Turkish:**
```
🎉 Waxx App burada — v1.1.0!

Canlı alışveriş, video reels ve açık artırmalar tek yerde.

🛍 Satıcılarla canlı alışveriş yap
🎥 Kısa videolarla ürünleri keşfet
💬 Canlı yayında sohbet et + kimin katıldığını gör
❤️ Canlı yayında dokun-tezahürat kalpleri
🚚 Bölgeye göre kargo (Yerel / Ulusal / Uluslararası)
💳 Paystack ile öde (GHS, mobil para, kart, banka)
🌍 14+ dil
```

---
## 🔧 Version 1.0.11 — Live push deep-link reliability + multi-tap likes + chat replay + buyer-side delivery options

**Version:** 1.0.11
**Build Number:** 14
**Release Date:** April 2026
**Type:** Hotfix cluster — follow-ups to v1.0.10
**Note:** Bundles four bugs reported on top of v1.0.10+13. No new schema fields, no new endpoints — all four are scope/timing/projection fixes against the existing v1.0.10 surfaces.

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.0.11

📲 Live push tap reliably opens the broadcast (no more "network error")
❤️ Live likes are tap-to-cheer — every tap is +1 (Whatnot/TikTok-Live style)
💬 Live chat shows full history when you re-enter (host included)
🚚 Buyers see all delivery options on Product Detail before adding to cart
```

### 📋 Full Internal Release Notes (for your team)

#### 🐛 Bug fixes in v1.0.11

| Issue | Fix |
|---|---|
| Live push notification tap landed on Home with a "Couldn't open this live" snackbar | Even after v1.0.10's `registerInteractionHandlers`-before-`runApp` move, the post-frame `getInitialMessage` handler was racing splash hydration / Zego engine init / device-radio readiness on cold-start launches and the live-by-history GET fired into a half-up network stack. Restructured the cold-start tap path so it stashes the `liveSellingHistoryId` in `getStorage` as `pendingDeepLinkLiveId` and `SplashScreenController` replays it via `AppLinkService.openLive` AFTER landing on `/BottomTabBar` (or `/PageManage` for logged-out users). Network and GetX context are both ready by then. Also added a single retry to `FetchLiveByHistoryIdService` for residual transient errors. |
| Live like was capped at 1 per session — every tap toggled symmetric ±1 | v1.0.9 introduced symmetric ±1 likes; users hated that they couldn't keep cheering past the first tap (Whatnot / TikTok-Live let you spam taps). Reverted to multi-tap convention: every tap is +1, no toggle. Heart flips to filled red on first tap and stays filled. Backend `liveLike` handler is already append-only so no server change needed. |
| Live chat history wasn't shown to hosts re-entering their own broadcast | The `FetchLiveChatHistoryService.fetch` call in `live_view.dart` was gated on `!widget.isHost`, so the seller's own broadcast view always restarted with an empty chat panel. Removed the gate — both buyers and hosts now get the LiveChat replay on entry. |
| Buyers saw only the legacy `Delivery by Seller: <Type>` line on Product Detail, no per-scope prices | The buyer-side `productDetail` aggregation `$project` dropped both `deliveryType` and `deliveryOptions` so the Flutter side had no per-option data even though the seller's Pricing-page entries were stored correctly. Added both fields to the projection; Product Detail now renders a `Wrap` of outlined pill chips (`Local • GH₵X`, `Nationwide • GH₵Y`, `International • GH₵Z`) beneath the Sold/star row when `deliveryOptions` is non-empty. Falls back to the legacy single-line label for products that haven't been re-saved under Shape B. The actual per-item pick still happens on Cart where it gets persisted. |
| Listing Summary's Submit button rejected sellers with a "Listing Errors: Enter Shipping charge" dialog even when they'd filled the new Local / Nationwide / International prices | The validator was still checking `shippingChargeController.text.isEmpty` against the legacy single-shipping field that v1.0.10 hid from the UI. Sellers who only used the new Shape B inputs hit a hard block. Validator now passes when ANY of the three Shape B controllers OR the legacy one has a value, so new listings and edits on v1.0.9 products both submit cleanly. |
| The buyer's per-item delivery picker only existed on Cart, not Checkout — buyers who proceeded straight from "Add to cart" → Checkout couldn't switch options | Extracted the picker pills into a shared `DeliveryOptionsPicker` widget under `lib/custom/` and wired it into the Checkout's Order Info row, right below each line. Cart now imports the same widget. Hidden for legacy products with only `shippingCharges`. |
| Tapping a delivery pill on Checkout did nothing — backend updated, cart re-fetched, but the picker visually stayed on the old selection and the totals didn't recompute | The Order Info section was inside an `Obx` gated on the address controller's `isLoading` — totally unrelated to cart changes. The cart controller emits `update()` after a re-fetch but no `GetBuilder` was listening, so the picker froze. Wrapped the Order Info `ListView`, Sub Total row, Shipping charge row, and Total row in `GetBuilder<GetAllCartProductController>` so cart-controller `update()` calls actually re-render those sections. The picker pills themselves now subscribe to `updateLoading` via `Obx` so they re-enable taps after the re-fetch finishes. The Total row now also re-derives the live total from cart data on each rebuild instead of trusting the cached `createOrderByUserController.total` set in `initState`. |
| The seller's own product detail screen showed nothing about delivery options — sellers couldn't tell at a glance what buyers see | Mirrors the `Wrap` of outlined pill chips the buyer Product Detail uses, with the same legacy fallback to a "Delivery by Seller: <Type>" line. |
| Live like count climbed on the buyer's side but the seller's heart label stayed at 0 | The `liveLike` socket broadcast goes to `liveSellerRoom:<id>`, which only reaches the host if their socket actually joined that room via `liveRoomConnect`. That handler runs inside the Zego `loginRoom` callback and has a fragile room-leave loop. Added a defensive secondary broadcast to the seller's personal `liveRoom:<sellerUserId>` room (joined on socket-connect from the handshake query and never mutated). Same fallback added to `liveShare`. Buyer counts now sync to the host every time even if the seller-room handshake was flaky. |
| Live "<name> joined" chat row appeared multiple times when the same buyer rejoined the live | The `addView` JOIN dedupe used `findOne` then `new` then `save` — two back-to-back emits from the same buyer (LiveSwipeView mount/unmount, Zego reconnect, cold-start retries) raced past the lookup before either save flushed, both inserted, both fired the system message. Now uses an atomic `LiveSellingView.updateOne(filter, $setOnInsert, upsert:true)` and only emits JOIN when `upsertedCount > 0`. Reinforced by a new compound unique index on `(userId, liveSellingHistoryId)` so the duplicate-key bounce is server-side. Other users joining still broadcast cleanly to the whole room (host included). |
| Paystack dashboard required values for "Live Callback URL" + "Live Webhook URL" but the v1.0.9 integration only shipped a verify endpoint | Added `GET /payment/paystack/callback` (HTML landing page rendered when Paystack browser redirects post-checkout) and `POST /payment/paystack/webhook` (server-to-server signed events, HMAC-SHA512 verified against the admin's secret key). On `charge.success` the webhook looks up the matching Order by the new indexed `paymentReference` field and flips `paymentStatus` → 2 (paid). Idempotent — already-paid orders are no-ops. The Flutter side threads the Paystack reference through `PaystackService.pay()` → `handlePaymentSuccess` → `/order/create` so the webhook can find it. Closes the "user closed the app mid-checkout, paid Paystack but never got their order" failure mode — the webhook backstops the verify path. |
| Paystack checkout crashed on a "type 'List<Map<String, dynamic>>' is not a subtype of type 'String' of 'value'" cast error and dumped the user on a black "Initialize payment again" screen | The `paystack_for_flutter 1.0.4` SDK's metadata serializer/parser are mutually inconsistent — one branch expects `value` to be a String, the other expects a List<Map>. No payload shape satisfies both. We don't actually need metaData (the Paystack `reference` correlates to Waxxapp orders via the `paymentReference` field). Dropped the field — sample code in the package's own README also omits it. Black-screen crash gone. |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.10+13` → `1.0.11+14`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.18.0` → `1.18.1`) |
| Live push deep-link timing | `lib/services/push_notification_service.dart` (stash to getStorage on cold-start tap), `lib/Controller/GetxController/login/splash_screen_controller.dart` (`_replayPendingDeepLink` after Get.offAllNamed), `lib/ApiService/user/fetch_live_by_history_id_service.dart` (one-shot retry) |
| Multi-tap likes | `lib/seller_pages/live_page/controller/live_controller.dart` (`onToggleLiveLike` reverted to +1-only) |
| Chat replay for hosts | `lib/seller_pages/live_page/view/live_view.dart` (drop `!widget.isHost` gate) |
| Delivery options on Product Detail | `backend/server/product/product.controller.js` (`productDetail` `$project` adds `deliveryType` + `deliveryOptions`), `lib/View/MyApp/AppPages/product_detail.dart` (Wrap of pill chips) |
| Listing Summary submit validation | `lib/seller_pages/listing/controller/listing_controller.dart` (`validateRequiredFields` checks all 3 Shape B controllers + legacy fallback) |
| Delivery picker on Checkout (and shared widget) | `lib/custom/delivery_options_picker.dart` (new), `lib/View/MyApp/AppPages/cheak_out.dart` (Order Info ListView + Sub Total + Shipping charge + Total wrapped in `GetBuilder<GetAllCartProductController>`; pills wrapped in `Obx`), `lib/View/MyApp/AppPages/cart_page.dart` (uses shared widget) |
| Seller product detail delivery options pills | `lib/seller_pages/seller_product_details_page/seller_product_details_view.dart` (`Wrap` of pill chips beneath price row, legacy fallback) |
| Live counts host fallback | `backend/socket.js` (`liveLike` and `liveShare` handlers add a secondary broadcast to `liveRoom:<sellerUserId>`) |
| Live JOIN dedupe | `backend/socket.js` (`addView` handler uses atomic `LiveSellingView.updateOne` with `$setOnInsert`/`upsert`, only emits JOIN on real-insert), `backend/server/liveSellingView/liveSellingView.model.js` (compound unique index on `(userId, liveSellingHistoryId)` with partial filter) |
| Paystack callback + webhook + reference plumbing | `backend/server/payment/paystack.controller.js` (new `callback` HTML page + signed `webhook` handler), `backend/server/payment/paystack.route.js` (mounts both, `express.raw()` body for webhook), `backend/server/order/order.model.js` (new indexed `paymentReference` field), `backend/server/order/order.controller.js` (persists `req.body.paymentReference` at order create), `lib/PaymentMethod/paystack/paystack_service.dart` (`onVerified(reference)` callback shape; metaData removed), `lib/seller_pages/order_payment_page/controller/order_payment_controller.dart` (passes reference to `handlePaymentSuccess`), `lib/ApiService/user/create_order_by_user_service.dart` (`paymentReference` optional field) |

#### 🚀 Deploy checklist for v1.0.11

1. `git pull` in `waxxapp_admin/backend` and `pm2 restart backend` so all of the following are live: buyer-side `productDetail` `deliveryOptions` projection, `liveLike`/`liveShare` host fallback, atomic JOIN dedupe + `LiveSellingView` unique index, and the Paystack callback + webhook + `paymentReference` field.
2. Optional but recommended: clean up duplicate `LiveSellingView` rows so the new compound unique index can build:
   ```js
   db.livesellingviews.aggregate([
     { $sort: { createdAt: 1 } },
     { $group: { _id: { u: "$userId", l: "$liveSellingHistoryId" }, ids: { $push: "$_id" } } },
     { $match: { "ids.1": { $exists: true } } }
   ]).forEach(g => db.livesellingviews.deleteMany({ _id: { $in: g.ids.slice(1) } }));
   ```
3. In the Paystack dashboard (Live Mode → API Keys & Webhooks), paste:
   - Live Callback URL: `https://www.waxxapp.com/payment/paystack/callback`
   - Live Webhook URL: `https://www.waxxapp.com/payment/paystack/webhook`
   Then hit Save changes.
4. Force-quit and relaunch the Flutter app once after install — `getStorage` should now have the `pendingDeepLinkLiveId` plumbing wired in.

---
## 🚚 Version 1.0.10 — Per-option shipping (Shape B) + reel share/view counts + live host control + seller review visibility + pending-edit overlay

**Version:** 1.0.10
**Build Number:** 13
**Release Date:** April 2026
**Type:** Feature drop + UX cluster
**Note:** First cut on top of v1.0.9+12. Picks up Shape B per-option shipping (the natural follow-up to v1.0.9's single-pick scope), the live "user joined" chat row + push deep-link timing fix promised in the prior plan, plus a batch of seller-flow improvements that surfaced from on-device testing.

### English (Default)
*(Max 500 characters on Play Store)*

```
🚀 Update — v1.0.10

🚚 Sellers set 3 shipping prices (Local / Nat / Intl)
🛒 Buyers pick the option per item on Cart/Checkout
👋 "<user> joined" chat row on live shows
📲 Live push tap now opens broadcast (not Home)
🛍 Hosts can remove products mid-stream
🎬 Reel share + view counts displayed
⭐ Sellers see Sold + ⭐ rating on their products
🗑 Notifications: swipe to delete + Clear all
🔔 Pending-review banner shows your edits
❤️ Seller-profile reels remember your like
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New features in v1.0.10

**Per-option shipping (Shape B)**
- v1.0.9 shipped the single-pick delivery-scope dropdown. v1.0.10 evolves it: sellers fill in **three optional prices** on the Pricing page (Local / Nationwide / International) instead of one. Any combination can be left blank. The Listing Summary now renders one row per filled scope so the seller's review reflects what they entered.
- New `Product.deliveryOptions: [{ type, price }]` array on the backend, mirrored on `ProductRequest` so admin-approval edits carry the value. Legacy products with only `shippingCharges` + `deliveryType` keep working — the cart resolves their single virtual option through a new `resolveCartShipping` helper.
- New `Cart.items.chosenDeliveryType` per-line field; cart picker on **Cart / Checkout** lets buyers flip between offered options per item, with the snapshot price (`purchasedTimeShippingCharges`) re-resolved on the backend so the line total stays self-contained even if the seller later edits.
- `cart/updateDeliveryOption` endpoint applies the buyer's pick atomically; the picker is hidden when only one option is offered (auto-selected), and legacy products keep their single charge with no UI change.
- `_syncLegacyShippingFromOptions()` runs immediately before `listItem` / `editListItem` submit so the legacy `shippingCharges` + `deliveryType` fields stay in sync with the first filled option — fixes a regression where the prefilled stale value was being re-sent and the next product detail render showed the pre-edit shipping price.

**Live "user joined" chat row**
- New `JOIN` system message type for the in-broadcast chat. When a buyer enters a live the host (and every viewer) sees a styled `JOINED` chip + "<name> joined" within ~1 second, matching the Whatnot / TikTok-Live convention. Persisted in `LiveChat` so a third late-joiner sees the JOIN line in the chat-history replay.
- Per-session dedupe: emits only on first entry to the room, not on Zego reconnects or tab refreshes — gated on the `LiveSellingView` upserted-vs-found flag so a flaky network doesn't spam the chat.
- Reuses `LiveSystemMessage._style` switch on the Flutter side; new JOIN case renders with a login icon + the same primary color as FOLLOW.

**Live push tap routes to the broadcast (deep-link timing fix)**
- The handler that converts a tapped `LIVE_STARTED` push into a deep-link nav was registered inside `SplashScreenController.onInit` — i.e. only after storage hydration and only on the splash route. Cold-start from a tapped notification could race past it and `getInitialMessage()` was consumed before the handler was armed, so the app fell through to the Home redirect.
- Moved `PushNotificationService.instance.registerInteractionHandlers()` into `main()` immediately after `Firebase.initializeApp(...)` — handler is globally armed before `runApp()` is called regardless of login state. Dropped the duplicate splash call. Cold-start cold-start handler defers via `WidgetsBinding.addPostFrameCallback` so `Get.dialog` has a live MaterialApp/GetX context to land on.
- Logged-out cold-start path: `AppLinkService.openLive()` already accepts the unauthed case, so an account-less viewer lands on `LiveSwipeView` and can watch (chat / like gated by the existing live-page logic).

**Live host can remove products mid-stream**
- The host-only "Available Products" sheet now shows a small trash icon on every row. Tap → confirmation dialog → row disappears + the live's product list updates room-wide via the existing `selectedProductsUpdated` socket broadcast. Pairs the v1.0.6 "+ Add product" path so a host can fully curate the storefront mid-broadcast without ending the show.
- New `POST /liveSeller/removeProductFromLive` endpoint mirrors `addProductToLive`: pulls the product from `LiveSeller.selectedProducts`, returns the updated list, broadcasts to the room.

**Reel view + share counts on the seller-profile FullScreenReelView**
- v1.0.8 added per-user view dedupe + a view counter on the home Shorts rail. v1.0.10 surfaces both view and share totals on the **seller-profile** reel viewer too, where they were missing entirely.
- New `Reel.share` field on the backend with a `POST /reel/incrementShare/:reelId` endpoint (no per-user dedupe — every share counts, mirroring the live `shareCount` pattern). Both the home Shorts viewer and the seller-profile FullScreenReelView bump it on share-tap with optimistic local +1 reconciled to the server's authoritative count.
- View-bump now fires on the seller-profile path too (same `ReelViewService.incrementView` the home rail uses) so the counter ticks for views from any surface.

**Sellers see Sold + ⭐ rating on their own product details**
- The buyer-side product-detail row showing `Sold count + ⭐ + No Reviews / X.X (N)` is now rendered on `SellerProductDetailsView` too, just under the address line. Reuses the same `product.sold` and the new rating aggregation. Tapping the star opens the existing `ProductReviews` page (the buyer-side reviews list, reused) so sellers can read review text.
- `detailforSeller` runs the same `Rating $group` aggregation `productDetail` uses (`avgRating + totalUser`) and stitches the result onto each returned product.

**Notifications: swipe to delete + Clear all**
- `Dismissible` swipe-to-delete on every notification row + a trailing trash IconButton + an AppBar "Clear all" TextButton with a confirm dialog.
- Optimistic UI: rows disappear immediately and restore on backend failure. New endpoints `DELETE /notification/:id` (single) and `DELETE /notification/clearAll?userId=...` (bulk).

**Pending-review overlay on the seller's own detail/summary**
- When a seller edits a product, the change goes through admin review (`productRequest/updateProductRequest`). Until the admin accepts, the live `Product` is unchanged — sellers were re-opening their own detail page after submit and seeing the pre-edit values, concluding the edit had silently failed.
- `detailforSeller` now looks up the latest pending `ProductRequest` for the product and **overlays its writable fields** (delivery options/prices, promo codes, attributes, images, pricing, auction settings) onto the response. New `hasPendingReview: true` flag drives a yellow hourglass "Your product is in pending mode" banner at the top of both `SellerProductDetailsView` and `ListingSummary`.
- Buyers still hit `productDetail` (no overlay) — they keep seeing the live approved product until the admin accepts.

**Per-viewer `isLike` on seller-profile reels**
- Both the seller-profile reels grid + FullScreenReelView always rendered the heart icon as unliked because `reelsOfSeller` returned the raw Reel doc with no `likehistoryofreels` join. The same user could like a reel from the home Shorts feed and see it unliked from the profile path.
- Backend `reelsOfSeller` now mirrors `getReelsForUser`: a `$lookup` against `likehistoryofreels` gated on the new `userId` query param + an `addFields` stage that surfaces `isLike` and a default 0 for `view`/`share`. Anonymous viewers (no `userId`) skip the lookup and always see `false`.
- Flutter threads `loginUserId` through the `fetchSellerReels` call, the `Reel` class gains mutable `isLike` + `like`, and `FullScreenReelView` seeds the heart from `reel.isLike` plus persists the optimistic toggle back onto the reel object so swipes don't lose the state. Also fixed a latent bug where `onClickLike` was hitting the API with `initialIndex` instead of the currently-visible reel.

#### 🛠 UX / polish in v1.0.10

**Live shop icon survives an empty product list**
- Hosts who removed every product from a live (v1.0.10's new flow) lost the shop icon entirely (`liveSelectedProducts.isNotEmpty` gate), so they had no way to add anything back. Hosts now always see the shop button; with an empty list it renders an `add_shopping_cart` placeholder icon instead of the first product's image. Viewers still only see the icon when there's something to shop.

**Listing Summary shipping rows match Shape B input**
- The Pricing card on the Listing Summary was hard-coded to the legacy `shippingChargeController.text` — sellers' three Shape B inputs were invisible there, so the summary either showed nothing or only the legacy single value. Now renders one row per filled scope (Local / Nationwide / International), falling back to the legacy single row only for products that haven't been re-saved under Shape B.

#### 🐛 Bug fixes in v1.0.10

| Issue | Fix |
|---|---|
| After editing delivery prices, re-opening the seller product detail showed the pre-edit shipping value | `editListItem()` was sending the prefilled stale `shippingChargeController.text` alongside the new `deliveryOptions[]`. Added `_syncLegacyShippingFromOptions()` which back-fills `shippingCharges` + `deliveryType` from the first filled option before submit, mirroring the v1.0.10 plan's "first non-zero option" rule. Wired into both `listItem` + `editListItem`. Pairs with the new pending-review overlay so the seller sees their submitted values immediately even before admin approval. |
| Live page: after a host removed all products, the shop icon disappeared and they couldn't add new ones | `liveSelectedProducts.isNotEmpty` gate was blocking the host. Hosts now always see the shop icon (with a placeholder when empty); viewers retain the existing visibility. |
| Listing Summary didn't show per-option shipping under Shape B | Pricing widget on the summary only read `shippingChargeController`. Now iterates the three Shape B controllers and renders one row per filled scope. |
| Tapping a reel from a seller profile showed the heart unliked even after the same user had already liked it from home Shorts | `reelsOfSeller` had no `likehistoryofreels` join. Backend `$lookup` added; Flutter passes the viewer's `userId`; `Reel` model gains `isLike`; `FullScreenReelView` seeds from + persists into the reel object. |
| `onClickLike` from the seller-profile FullScreenReelView fired the like API for the wrong reel after vertical swipes | Was indexing on `widget.initialIndex`. Now reads the current visible page via `_currentIndex`. |
| Sellers re-opened their own product detail after Edit Item and saw pre-edit values, concluding the edit had silently failed | `detailforSeller` now overlays the latest pending `ProductRequest` fields onto the response and surfaces a `hasPendingReview` flag. UI shows a "Pending review" banner so the workflow is transparent. |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.9+12` → `1.0.10+13`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.17.0` → `1.18.0`) |
| Shape B — Backend | `backend/server/product/{product.model.js,product.controller.js}`, `backend/server/productRequest/{productRequest.model.js,productRequest.controller.js}`, `backend/server/cart/{cart.model.js,cart.controller.js,cart.route.js}`, `backend/server/order/{order.model.js,order.controller.js}`, `backend/util/resolveCartShipping.js` (new) |
| Shape B — Flutter | `lib/seller_pages/listing/{view/pricing_screen,widget/pricing_widget,view/listing_summary,controller/listing_controller}.dart`, `lib/View/MyApp/AppPages/{cheak_out,cart_page,product_detail}.dart`, `lib/View/MyApp/Profile/MyOrder/user_order_details.dart`, `lib/utils/utils.dart` (`_localizeDeliveryType` promoted), `lib/ApiModel/common/delivery_option.dart` (new), 16 product-shaped models in `lib/ApiModel/{seller,user}/`, `lib/ApiService/seller/{add_product_service,product_edit_service}.dart`, `lib/utils/api_url.dart` |
| Live JOIN row | `backend/socket.js` (addView handler), `lib/custom/live_system_message.dart` |
| Push deep-link timing | `lib/main.dart` (registerInteractionHandlers before runApp), `lib/Controller/GetxController/login/splash_screen_controller.dart` (drop duplicate call), `lib/services/push_notification_service.dart` (post-frame defer) |
| Live host remove product | `backend/server/liveSeller/{liveSeller.controller.js,liveSeller.route.js}`, `backend/socket.js`, `lib/seller_pages/live_page/bottom_sheet/product_list_bottom_sheet_ui.dart`, `lib/seller_pages/live_page/controller/live_controller.dart`, `lib/utils/api_url.dart` |
| Live shop icon empty-state | `lib/seller_pages/live_page/widget/live_widget.dart` |
| Reel share + view counts | `backend/server/reel/{reel.model.js,reel.controller.js,reel.route.js}`, `lib/ApiModel/seller/{SellerReelsModel.dart,GetReelsForUserModel.dart}`, `lib/ApiService/user/reel_share_service.dart` (new), `lib/utils/api_url.dart`, `lib/View/MyApp/AppPages/reels_page/widget/reels_widget.dart`, `lib/user_pages/preview_seller_profile_page/widget/store_product_widget.dart` |
| Seller sees rating + reviews | `backend/server/product/product.controller.js` (detailforSeller rating aggregation), `lib/ApiModel/seller/SellerProductDetailsModel.dart` (new Rating class), `lib/seller_pages/seller_product_details_page/seller_product_details_view.dart` |
| Notifications delete | `backend/server/notification/{notification.controller.js,notification.route.js}`, `lib/Controller/GetxController/user/user_all_notification_controller.dart`, `lib/View/MyApp/AppPages/notification.dart`, `lib/utils/api_url.dart` |
| Pending-review overlay | `backend/server/product/product.controller.js` (detailforSeller overlay + hasPendingReview), `lib/ApiModel/seller/SellerProductDetailsModel.dart`, `lib/seller_pages/seller_product_details_page/seller_product_details_view.dart`, `lib/seller_pages/listing/view/listing_summary.dart` |
| Per-viewer reel isLike | `backend/server/reel/reel.controller.js` (reelsOfSeller $lookup), `lib/ApiModel/seller/SellerReelsModel.dart`, `lib/user_pages/preview_seller_profile_page/api/fetch_seller_profile_api.dart`, `lib/user_pages/preview_seller_profile_page/widget/store_product_widget.dart` |

#### 🚀 Deploy checklist for v1.0.10

1. `git pull` in `waxxapp_admin/backend` and `pm2 restart backend` so all the new endpoints are live: Shape B `cart/updateDeliveryOption`, `liveSeller/removeProductFromLive`, `reel/incrementShare/:reelId`, `notification/:id` (DELETE), `notification/clearAll`, plus the schema additions and the per-viewer `isLike` / pending-review overlay reads.
2. Optional Mongo backfill for new fields — Mongoose's `default` covers new docs but won't touch existing ones until they're next saved. Either skip (legacy docs render correctly without migration) or run on the server's Mongo:
   ```js
   db.products.updateMany({ deliveryOptions: { $exists: false } }, { $set: { deliveryOptions: [] } })
   db.reels.updateMany({ share: { $exists: false } }, { $set: { share: 0 } })
   ```
3. Force-quit and relaunch the Flutter app so the freshly registered push interaction handler arms before `runApp` (the deep-link timing fix only applies to the new build).

---
## 💳 Version 1.0.9 — Paystack payments (GHS) + Delivery scope picker + onboarding refresh + live polish

**Version:** 1.0.9
**Build Number:** 12
**Release Date:** April 2026
**Type:** Major feature drop + bug-fix cluster
**Note:** This entry covers the full v1.0.9+12 build that promotes from Closed Testing to Open Testing. The same versionCode carries the originally-planned v1.0.9 features (Paystack + live page polish) plus the post-cut additions originally tracked as v1.0.10 (delivery scope picker, onboarding refresh, follow-pill polish, per-viewer isFollow fix).

### English (Default)
*(Max 500 characters on Play Store)*

```
🔥 Update — v1.0.9

💳 Paystack added — pay in GHS (card, momo, bank)
🚚 Sellers tag delivery scope on listings
   (Local / Nationwide / International)
🛍 Buyers see delivery scope on product detail
🎨 Refreshed onboarding slides + welcome copy
❤️ Live like now ± symmetric, host sees count too
🔄 Live share count synced room-wide
👥 Follow / Following pill polish across the app
🛒 Cart minus no longer kicks you to Reels
📦 Order Details: buyer phone shown
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New features in v1.0.9

**Paystack payment gateway (Ghana Cedi)**
- New fourth gateway tile on the order Payment screen — wires the official `paystack_for_flutter` SDK over a transparent in-app webview that hosts Paystack's standard checkout (card, mobile money, bank transfer, USSD) at `Currency.GHS`.
- The success popup is **never** trusted on its own. New `PaystackService.pay(...)` calls the new backend `POST /payment/paystack/verify` route, which hits Paystack's `GET /transaction/verify/:reference` with the admin-configured secret key and confirms `status === "success"` AND that the settled amount matches the client's `expectedAmount` (defends against amount tampering). Only if the backend says verified does the order get credited.
- Settings flag + public/secret key plumbed end-to-end: new `paystackSwitch`, `paystackPublicKey`, `paystackSecretKey` on the Setting Mongoose model + setting controller (update + handleSwitch); matching toggle and key inputs in the admin React panel's Payment Settings page; Flutter splash + bottom-bar controllers seed `isShowPaystackPaymentMethod` / `paystackPublicKey` / `paystackSecretKey` from the settings response so the tile only shows when the admin has flipped it on.
- Paystack icon ships as `assets/icons/paystack.svg` (icon-only stacked-bars mark, wordmark stripped) rendered via the new `flutter_svg` dep. `PaymentItemUi` now picks `SvgPicture.asset` for `.svg` paths and falls back to `Image.asset` for the existing PNG tiles, so Razorpay/Stripe/FlutterWave/COD render unchanged.

**Delivery scope picker on the seller's Pricing page**
- New CoolDropdown above the existing `Shipping charge` field on the listing wizard's Pricing screen with three options: **Local delivery / Nationwide delivery / International**. Optional — legacy products without a value behave exactly as before.
- The seller-facing label and three options localized across all 18 language files.
- New `Product.deliveryType` Mongo enum field (`local | nationwide | international | null`). `ProductRequest` mirrors it so seller edits going through admin approval carry the value through to the live Product on accept. The aggregations on `getliveSellerList`, `getLiveByHistoryId`, search, and product detail flow it through without explicit projection changes.
- Buyers see the chosen scope as a small **"Delivery by Seller: <Type>"** label under the price/header on Product Detail. Hidden when the seller skipped the picker so legacy products show nothing extra.
- Edit-mode hydration: opening Pricing for an existing listing seeds the dropdown with the saved value so the seller doesn't lose their previous choice.

**Refreshed onboarding carousel**
- New 3-slide intro art replaces the older fashion-themed illustrations:
  1. **Shopping Made Easy** — branded welcome (cyan stacked-bars logo + everyday devices)
  2. **Buy Like A Pro** — buyer pitch (deal-finder, discount badges)
  3. **Sell Like A Pro** — seller pitch (live-sales, money-in-hand)
- Source art is 1024 × 1536 RGB, center-cropped to the existing 0.7004 aspect, then Lanczos-resized to the original 512 × 731 RGBA PNG so the asset registration in `pubspec.yaml` stays unchanged.
- New welcome / buyer / seller copy below each slide, freshly localized across all 18 language files. The fashion-themed `MAKE IT FASHIONABLE / SHOP THE MODERN ESSENTIALS / NEW CLOTHS NEW PASSION` copy and its 17 translations are gone.

**Host-side live like indicator**
- Display-only filled heart on the seller's right-column action stack with the running like total. Surfaces the same `liveLikeCount` socket broadcast every viewer sees so the host knows the room is reacting. Tap is a no-op toast since a seller can't like their own broadcast.

**Live share count synced room-wide**
- New `LiveSellingHistory.shareCount` field, `liveShare` socket handler that `$inc`s it and rebroadcasts the new total to the room as a `liveLikeCount`-style `liveShareCount` event. Both the host and every viewer's Share button label is now the running room total instead of the static "Share" string. Seeded on entry from `getLiveByHistoryId`'s response so deep-link joiners see the count immediately instead of "0".

**Per-viewer follow flag on live**
- New `LiveSeller.isFollow` field projected by the live-list (`getliveSellerList`), deep-link (`getLiveByHistoryId`) and **socket** (`fetchLiveBroadcastDetails`) backends — gated on the requesting viewer's `userId` so the FollowPill renders in its real state instead of always defaulting to "Follow". The Flutter live page seeds `LiveController.isFollow` from the model on entry and now also syncs it from the socket-fetch response, then fires a bare `update()` so the unkeyed GetBuilder around the FollowPill rebuilds. `FollowPill.didUpdateWidget` mirrors the prop change into local state so it doesn't fight an in-flight tap.

#### 🛠 UX / polish in v1.0.9

**Live viewer-count pill restyled**
- Replaced the translucent-white `BlurryContainer` views badge with a solid `LinearGradient` pill (`#6B21A8` → `#EC4899`) so the count reads against any backdrop. Same height, radius, eye + count + red Live capsule layout — only the background changes.

**Product Detail "About this seller" row**
- Follow / Following pill colors **inverted** to match the convention used elsewhere in the app: `Following` is filled primary (yellow) with black text — signaling "active relationship"; `Follow` is transparent with a primary-color border + primary-color text — the outline invites the tap. Mirrors the seller-profile preview pill at `preview_seller_profile_view.dart:265-277`.
- Seller name now resolves through `businessName → firstName + lastName → St.seller.tr`. Sellers who signed up without filling their store profile no longer render a blank line where the name should be — used to render literally `"null"` from the unconditional `"${... ?.seller?.businessName}"` interpolation.

**Seller Profile preview header height**
- 8 px `RenderFlex overflowed` on the SliverAppBar bottom (Products tab) — the budget was bumped 114 → 140 in v1.0.8 to fit `TabBar` + `CategoryTabsWidget`, but in some locales / font-scaling combos the natural Column was actually 148. Bumped to 150 with a small cushion. The other-tabs budget (78) is unchanged.

**Pending Order Detail (seller view)**
- Buyer phone number now renders inside the Location card under the address (uses `Icons.phone` + the `mobileNumber` prop already plumbed from `pending_orders.dart`). Removed the dead commented-out variant.

**Cart minus no longer bounces to Reels**
- `RemoveProductToCartController` was force-switching the bottom bar to index 2 after a successful remove. That was Cart back when the bar had four items, but Live got inserted at index 1 and index 2 became Reels — every minus tap kicked users out to Reels. Dropped the tab-switch entirely (the cart already refreshes itself).

**Confirm Order (seller view) cleanup**
- Removed the *Delivery by* dropdown, *Tracking Id* and *Tracking Link* text fields per product direction; also dropped the Submit-time validation that previously gated the API call on those fields being non-empty (Submit was a no-op once the inputs were hidden).

#### 🐛 Bug fixes in v1.0.9

| Issue | Fix |
|---|---|
| Live "+ Add" pill visible to viewers despite the `isHost` guard | Tightened the gate so the Add pill also requires `Database.sellerId == logic.sellerId` (i.e., the logged-in user is actually the seller of *this* stream) — bulletproof regardless of how `isHost` is plumbed downstream. |
| Live heart icon didn't flip on each tap | The `Obx` wrapping the heart read `controller.isLiveLiked` as a plain `bool`, so Obx never subscribed to it; the id-tagged `update(["onToggleLiveLike"])` reached no GetBuilder. Made `isLiveLiked` a `RxBool` and dropped the dead update call. Heart now flips on every tap. |
| Live like was append-only — unlike silently flipped the heart with no count change | Toggle is now symmetric ±1: unlike branch optimistically decrements the local count (clamped at 0) and emits a new `liveUnlike` socket event; matching backend handler `$inc`s `LiveSellingHistory.likeCount` by −1 with a `likeCount > 0` guard so a stray double-unlike can't pull it negative. |
| Live FollowPill stayed on "+ Follow" even when the viewer was already following the seller (e.g. followed from Reels) | The live page refreshes state on entry through the `fetchLiveBroadcastDetails` **socket** call (not the HTTP endpoints), but that handler returned the raw LiveSeller doc with no follower lookup. Now the Flutter payload includes the viewer's `userId` and `handleLiveUserInfoResponse` syncs `isFollow` from the response into the controller and fires a bare `update()` so the unkeyed GetBuilder around the FollowPill rebuilds. Backend handler reads `userId`, looks up `Follower(userId, liveUserInfo.sellerId)`, and adds `isFollow` to the response. |
| "Following" status disagreed between Product Detail and Seller Profile pages for the same seller | `getProductDetails` aggregation's `$lookup` for `isFollow` joined the followers collection on `sellerId` only — no `userId` filter — so it returned `true` whenever **any** user followed the seller. Every buyer saw "Following" on a popular seller's product. Now filters on both `sellerId` AND the requesting `user._id` with `$limit: 1`, agreeing with how the seller-profile fetch already projects it. The followerCount sibling lookup is unchanged (correctly room-wide). |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.8+11` → `1.0.9+12`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.15.0` → `1.17.0`) |
| Paystack — Flutter | `lib/PaymentMethod/paystack/paystack_service.dart` (new), `lib/seller_pages/order_payment_page/{view/order_payment_view.dart,controller/order_payment_controller.dart}`, `lib/ApiModel/login/SettingApiModel.dart`, `lib/Controller/GetxController/login/splash_screen_controller.dart`, `lib/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart`, `lib/utils/{globle_veriables.dart,api_url.dart,app_asset.dart}`, `assets/icons/paystack.svg` (new), `pubspec.yaml` (+ `paystack_for_flutter`, `flutter_svg`) |
| Paystack — Backend | `backend/server/payment/{paystack.controller.js,paystack.route.js}` (new), `backend/server/setting/{setting.model.js,setting.controller.js}`, `backend/route.js`, `backend/setting.example.js` |
| Paystack — Admin panel | `waxxapp_admin/frontend/src/Component/Table/setting/paymentSetting.js`, `waxxapp_admin/frontend/src/Component/extra/infoContent.js` |
| Delivery picker — Flutter | `lib/seller_pages/listing/view/pricing_screen.dart`, `lib/seller_pages/listing/controller/listing_controller.dart`, `lib/utils/Strings/strings.dart`, `lib/localization/language/*_language.dart` (all 18 — 5 new keys), `lib/ApiService/seller/{add_product_service.dart,product_edit_service.dart}`, plus `deliveryType: String?` on 16 product-shaped models in `lib/ApiModel/{seller,user}/` |
| Delivery picker — buyer-side display | `lib/View/MyApp/AppPages/product_detail.dart` (`_localizeDeliveryType`, label render under price) |
| Delivery picker — Backend | `backend/server/product/product.model.js`, `backend/server/productRequest/productRequest.model.js`, `backend/server/product/product.controller.js` (`createProduct`, `createProductByAdmin`, `updateProduct`), `backend/server/productRequest/productRequest.controller.js` (`updateProductRequest` × 2 branches, `acceptUpdateRequest`) |
| Onboarding art | `assets/Entry_image/{fst,snd,trd}.png` (replaced) |
| Onboarding copy | `lib/localization/language/*_language.dart` (all 18) |
| Live page | `lib/seller_pages/live_page/widget/live_widget.dart`, `lib/seller_pages/live_page/controller/live_controller.dart`, `lib/seller_pages/live_page/view/live_view.dart`, `lib/seller_pages/live_page/bottom_sheet/product_list_bottom_sheet_ui.dart`, `lib/custom/follow_pill.dart`, `lib/utils/socket_services.dart`, `lib/ApiModel/user/GetLiveSellerListModel.dart`, `lib/ApiService/user/fetch_live_by_history_id_service.dart` |
| Live socket / endpoints — Backend | `backend/socket.js`, `backend/server/liveSeller/liveSeller.controller.js`, `backend/server/liveSellingHistory/liveSellingHistory.model.js` |
| Product Detail polish | `lib/View/MyApp/AppPages/product_detail.dart` (Follow pill color triple, `_resolveSellerName` helper) |
| Seller profile header | `lib/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart` (`PreferredSize.fromHeight` 140 → 150 on Products tab) |
| Per-viewer isFollow fix — Backend | `backend/server/product/product.controller.js` (product-detail `isFollow` lookup pipeline) |
| Order screens | `lib/View/MyApp/Seller/SellerOrder/PendingOrder/pending_order_proceed.dart`, `lib/View/MyApp/Seller/SellerOrder/ConfirmedOrders/order_confirm_by_seller.dart` |
| Cart | `lib/Controller/GetxController/user/remove_product_to_cart_controller.dart` |

#### 🚀 Deploy checklist for v1.0.9

1. `pm2 restart waxxapp` after pulling the matching `waxxapp_admin` HEAD so all of the following are live: `/payment/paystack/verify`, the `paystack*` settings fields, the `liveUnlike` socket handler, the `fetchLiveBroadcastDetails`-with-`isFollow` change, the new `Product.deliveryType` field + matching ProductRequest mirror, and the per-viewer-`isFollow` fix on `getProductDetails`.
2. Re-deploy the admin React build (`cd waxxapp_admin/frontend && ./deploy.sh`) so the Paystack box appears in the Payment Settings page.
3. Backfill existing Mongo Setting docs so the new `paystack*` fields exist — easiest path is to open Payment Settings in the admin panel and click Submit (Mongoose materializes the new fields with their defaults). Alternatively `db.settings.updateMany({}, { $set: { paystackSwitch: false, paystackPublicKey: "", paystackSecretKey: "" } })`.
4. Optional: backfill existing Product docs to materialize the new `deliveryType` field (Mongoose's `default: null` covers it for new docs but won't touch existing ones until they're next saved). Either skip — buyer side simply doesn't render the label for legacy products — or run on the server's Mongo:
   ```js
   db.products.updateMany({ deliveryType: { $exists: false } }, { $set: { deliveryType: null } })
   ```
5. In the admin panel, paste your Paystack `pk_test_…` + `sk_test_…` keys (Paystack dashboard → Settings → API Keys & Webhooks) and flip the Paystack toggle on.
6. Force-quit and relaunch the Flutter app so it re-fetches `/setting`. The Paystack tile should appear on the order Payment screen, and the new "Delivery by Seller" picker should be visible above the "Shipping charge" input on the Pricing page of the listing wizard.

---
## 📲 Version 1.0.8 — Reels-style live feed, like/report on live, faster reels, profile country & address

**Version:** 1.0.8
**Build Number:** 11
**Release Date:** April 2026
**Type:** Feature drop + UX/perf

### English (Default)
*(Max 500 characters on Play Store)*

```
🔥 Update — v1.0.8

📺 Swipe up/down between live shows — Reels-style
❤️ Like, mute, share, report on the buyer-side live page
👁 Per-user view count on Shorts (no more inflated counts)
⚡ Reels load fast — cached feed + thumbnail-first paint
🎥 720p live broadcast — sharper picture for viewers
🌍 Country & Address now editable in your Profile
✨ Cleaner Live top bar, working Mute/Flip on host side
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New features in v1.0.8

**Reels-style vertical swipe between live shows**
- New `LiveSwipeView` wraps a vertical `PreloadPageView` (`preloadPagesCount: 0`) over the buyer-side `LivePageView`. Only the **settled** index renders a real `LivePageView`; pages above and below render a cheap `_LivePeekTile` placeholder so the swipe animation feels right but we never have two Zego rooms logged in at once. The settle triggers full dispose+init of the active page; the existing defensive `await logoutRoom(roomID)` covers the brief overlap.
- All six entry points (`live_now_chip`, `home_live_grid`, `home_live_products_rail`, `unified_search_view`, `home_page_divided`, `app_link_service`) now route through `LiveSwipeView`. A new `LiveSwipeResolver` helper pulls the current peer list from `GetLiveSellerListController` or falls back to a single-item feed when the tapped show isn't in the cached list. `app_link_service.dart` also kicks `getSellerList()` if the list is empty so deep-link viewers get a populated swipe feed.
- Pagination via `GetLiveSellerListController.loadMoreData()` triggers when the settled index is within 2 of list end.
- Route name `'/LivePage'` preserved so the existing replace-vs-stack logic in `AppLinkService` still works.

**Live page right-column action buttons (Whatnot / Reels parity)**
- Buyer column: **Like** (server-tracked count broadcast room-wide via socket `liveLike` event), **Sound Mute** (Zego `mutePlayStreamAudio` against the remote stream so this viewer can watch silently), **Share**, **Report** (new bottom sheet, reuses the existing `reportReason` collection via a new `reportoLive` backend collection + `POST /reportToLive/reportLive` endpoint, FCM confirmation back to the reporter).
- Host column: **Flip Camera**, **Mic Mute**, **Share**. Reuses existing `LiveController.onSwitchCamera` / `onSwitchMic`.
- Live like count is persisted server-side on `LiveSellingHistory.likeCount`. The socket `liveLike` handler `$inc`s the count atomically and broadcasts the new total to the room (`liveLikeCount` event). New joiners get the running total seeded by the `addView` handler so late entrants don't see a stale "0".
- `getLiveByHistoryId` aggregation joins `liveHistory.likeCount` so the deep-link path also seeds the count via the HTTP response.

**Per-user reel view count**
- New `Reel.view` field; `getReelsForUser` projects it. Home-page Shorts rail tiles now render a "👁 1.2K" badge (formatted via the same `CustomFormatNumber.convert` the Live top bar uses).
- New `ViewHistoryOfReel` collection with a compound unique index on `(userId, reelId)`; `POST /reel/incrementView/:reelId` only `$inc`s `Reel.view` when the insert actually creates a row, so a repeat view by the same user is a silent no-op. Response includes `counted` so the Flutter optimistic local +1 stays in sync with backend reality.
- One-shot `scripts/migrate_reel_view_reset.js` zeroes existing counts and clears any prior history rows so the dedupe baseline is clean. Run once after deploy.

**Profile country & address**
- User schema gains `country` + `address`. The user-update endpoint accepts both with the same preserve-on-empty fallback as `location`. Edit-Profile page surfaces them as two new read-only field rows under Email — Country opens `showCountryPicker`, Address opens a single-field bottom sheet. Persisted in `getStorage` and seeded on login + splash.

**Localization**
- Added `St.following` ("Following") to all 18 language files; the seller profile + product detail + Reels follow pill all now use it consistently for the "currently following" state.

#### 🛠 UX / perf in v1.0.8

**Reels load speed**
- `PreloadPageView.preloadPagesCount` 4 → 1; was spawning 5 concurrent `VideoPlayerController.networkUrl` downloads on cold start. `FetchReelsApi.limitPagination` 20 → 5 so the initial fetch lands faster.
- Warm-cache: `ReelsController.init` no longer clears + refetches on every tab visit; if `mainReels` is non-empty (from a prior visit), the feed renders instantly and we silently refresh the first page in the background.
- Thumbnail-during-init: while `videoPlayerController.initialize()` runs, the page renders the reel's `thumbnail` full-screen + a small spinner instead of a generic shimmer. Perceived load is instant.
- New buyer-side **mute/unmute** button on the Reels right column (TikTok-style — once muted, every subsequent reel stays muted via a shared `RxBool` on `ReelsController` + a per-page `Worker`).

**Live broadcast quality**
- Zego engine now publishes at 720p (1280×720, ~1.5 Mbps) via `setVideoConfig(Preset720P)` immediately after `createEngineWithProfile`. Was falling back to the SDK default ~360p.

**Live page polish**
- Buyer-side viewer count was rendering a non-`Obx` `Text` so the `RxInt` updates never triggered a rebuild — now wrapped in `Obx` and formatted via `CustomFormatNumber` so big rooms render as `1.2K`.
- Removed the redundant top-right X button on the buyer top bar so the views badge has breathing room; system back / swipe back still exits.
- Mute/Flip icons + Report bottom-sheet reason list weren't redrawing after their controller update — `LiveController.onSwitchMic` / `onSwitchCamera` / `getReportReason` were calling `update([id])` against unkeyed `GetBuilder`s. Switched to bare `update()`.

#### 🐛 Bug fixes in v1.0.8

| Issue | Fix |
|---|---|
| Reels heart icon swapped (red shown when not liked, outline when liked) | The two assets (`ic_heart` outline, `ic_liked` red filled) were mapped backwards in three places. Fixed in `reels_widget.dart` (×2) and `store_product_widget.dart`. |
| Product Detail "Follow" button always read "Follow" even when already following | Was using bitwise-AND with an always-false local field instead of the server-returned `product.isFollow`. Driven off the model now and toggled optimistically. Same fix applied to the seller-profile preview's reels viewer. |
| Seller profile Follow toggle didn't refresh the followers count or list | `onChangeFollowButton` fired the API but never re-pulled followers. Now awaits the toggle then calls `onGetSellerFollowers`. Also fixed `onGetSellerFollowers` to clear the list before populating so re-fetches don't duplicate entries. |
| Seller profile SliverAppBar bottom overflowed by ~25px on Products tab | `preferredSize` heights bumped 114/56 → 140/78 to fit the natural Column size of `TabBar` + `CategoryTabsWidget`. |
| Reels follow pill identical colour for both states | Following = filled primary (active relationship); Follow = translucent dark CTA. Same convention as the seller-profile button. |
| AddProductLiveBottomSheet '+ Add' pill leaked to buyers | Hostness flag now passed through; the host-only quick-add no longer shows on the buyer's product list. |
| Reels page Follow pill's `isFollow` was always false | `getReelsForUser` aggregation now `$lookup`s the followers collection and projects an `isFollow` per-reel; Reel model gains the field. |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.7+10` → `1.0.8+11`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.12.0` → `1.15.0`) |
| Live swipe feed | `lib/seller_pages/live_page/view/live_swipe_view.dart` (new), `lib/seller_pages/live_page/util/live_swipe_resolver.dart` (new), `lib/services/app_link_service.dart`, `lib/custom/live_now_chip.dart`, `lib/user_pages/home_page/widget/{home_live_grid.dart,home_live_products_rail.dart}`, `lib/user_pages/search_page/view/unified_search_view.dart`, `lib/utils/CoustomWidget/Page_devided/home_page_divided.dart` |
| Live actions column | `lib/seller_pages/live_page/widget/live_widget.dart`, `lib/seller_pages/live_page/controller/live_controller.dart`, `lib/seller_pages/live_page/view/live_view.dart` |
| Live like + report backend | `backend/server/liveSellingHistory/liveSellingHistory.model.js`, `backend/socket.js`, `backend/server/liveSeller/liveSeller.controller.js`, `backend/server/reportoLive/{reportoLive.model.js,controller.js,route.js}` (new), `backend/route.js`, `backend/server/scheduledLive/scheduledLive.controller.js` |
| Live like + report Flutter | `lib/ApiService/user/{fetch_live_by_history_id_service.dart,report_service.dart}`, `lib/utils/socket_services.dart`, `lib/utils/api_url.dart` |
| Reel view counter + dedupe | `backend/server/reel/{reel.model.js,reel.controller.js,reel.route.js}`, `backend/server/viewHistoryOfReel/viewHistoryOfReel.model.js` (new), `backend/scripts/migrate_reel_view_reset.js` (new), `lib/ApiModel/seller/GetReelsForUserModel.dart`, `lib/ApiService/user/reel_view_service.dart` (new), `lib/utils/api_url.dart`, `lib/View/MyApp/AppPages/reels_page/widget/reels_widget.dart`, `lib/utils/CoustomWidget/Page_devided/home_page_divided.dart` |
| Reels perf + mute | `lib/View/MyApp/AppPages/reels_page/{controller/reels_controller.dart,view/reels_view.dart,widget/reels_widget.dart,api/fetch_reels_api.dart}` |
| Reels follow + heart icon fixes | `lib/View/MyApp/AppPages/reels_page/widget/reels_widget.dart`, `lib/View/MyApp/AppPages/reels_page/model/fetch_reels_model.dart`, `lib/user_pages/preview_seller_profile_page/widget/store_product_widget.dart`, `lib/user_pages/preview_seller_profile_page/view/preview_seller_profile_view.dart`, `lib/user_pages/preview_seller_profile_page/controller/preview_seller_profile_controller.dart`, `backend/server/reel/reel.controller.js` |
| Profile country/address | `lib/View/MyApp/Profile/edit_profile.dart`, `lib/Controller/GetxController/{user/edit_profile_controller.dart,login/login_controller.dart,login/splash_screen_controller.dart}`, `lib/Controller/ApiControllers/user/api_profile_edit_controller.dart`, `lib/ApiService/login/profile_edit_service.dart`, `lib/ApiModel/login/WhoLoginModel.dart`, `lib/utils/globle_veriables.dart`, `backend/server/user/{user.model.js,user.controller.js}` |
| Live broadcast quality | `lib/utils/Zego/create_engine.dart` |
| Product Detail Follow fix | `lib/View/MyApp/AppPages/product_detail.dart` |
| Localisation | `lib/utils/Strings/strings.dart` + 18 language files for `St.following` |

#### ✅ Testing Verification (v1.0.8)

1. **Live swipe**: open the live tab on home → tap a live tile → vertical swipe up — second live mounts, first tears down. No `loginRoom 1002001` errors. Back button still exits cleanly.
2. **Live like count**: 3 buyers in the same room, one taps Like — every viewer's count increments to the same total simultaneously. Late joiner gets the running total seeded on `addView`. Deep-link entry seeds via the byHistoryId response.
3. **Reel view dedupe**: same user opens a reel twice → server log shows first call `counted: true`, second `counted: false`. View count increments once. Different user opens same reel → counts again.
4. **Reels load**: cold-start app, tap Reels — first reel renders thumbnail immediately; video appears within ~1–2s on 4G. Tab away and back → instant render of cached feed; background refresh swaps in any new reels.
5. **Live broadcast quality**: a buyer device viewing a host's stream visibly sharper than 1.0.7. Zego logs report 1280×720 publish.
6. **Profile country/address**: edit profile → tap Country → pick from picker → saves; the picked country surfaces on the seller-account screen as `editUserCountry` and persists across app restarts.
7. **Regression**: existing live entry points (LIVE NOW chip, home grid, search results, share-link tap) still push the live page; chat history replays; like/share/report buttons still work; counters update; the new top-bar layout (no X) is unchanged.

#### Required server actions before deploy

1. `git pull` in `waxxapp_admin/backend`.
2. `node scripts/migrate_reel_view_reset.js` — zeroes existing inflated reel view counts and clears any prior history rows so the new dedupe baseline is clean. Idempotent; safe to re-run.
3. `pm2 restart backend`.

---
## 📲 Version 1.0.7 — Live push routing + chat history + clean share link
*(Play Store: What's New)*

**Version:** 1.0.7
**Build Number:** 10
**Release Date:** April 2026
**Type:** Stability / UX

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.0.7

🔔 Tap a "live now" notification → opens the broadcast directly
💬 Late joiners now see the chat history (no more empty panel)
🔗 Live share copy is the URL alone — no extra prompt line
🐛 Push routing reaches all followers, no more silent skips
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 Improvements in v1.0.7

**Push notification taps land on the broadcast**
- `notifyFollowersLiveStarted` now includes `liveSellingHistoryId` in the FCM data payload (one extra `LiveSeller.findOne` batched into the existing `Promise.all`).
- Flutter `handleRemoteMessage` gained a `fromTap` flag — OS-tap paths (`getInitialMessage`, `onMessageOpenedApp`, local-notification tap) all pass `fromTap: true` and route directly through `AppLinkService.instance.openLive(liveSellingHistoryId)`. Previously the tap routed to `/LiveSellingConsumer` with `sellerId`, which is a different page than the broadcast viewer.
- Foreground in-app messages keep the snackbar; its onTap also calls `openLive` so behaviour is consistent.
- `AppLinkService._openLive` is now public `openLive` so other entry points (push notification, future deep-link types) can reuse the same fetch + push flow with the live-ended snackbar, seller-of-this-live snackbar, network error fallback, and replace-vs-stack on existing `/LivePage`.

**Live chat history visible to late joiners**
- New `LiveChat` Mongo collection with TTL index (auto-deletes rows older than 30 days). Indexed on `liveSellingHistoryId + createdAt`.
- Socket "comment" handler now `LiveChat.create({...})` fire-and-forget alongside the existing comment-count update + room broadcast. The broadcast path is never blocked.
- New endpoint `GET /liveSeller/chatHistory/:liveSellingHistoryId?limit=50` returns the backlog in chronological order using the same JSON shape the socket emits, so the Flutter renderer needs zero changes.
- `LivePageView.initState` fires `FetchLiveChatHistoryService.fetch(...)` for buyers; result is appended to `mainLiveComments` before/while the socket starts streaming new comments.

**Live share copies the URL alone**
- `_handleShare` in `live_widget.dart` switched from `CustomShare.onShareApp(context: "Watch X live on Waxxapp", link: liveUrl)` (which prepended the prompt line) to `CustomShare.onShareLink(link: liveUrl)`, which calls `Share.share(link)` directly.

#### 🐛 Bug Fixes in v1.0.7

| Issue | Fix |
|---|---|
| Live-start FCM was silently skipping a class of followers | Removed the `User.isSeller: { $ne: true }` filter from `notifyFollowersLiveStarted`. In Waxxapp every account that has touched a seller surface has `User.isSeller=true`, so the filter dropped buyer-also-sellers (the most common test setup) silently. The explicit Follow tap is the opt-in regardless of the user's seller flag. Also added diagnostic `console.log` lines at every early-return path so the next silent skip is visible in the server log. (Backend `1.11.1` — already deployed.) |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.6+9` → `1.0.7+10`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.11.1` → `1.12.0`) |
| Push routing | `backend/server/scheduledLive/scheduledLive.controller.js`, `lib/services/push_notification_service.dart`, `lib/services/app_link_service.dart` |
| Chat history | `backend/server/liveChat/liveChat.model.js` (new), `backend/socket.js`, `backend/server/liveSeller/{liveSeller.controller.js,liveSeller.route.js}`, `lib/ApiService/user/fetch_live_chat_history_service.dart` (new), `lib/utils/api_url.dart`, `lib/seller_pages/live_page/view/live_view.dart` |
| Share text | `lib/seller_pages/live_page/widget/live_widget.dart` |

#### ✅ Testing Verification (v1.0.7)

| Target | Method | Status |
|---|---|---|
| `flutter analyze` on touched files | All slices clean (only pre-existing infos / deprecations) | ✅ |
| Bundle size | `app-release.aab` | (see build output) |
| Push tap (cold start) | Kill app → send LIVE_STARTED FCM → tap OS notification → lands on `LivePageView` for the right show | ⏳ Manual |
| Push tap (warm) | Background app → send FCM → tap → same as above | ⏳ Manual |
| Foreground push | Receive while app open → snackbar appears → tap → opens broadcast | ⏳ Manual |
| Chat history late-join | Buyer A says "hello"; 30 s later buyer B taps the live → B sees "hello" already in panel | ⏳ Manual |
| Backend smoke | `curl /liveSeller/chatHistory/<id>?limit=50 -H "key: <secret>"` returns `{ status:true, comments: [...] }` | ⏳ Manual |
| Share copy | Tap Share → paste → URL only, no prefix line | ⏳ Manual |

---

### 🌍 Localized "What's New" Text (v1.0.7)

**Spanish:**
```
🔧 Actualización — v1.0.7

🔔 Toca la notificación "en vivo" → abre la transmisión directamente
💬 Los espectadores que entran tarde ven el historial del chat
🔗 Compartir el enlace en vivo copia solo la URL — sin línea adicional
🐛 La notificación llega a todos los seguidores, sin omisiones silenciosas
```

**French:**
```
🔧 Mise à jour — v1.0.7

🔔 Touchez la notif "en direct" → ouvre la diffusion directement
💬 Les spectateurs en retard voient l'historique du chat
🔗 Le partage du lien copie uniquement l'URL — plus de ligne ajoutée
🐛 La notif atteint tous les abonnés, sans saut silencieux
```

**Arabic:**
```
🔧 تحديث — v1.0.7

🔔 انقر إشعار "بث الآن" → يفتح البث مباشرة
💬 المنضمون المتأخرون يرون سجل الدردشة
🔗 مشاركة الرابط تنسخ الرابط فقط — بدون سطر إضافي
🐛 الإشعار يصل إلى جميع المتابعين دون تخطّي صامت
```

**German:**
```
🔧 Update — v1.0.7

🔔 Tippe auf "Live jetzt"-Push → öffnet die Übertragung direkt
💬 Spät beitretende Zuschauer sehen den Chat-Verlauf
🔗 Teilen-Link kopiert nur die URL — ohne extra Textzeile
🐛 Push erreicht alle Follower, keine stillen Auslassungen
```

**Turkish:**
```
🔧 Güncelleme — v1.0.7

🔔 "Şimdi canlı" bildirimine dokun → yayını doğrudan açar
💬 Sonradan katılanlar artık sohbet geçmişini görüyor
🔗 Canlı bağlantı paylaşımı sadece URL'yi kopyalar — fazladan satır yok
🐛 Bildirim tüm takipçilere ulaşıyor, sessiz atlanma yok
```

---
## 🇬🇭 Version 1.0.6 — Mobile Money payouts + Live links + Promo codes + Mid-stream Shop
*(Play Store: What's New)*

**Version:** 1.0.6
**Build Number:** 9
**Release Date:** April 2026
**Type:** Feature drop + stability

### English (Default)
*(Max 500 characters on Play Store)*

```
🚀 Update — v1.0.6

💳 Mobile Money payouts (Momo Number, Network, Name) replace bank fields
🔗 Share a live show → tap opens the broadcast directly
🛒 Hosts can add products mid-stream without ending the show
🎟️ Sellers attach promo codes to listings (new + edit)
🎬 Reels Shop pill — see every product linked to a video
🔔 "Live now" push reaches followers + reel likers (no more silent skips)
💬 Fixed duplicated chat + chat-history clearing on rejoin
🐛 Many small live-streaming fixes
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New Features in v1.0.6

**Mobile Money payouts (Ghana-market rebuild of payout fields)**
- Bank Name / Account Number / IFSC Code / Branch Name → **Momo Number / Network Name / Momo Name** across the seller add-shop, edit-shop, profile-completion, and admin Shop view.
- `Network Name` is a fixed enum (`MTN`, `Vodafone`, `AirtelTigo`, `Telecel Cash`).
- All 18 language files updated; admin React panel relabeled.
- Backend `Seller.bankDetails` schema migrated (`bankBusinessName`, `bankName`, `momoNumber`, `momoName`, `networkName`).

**Live-show deep links — `/live/<liveSellingHistoryId>`**
- New backend `GET /liveSeller/byHistoryId/:id` returns the same flattened shape as `getliveSellerList` for a single live.
- Tapping a shared `https://www.waxxapp.com/live/<id>` link launches the app and pushes the buyer **straight into the broadcast** instead of dropping them on the Live tab. Falls back to the Live tab with a snackbar if the show ended; routes to the Live tab for the broadcasting seller themselves.
- New `live_now_chip.dart` deep-link share entry from the Whatnot-style live action column.

**Mid-stream "Add Product" for hosts**
- New host-only `+ Add product` button at the top of the live Shop sheet — opens a product picker that excludes the products already in the show.
- New backend `POST /liveSeller/addProductToLive` mutates `LiveSeller.selectedProducts` and emits a socket `selectedProductsUpdated` event so every viewer's Shop sheet reflects the addition without a page reload.

**Multi-product reels + Shop pill**
- `Reel.productId` is now an array (`[ObjectId]`); each reel can surface multiple linked products.
- New **Shop** pill in the home shorts viewer's right-side action column appears when a reel has more than one product. Tapping opens a bottom sheet listing every product (image / name / price). The previously-existing single-product card stays for the primary product.

**Promo Codes on listings (admin-managed → seller-attached)**
- New `PromoCode` collection (admin manages globally) with `Product.promoCodes` reference list.
- New seller multi-select picker on the **listing summary** page — lives as its own card alongside Pricing / Preferences. Select once on create; pre-fills from the current state on edit so a seller editing an unrelated field doesn't silently clear their existing attachments.
- Edit path goes through the same `ProductRequest` queue used by other field edits — `acceptUpdateRequest` copies `promoCodes` onto the live Product.

**Auction + Offer features removed from the UI**
- The seller-side and buyer-side entry points for time-boxed auctions and "Make an Offer" were removed for v1.0.6 to focus the experience on Buy-Now and live shopping. Backend code remains in place for now (no data migration), so the toggles can be brought back without an app reissue.

**Live-start notification audience expanded + bugfix**
- `notifyFollowersLiveStarted` now pushes to followers **AND** every user who liked one of the seller's reels — deduped against each other and against the scheduled-show reminder list. A buyer who liked a short is showing intent equivalent to a follow.
- **Critical bugfix:** the recipient query was filtering on `User.isSeller: { $ne: true }`, but every Waxxapp account that has touched a seller surface has `User.isSeller=true`. This silently dropped the most common test setup (a seller-also-buyer following another seller). Filter removed; explicit follow tap is the opt-in regardless of seller flag. Diagnostic `console.log` added at every early-return so the next silent skip is visible.

**Schedule Show cover image**
- Optional cover image on the Create-a-Show form (multipart `image`). Stored on the `ScheduledLive` doc, served on the upcoming-show cards and the Live tab.

**Email at phone signup + editable contact fields**
- Phone-OTP signup now collects an email; the existing profile screen exposes both email and phone as editable fields instead of read-only. Backend `User.email` schema gains a partial unique index that ignores empty strings.

**App Link plumbing**
- Custom `waxxapp://` scheme registered for the web-preview "Open in app" handoff (covers cases where the App-Link verified domain hasn't been claimed yet by the OS).
- AndroidManifest forces Impeller renderer (`io.flutter.embedding.android.EnableImpeller=true`) for LDPlayer / older emulator GPU compatibility.

#### 🐛 Bug Fixes in v1.0.6

| Issue | Fix |
|---|---|
| **Buyer chat duplicated 2×, 3×, 4× per send** | socket.io's auto-reconnect keeps the same Socket instance; listeners attached via `.on()` persist across reconnects, but `_isListenersSetup` was reset to false on every disconnect — every reconnect's `onConnect` re-ran `_setupEventListeners` and stacked another copy of every handler. Made `_setupEventListeners` idempotent (clears first, then re-attaches). Added `selectedProductsUpdated` to the clear list. |
| **Share-link tap left buyer on a black-screen loading spinner** | `app_links` fires `getInitialLink` AND `uriLinkStream` for the same launching Intent → `_handleUri` ran twice → two `LivePageView` mounts → `loginRoom #2` returned `1002001` ("already logged in") and the textures leaked. Added a 3-second same-URI dedup at the top of `_handleUri`; the deep-link path replaces an existing `/LivePage` instead of stacking. |
| **Buyer exit/rejoin → blank screen + emulator audio HAL spam** | `_cleanupZego` only logged out of the room. `stopPlayingStream` and `destroyCanvasView` were never called for the buyer's playback, leaving the native player and audio sink alive. Tracked `remoteStreamID` and tear it down before `logoutRoom`. Plus defensive `logoutRoom(roomID)` before `loginRoom` in `_loginRoom` so any stale Zego state from a prior session can't bounce the new login with `1002001`. |
| **Live-page top bar overflowed by ~24 px on narrower phones** (Close button clipped, Follow glued against Views) | The Row had three rigid children (profile group + views + close) whose combined width exceeded the screen on ~360px devices, so `MainAxisAlignment.spaceBetween` distributed zero gap. Wrapped the profile + Follow group in `Flexible`, dropped the fixed 178-px width on the inner profile container so it sizes to its content. The Row now redistributes leftover space normally. |
| **Reel product picker showed every product twice on second visit** | `ShowCatalogController` is a Get singleton shared with the seller catalog screen, and its `start` + `catalogItems` carried over between page entries. Reset on `initState` before re-fetching. |
| **Listing Summary > Category row overflowed by 20 px on long category names** | Wrapped category and subcategory `Text` widgets in `Flexible` with `overflow: TextOverflow.ellipsis`. |
| **Listing Summary had no UI for promo codes** | Picker was only reachable from a sub-screen. Added a dedicated `PromoCodesWidget` at the summary level matching the other section cards (Category / Pricing / Preferences). The picker bottom sheet was extracted to a shared helper so the summary card and the sub-screen stay in sync. |
| **`Go to cart` from successful order routed to Reels tab** | The cart route was hardcoded to the wrong bottom-bar index after the v1.0.4 tab reshuffle. Now routes to Cart (index 3). |
| **Seller-edit profile controller still used `accountNumber / IFSCCode / branchName` parameter names after the Momo migration** | Stray param names renamed to `momoNumber / networkName / momoName`, aligning the controller with the rest of the seller-edit pipeline. |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.5+8` → `1.0.6+9`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.6.0` → `1.11.1`) |
| Mobile Money rebuild | `backend/server/seller/seller.model.js`, every seller-side controller touching `bankDetails`, all 18 `lib/localization/language/*.dart`, admin `Component/Table/seller/Profile/Shop.js`, the seller add/edit/profile-completion forms in `lib/seller_pages/...` |
| Live deep links | `backend/server/liveSeller/{liveSeller.controller.js,liveSeller.route.js}` (new `getLiveByHistoryId` + `liveType` projection), `lib/services/app_link_service.dart` (`_openLive`), `lib/ApiService/user/fetch_live_by_history_id_service.dart` (new), `lib/utils/api_url.dart` |
| Mid-stream Add Product | `backend/server/liveSeller/liveSeller.controller.js` (`addProductToLive`), `backend/socket.js`, `lib/seller_pages/live_page/widget/live_widget.dart`, `lib/seller_pages/live_page/controller/live_controller.dart` |
| Multi-product reels + Shop | `backend/server/reel/reel.model.js` (productId → array), `lib/utils/CoustomWidget/Page_devided/show_reels.dart` (Shop pill), `lib/View/MyApp/AppPages/shorts_view.dart` |
| Promo Codes | `backend/server/promoCode/*` (new), `backend/server/product/{product.model.js,product.controller.js}` (`promoCodes` field + `parsePromoCodeIds`), `backend/server/productRequest/{productRequest.model.js,productRequest.controller.js}` (queued + direct + accept paths), `lib/ApiService/seller/{add_product_service,product_edit_service,promo_code_list_service}.dart`, `lib/seller_pages/listing/widget/{promo_code_picker,promo_codes_widget}.dart` (new), `lib/seller_pages/listing/view/{listing_summary,pricing_screen}.dart` |
| Live-start notifications | `backend/server/scheduledLive/scheduledLive.controller.js` (followers + reel-likers, dropped `isSeller` filter, diagnostic logs), `backend/server/liveSeller/liveSeller.route.js` (response-finish hook) |
| Live stream stability | `lib/utils/socket_services.dart` (idempotent listeners), `lib/services/app_link_service.dart` (URI dedup + `Get.off` over `Get.to`), `lib/seller_pages/live_page/view/live_view.dart` (defensive logoutRoom + viewer cleanup), `lib/seller_pages/live_page/widget/live_widget.dart` (overflow), `lib/utils/CoustomWidget/Page_devided/select_product_when_create_reels.dart` (catalog reset) |
| Auction + Offer removal | listing form, product detail, live page (entry points only — backend untouched) |
| Schedule Show cover | `backend/server/scheduledLive/{scheduledLive.model.js,scheduledLive.controller.js}` (multipart upload), `backend/server/liveSeller/liveSeller.route.js`, the seller schedule form |
| Email at signup | `backend/server/user/user.model.js` (partial unique index), `lib/View/UserLogin/...`, `lib/user_pages/profile/...` |
| Native config | `android/app/src/main/AndroidManifest.xml` (`EnableImpeller=true`, `waxxapp://` scheme already added) |

#### ✅ Testing Verification (v1.0.6)

| Target | Method | Status |
|---|---|---|
| `flutter analyze` | All slice files clean (only pre-existing `avoid_print` / deprecation infos) | ✅ |
| Bundle size | `app-release.aab` | (see build output below) |
| Live deep link cold-start | Tap shared `/live/<id>` from a killed app — opens broadcast directly | ⏳ Manual verification |
| Live deep link warm-start | Tap shared `/live/<id>` while app is on home — replaces, doesn't stack | ⏳ Manual verification |
| Buyer chat | Send 1 message after a socket reconnect — should appear once, not multiple times | ⏳ Manual verification |
| Live-start push | Seller with 1+ followers goes live → followers receive push (incl. seller-also-buyer accounts) | ⏳ Manual verification |
| Mobile Money seller-onboarding | Add Shop with momoNumber + networkName + momoName → values stored and visible in admin Shop tab | ⏳ Manual verification |

> ⚠️ Build number 9 is the same as the previously-uploaded v1.0.6+9 from the Promo-Codes commit. If uploading to Play Console, bump `pubspec.yaml` to `1.0.6+10` (or higher) before `flutter build appbundle --release` to avoid the `versionCode already exists` rejection.

---

### 🌍 Localized "What's New" Text (v1.0.6)

**Spanish:**
```
🚀 Actualización — v1.0.6

💳 Pagos por Mobile Money (número Momo, red, nombre) reemplazan los campos bancarios
🔗 Compartir un show en vivo → al tocar abre la transmisión directamente
🛒 Los anfitriones pueden añadir productos durante el show sin terminarlo
🎟️ Los vendedores pueden adjuntar códigos promocionales a sus productos
🎬 Pestaña Tienda en los reels — todos los productos vinculados a un video
🔔 La notificación "ahora en vivo" llega a seguidores y a quienes dan like a reels
💬 Arreglado el chat duplicado y el historial al volver a entrar
```

**French:**
```
🚀 Mise à jour — v1.0.6

💳 Paiements Mobile Money (numéro Momo, réseau, nom) remplacent les champs bancaires
🔗 Partager un show en direct → l'appui ouvre la diffusion directement
🛒 Les hôtes peuvent ajouter des produits en plein show sans l'arrêter
🎟️ Les vendeurs attachent des codes promo à leurs produits
🎬 Pastille Boutique dans les reels — voir tous les produits liés à une vidéo
🔔 La notif "en direct" atteint abonnés et likers de reels
💬 Chat dupliqué et historique au re-entrée corrigés
```

**Arabic:**
```
🚀 تحديث — v1.0.6

💳 مدفوعات Mobile Money (رقم Momo، الشبكة، الاسم) بدل حقول البنك
🔗 مشاركة بث مباشر → النقر يفتح البث مباشرة
🛒 يمكن للمضيفين إضافة منتجات أثناء البث دون إنهائه
🎟️ يربط البائعون أكواد الخصم بمنتجاتهم
🎬 شارة المتجر في الريلز — كل المنتجات المرتبطة بالفيديو
🔔 إشعار "بث مباشر الآن" يصل للمتابعين ومن يعجبه الريلز
💬 إصلاح ازدواج الدردشة وفقدان السجل عند إعادة الدخول
```

**German:**
```
🚀 Update — v1.0.6

💳 Mobile-Money-Auszahlungen (Momo-Nummer, Netz, Name) ersetzen die Bankfelder
🔗 Live-Show teilen → ein Tap öffnet die Übertragung direkt
🛒 Hosts können Produkte mitten im Stream hinzufügen
🎟️ Verkäufer hängen Promo-Codes an ihre Artikel
🎬 Shop-Chip in Reels — alle verknüpften Produkte sichtbar
🔔 "Jetzt live"-Push erreicht Follower und Reel-Liker
💬 Doppelter Chat und fehlender Verlauf beim Wieder-Eintritt behoben
```

**Turkish:**
```
🚀 Güncelleme — v1.0.6

💳 Mobile Money ödemeleri (Momo numarası, ağ, isim) banka alanlarının yerini aldı
🔗 Canlı yayını paylaş → dokun, doğrudan yayın açılsın
🛒 Sunucular yayını sonlandırmadan ürün ekleyebiliyor
🎟️ Satıcılar ürünlerine promosyon kodu ekliyor
🎬 Reels'te Mağaza rozeti — videoya bağlı her ürün görünür
🔔 "Şu anda canlı" bildirimi takipçilere ve reels beğenenlere de gidiyor
💬 Tekrarlayan sohbet ve yeniden girişte kaybolan geçmiş düzeltildi
```

---
## 🔧 Version 1.0.5 — Live reliability + Deep Links + Reels polish
*(Play Store: What's New)*

**Version:** 1.0.5
**Build Number:** 8
**Release Date:** April 2026
**Type:** Stability + small features

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Update — v1.0.5

🔗 Share a short → real link to the video, not just the install page
🛰️ Live shows that ended now disappear within ~90s (no zombies)
📅 Scheduled Shows: empty state on the Live tab + correct timezone
📱 Live tab: clearer placeholders when nothing is live or scheduled
🎬 Seller profile Reels: fixed "0 reels" bug + smoother like updates
🛡️ Auto-pop with a clear message when a stream isn't broadcasting
🐛 Many small fixes throughout
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New Features in v1.0.5

**Deep links for shorts (Android App Links + iOS Universal Links)**
- New backend page `GET /short/:reelId` serves an OG-tagged HTML preview (thumbnail, video, seller, "Open in app" / "Install" buttons) so shared links unfurl nicely in WhatsApp / iMessage / Slack and recipients without the app see a real preview instead of a generic Play Store page.
- Backend serves `/.well-known/assetlinks.json` (Android) and `/.well-known/apple-app-site-association` (iOS) with the correct content-type. Verifies the `com.waxxapp` package on Android and `W5T948BC35.com.erashop.live` on iOS, scoped to `/short/*`.
- Flutter share message replaced with `https://www.waxxapp.com/short/<reelId>`. With the app installed and the domain verified, taps open the app directly at the Reels tab; without the app, taps land on the web preview.
- New `AppLinkService` (built on the `app_links` package) listens for inbound links and routes `/short/<id>` to the Reels tab. Designed to extend to `/seller/<id>`, `/product/<id>`, `/live/<id>` later.
- Android manifest: replaced placeholder Branch intent filter with a verified `<intent-filter android:autoVerify="true">` for `https://www.waxxapp.com/short/`. iOS entitlements: replaced placeholder `*.app.link` associated domains with `applinks:www.waxxapp.com`.

**Live session reliability — heartbeat-based zombie sweep**
- Seller's app now pings `POST /liveSeller/heartbeat` every 30s while broadcasting; backend bumps `LiveSeller.lastHeartbeatAt`.
- New 90-second TTL sweep on `getliveSellerList` evicts any `LiveSeller` row whose last heartbeat is stale, plus any `Seller.isLive=true` whose `LiveSeller` row is missing entirely. Falls back to `createdAt` for legacy rows.
- The socket disconnect handler now also flips `Seller.isLive=false` and clears `liveSellingHistoryId` (previously deleted only the `LiveSeller` row, leaving the `isLive` flag stuck on forever — the actual root cause of zombie cards on the home page).
- Net effect: when a broadcaster crashes / force-quits / loses connectivity, the live card disappears within ~90 seconds instead of lingering for hours.

**Live tab empty states**
- "No upcoming shows. Follow sellers to see their scheduled streams here." now renders under the Upcoming Shows header on the Live hub when there's nothing to show. The home page keeps the silent-collapse behaviour because home has plenty of other content.
- "No sellers are live right now" is now actually reactive — previously it lived inside a `GetBuilder` keyed `'onChangeTab'` that the controller never broadcast to, so the placeholder never rendered no matter the data state. Wrapped in `Obx` keyed off `isLoading` and `getSellerLiveList`.

**Live viewer timeout UX**
- When a buyer joins a Zego room and no remote stream arrives within 8 seconds (typical of a stale "live" row), instead of silently popping back the page now shows a clear snackbar "This live stream isn't broadcasting right now. Please try again later." and pops 1.5 seconds later.

#### 🐛 Bug Fixes in v1.0.5

| Issue | Fix |
|---|---|
| Tapping a short on the home shorts rail opened the **Live** tab instead of Reels | After the tab order was reshuffled in v1.0.4 (`Home · Live · Reels · Cart · Profile`), `home_page_divided.dart` was still passing index `1` (Live) to `BottomBarController.onChangeBottomBar(...)`. Changed to index `2` (Reels) and added a comment to keep the next renumber honest. |
| Scheduled Show created at a local time was stored at the wrong wall-clock instant on the server | `schedule_live_service.dart` was sending `selectedDateTime.toIso8601String()` on a local `DateTime` (no offset, no `Z`); Node parsed it as **server-local** time. Now sends `selectedDateTime.toUtc().toIso8601String()`. |
| Reels card overflowed by 21 px → black-and-yellow stripes on top of the price/Buy Now row | Wrapped the price `Text` in `Expanded` so its `TextOverflow.ellipsis` actually clips. Removed redundant `5.width` + `Spacer()`. |
| Seller profile showed "0 Reels / No Data Found" even when the seller had uploaded shorts | Two issues: (1) back-button reset `FetchSellerProfileApi.startPagination = 0`, which made the next visit call `?start=0` → backend computed `.skip(-10)` → 500. Reset to `1`. (2) `SellerReelsModel` parsed `productId` as a single object but the Reel schema declares it as an array; deserialization threw `List<dynamic> is not a subtype of Map<String, dynamic>` and the whole reels payload was dropped. Factory now accepts both shapes. |
| Re-entering the seller profile for a different seller showed the previous seller's reels | `Get.put` returned the existing controller without re-firing `onInit`. New `setSellerId(id)` method detects the change, clears state, and re-fetches. |
| Followers tab on the seller profile crashed with `RangeError (length): Not in inclusive range 0..3: 4` | The `ListView.builder` had no `itemCount` so it built past the list end. Added `itemCount: controller.followersList.length`. |
| Reel "comment" count rendered as the literal string "null" | The Reel schema has no comment field on the backend (no model, route, or controller). The Dart model has a nullable `comment` field that's always `null` in API responses. Hid the comment icon and count entirely until the feature ships; defensively coalesced `like` to 0 in the same place. |
| Like count on the seller-profile reels grid didn't update after the user toggled a like in the full-screen viewer | `onGetSellerReels` was using `addAll`, so calling it again would duplicate. Made it idempotent (`reels.clear()` first + reset pagination). The seller profile now re-fetches when popping back from the full-screen viewer. |
| Backend `reelsOfSeller` 500'd on `?start=0` requests | Clamped `start` and `limit` to `Math.max(1, …)` so a stale or buggy client can't take the endpoint down. |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.4+7` → `1.0.5+8`) |
| Backend version | `waxxapp_admin/backend/package.json` (`1.1.0` → `1.2.0`) |
| Deep-link infra (backend) | `backend/server/shortPreview/{shortPreview.controller.js,shortPreview.route.js}` (new), `backend/well-known/{assetlinks.json,apple-app-site-association}` (new), `backend/index.js`, `backend/route.js` |
| Deep-link infra (Flutter) | `lib/services/app_link_service.dart` (new), `lib/main.dart`, `lib/custom/custom_share.dart`, `lib/utils/api_url.dart`, `pubspec.yaml` (added `app_links: ^6.4.1`) |
| Native config | `android/app/src/main/AndroidManifest.xml` (App Link intent filter), `ios/Runner/Runner.entitlements` (associated domains) |
| Live heartbeat | `backend/server/liveSeller/{liveSeller.model.js,liveSeller.controller.js,liveSeller.route.js}`, `backend/socket.js`, `lib/ApiService/seller/live_seller_for_selling_service.dart`, `lib/seller_pages/live_page/view/live_view.dart` |
| Live tab empty states | `lib/user_pages/live_hub/view/live_hub_view.dart`, `lib/user_pages/upcoming_lives/view/upcoming_lives_widget.dart` |
| Bug fixes | `lib/utils/CoustomWidget/Page_devided/home_page_divided.dart` (shorts → Reels), `lib/ApiService/seller/schedule_live_service.dart` (UTC), `lib/View/MyApp/AppPages/reels_page/widget/reels_widget.dart` (Row overflow), `lib/seller_pages/live_page/view/live_view.dart` (timeout snackbar), `lib/user_pages/preview_seller_profile_page/{view/preview_seller_profile_view.dart,controller/preview_seller_profile_controller.dart,widget/store_product_widget.dart}` (reels visibility, followers `itemCount`, like refresh, comment icon hidden), `lib/ApiModel/seller/SellerReelsModel.dart` (productId list parse), `backend/server/reel/reel.controller.js` (pagination clamp) |
| Reel share call sites | `lib/View/MyApp/AppPages/reels_page/widget/reels_widget.dart`, `lib/utils/CoustomWidget/Page_devided/show_reels.dart`, `lib/user_pages/preview_seller_profile_page/widget/store_product_widget.dart` (now pass `https://www.waxxapp.com/short/<id>`) |

#### ✅ Testing Verification (v1.0.5)

| Target | Method | Status |
|---|---|---|
| `.well-known/assetlinks.json` reachable | `curl -i https://www.waxxapp.com/.well-known/assetlinks.json` | ✅ 200 application/json |
| `.well-known/apple-app-site-association` reachable | `curl -i https://www.waxxapp.com/.well-known/apple-app-site-association` | ✅ 200 application/json |
| `/short/:reelId` HTML preview | `curl -I https://www.waxxapp.com/short/<id>` | ✅ 200 text/html |
| Seller heartbeat | New `POST /liveSeller/heartbeat` | ✅ wired in `live_view.dart` |
| App Link verification (Android) | `adb shell pm verify-app-links --re-verify com.waxxapp` | ⏳ requires release-build install |
| Universal Link (iOS) | Long-press link in Notes → "Open in Waxxapp" | ⏳ requires real device with new build |

> **Reminder before publishing:** if Play App Signing is enabled, add the Play-managed App Signing Key SHA-256 (visible in Play Console → App integrity) to `backend/well-known/assetlinks.json`. Currently that file holds the upload key + debug key, which covers direct-APK installs but not Play Store deliveries until the App Signing key is added.

---

### 🌍 Localized "What's New" Text (v1.0.5)

**Spanish:**
```
🔧 Actualización — v1.0.5

🔗 Compartir un short → enlace directo al video, no solo la tienda
🛰️ Los shows en directo terminados desaparecen en ~90 s
📅 Próximos shows: estado vacío en la pestaña En Vivo + zona horaria correcta
📱 Pestaña En Vivo: mensajes claros cuando no hay nada en directo
🎬 Reels en perfil del vendedor: corrección de "0 reels" y likes más fluidos
🐛 Múltiples mejoras y correcciones
```

**French:**
```
🔧 Mise à jour — v1.0.5

🔗 Partager un short → vrai lien vers la vidéo, plus seulement vers le store
🛰️ Les lives terminés disparaissent en ~90 s
📅 Prochains shows : état vide sur l'onglet En Direct + bon fuseau horaire
📱 Onglet En Direct : messages clairs quand rien n'est en direct
🎬 Reels du profil vendeur : correctif "0 reels" + likes plus fluides
🐛 Nombreuses petites corrections
```

**Arabic:**
```
🔧 تحديث — v1.0.5

🔗 مشاركة الفيديو القصير → رابط مباشر للفيديو، وليس لصفحة التثبيت فقط
🛰️ تختفي عروض البث المنتهية خلال نحو 90 ثانية
📅 العروض القادمة: حالة فارغة في تبويب البث + منطقة زمنية صحيحة
📱 تبويب البث: رسائل أوضح عند عدم وجود بث
🎬 ريلز الملف الشخصي للبائع: إصلاح "0 ريلز" وتحسين تحديث الإعجابات
🐛 إصلاحات صغيرة عديدة
```

**German:**
```
🔧 Update — v1.0.5

🔗 Short teilen → echter Link zum Video, nicht nur zur Installationsseite
🛰️ Beendete Live-Shows verschwinden in ca. 90 s
📅 Geplante Shows: leerer Zustand im Live-Tab + korrekte Zeitzone
📱 Live-Tab: klare Hinweise, wenn gerade nichts läuft
🎬 Verkäuferprofil-Reels: "0 Reels"-Bug behoben, flüssigere Like-Updates
🐛 Viele kleine Korrekturen
```

**Turkish:**
```
🔧 Güncelleme — v1.0.5

🔗 Short paylaş → mağaza yerine doğrudan videoya gerçek bağlantı
🛰️ Sona eren canlı yayınlar yaklaşık 90 sn içinde kaybolur
📅 Yaklaşan yayınlar: Canlı sekmesinde boş durum + doğru saat dilimi
📱 Canlı sekmesi: hiçbir yayın yokken net bilgilendirme
🎬 Satıcı profili Reels: "0 reels" düzeltildi + akıcı beğeni güncelleme
🐛 Birçok küçük iyileştirme
```

---
## 🚀 Version 1.0.4 — Whatnot-Parity Feature Drop
*(Play Store: What's New)*

**Version:** 1.0.4
**Build Number:** 7
**Release Date:** April 2026
**Type:** Major feature release

### English (Default)
*(Max 500 characters on Play Store)*

```
🎉 Big feature update — v1.0.4

🎥 New Live tab — one tap to all on-air shows
🔍 Unified search: products, sellers, live shows, reels
💰 Max-bid auto-bidding on live auctions
📦 Combined shipping — one fee for multiple wins per seller
🤝 Make an Offer on Buy-Now listings (accept, counter, decline)
📡 LIVE NOW chips on reels + Live Right Now rail on home
❤️ Wishlist pinned to the home top bar
🐛 Stability and dark-theme fixes throughout
```

### 📋 Full Internal Release Notes (for your team)

#### 🆕 New Features in v1.0.4

**Live shopping prominence**
- New `Live` tab in the bottom nav at index 1 — order is now Home · Live · Reels · Cart · Profile.
- New `LiveHubView` aggregates `HomeLiveGrid`, `HomeLiveProductsRail`, and `UpcomingLivesSection` with a friendly empty state when nobody is broadcasting.
- New `LIVE NOW` pulsing pink chip on every reel whose seller is currently broadcasting → tap deep-links into the live viewer.
- New `Live Right Now` product rail on the home page — one card per show with an active auction.

**In-show auctions (real, not demo)**
- Live auction overlay with current bid, mm:ss countdown, quick `BID $next` button, and a green `SOLD` reveal banner. Host gets a gavel button to start auctions on selected products.
- New socket listeners (`initiateAuction`, `announceTopBidPlaced`, `declareAuctionResult`, `auctionError`) and emitters (`onPlaceBid`, `onInitiateAuction`).
- Configurable `bidIncrement` per product (default 5) replaces the hardcoded `+1`/`+10`.

**Proxy / auto-bid (max bid)**
- Long-press the `BID` button to set a max-bid cap. Server places counter-bids on your behalf up to the cap.
- Backend `triggerAutoBid` now wired into the live socket handler (previously manual auctions only).
- Race-safe: per-product async lock + re-read under lock + cascade so multiple auto-bidders resolve cleanly.
- Live auto-counters broadcast a synthetic `announceTopBidPlaced` so every viewer's overlay updates and the soft-close timer resets.

**Combined shipping (bundles)**
- New `util/orderAggregator.js` finds an existing unpaid Order from the same buyer to the same seller and appends new wins instead of creating a fresh Order each time.
- Wired into manual auction worker, live `declareWinner`, and (opt-in) offer-accept paths.
- Per-seller `shippingMode`: `max` (Whatnot default — pay the heaviest fee once), `sum` (legacy), `flat`.
- New `Bundle Pending Payment` Order item status.
- New `Pending Wins` screen under Profile lists each unpaid bundle with combined totals and a `Settle up` CTA.

**Buyer ↔ seller offers on static listings**
- New `Offer` collection + 7 endpoints: `create / withdraw / accept / counter / decline / received / sent / adminList`.
- Order auto-created at agreed price on accept; FCM + in-app notifications on every state change.
- Buyer sees `Make an Offer` on product detail when seller has `allowOffer = true`; new `My Offers` screen on profile shows lifecycle (pending / countered / accepted / declined / withdrawn).
- New seller `Received Offers` inbox with tabs and accept / counter / decline actions.

**Unified search**
- New `GET /search/all?q=&scope=&limit=` with MongoDB `$text` indexes on Product, Seller, Reel + regex fallback for cold indexes.
- New `UnifiedSearchView` replaces the old product-only screen — tabs for Products / Sellers / Live / Reels backed by a single API call with 350 ms debounce.

**Offer / approval emails (Resend)**
- New `util/emailSender.js` sends branded transactional emails for seller request approve/reject and product request approve/reject.
- Seller request rejection flow added (was previously a silent no-op).
- All decision endpoints now return `deliveries: { push, email }` with per-channel status (`sent | failed | no_token | no_email | not_configured`).

**Activity notifications**
- FCM + in-app `Notification` row when a viewer likes a seller's reel.

**UI polish**
- Pinned `Wishlist` heart icon in the home top bar (Search · Wishlist · Notifications).
- `Verified seller` badge, pulsing live avatar rings, follow pill in live view, system messages in chat (`SOLD`, `BID`, `GIVEAWAY_WIN`, `FOLLOW`).
- Home category section renamed `Shop by Category` (was `New Categories`) across all 18 languages — the carousel never showed "new" anything.
- Bottom-nav order swap: Live promoted ahead of Reels.

#### 🐛 Bug Fixes in v1.0.4

| Issue | Fix |
|---|---|
| Share button generated `bnc.lt/Enter your branch io key/...` URLs | Replaced Branch.io deep linking with plain Play Store share via `CustomShare.onShareApp`; reels page hardcoded `com.erashop.live` URL also fixed |
| Wishlist had no back arrow and system back was hijacked | Replaced bottom-nav-root header with a standard back-arrow AppBar and dropped the `PopScope(canPop: false)` override |
| Giveaway Wins screen rendered black-on-near-black text | Re-themed to match dark scaffold convention used by MyOffers / PendingWins |
| Unified Search header overflowed by 6 px on devices with bigger status bars | Wrapped header in `SafeArea(bottom: false)` and bumped `PreferredSize` to 128 |
| Home page didn't load Popular / Category products on first visit | Consolidated controller registration into `HomeView.initState` via a `_putOnce<T>` helper |
| Buy Now triggered `Please fill all attributes` for products without variants | Replaced bool field with computed getter that returns `true` when no required attributes exist |
| Buy Now crash from `Get.put(BottomBarController())` replacing the live instance | Guarded with `Get.isRegistered<T>()` checks at every replace site |
| `Seller` row not removed when admin deleted a seller-user | `adminDeleteUser` now resolves seller via both `Seller.userId` and `User.seller`, plus a `Seller.deleteMany({ userId })` safety sweep |

#### 📁 Files Changed

| Area | Files |
|---|---|
| Version | `pubspec.yaml` (`1.0.3+6` → `1.0.4+7`) |
| Bottom nav | `lib/user_pages/bottom_bar_page/{controller,widget}/*` , `lib/utils/branch_io_services.dart`, `lib/utils/CoustomWidget/Page_devided/home_page_divided.dart` |
| Live hub | `lib/user_pages/live_hub/view/live_hub_view.dart` (new) |
| Live auction | `lib/user_pages/live_page/{controller/live_auction_controller,widget/live_auction_overlay,widget/set_max_bid_sheet}.dart`, `backend/socket.js`, `backend/server/autoBid/*` |
| Combined shipping | `backend/util/orderAggregator.js` (new), `backend/server/order/order.model.js`, `backend/server/seller/seller.model.js`, `backend/workers/manualAuctionWorker.js`, `backend/server/offer/offer.controller.js`, `lib/user_pages/pending_wins/view/pending_wins_screen.dart` (new) |
| Offers | `backend/server/offer/*` (new), `lib/{ApiModel,ApiService}/offer/*` (new), `lib/user_pages/offer/*` (new), `lib/seller_pages/offers/view/received_offers_screen.dart` (new) |
| Unified search | `backend/server/search/*` (new), `lib/{ApiModel,ApiService}/search/*` (new), `lib/user_pages/search_page/{controller/unified_search_controller,view/unified_search_view}.dart` (new), text indexes on Product/Seller/Reel models |
| Email | `backend/util/emailSender.js` (new), seller-request and product-request controllers |
| Wishlist top bar | `lib/user_pages/home_page/view/home_view.dart` |
| Wishlist back button | `lib/View/MyApp/AppPages/my_favorite.dart` |
| Giveaway theme | `lib/user_pages/giveaway/view/my_giveaway_wins_screen.dart` |
| Localization | 18 language files (`newCategories` → "Shop by Category") |

#### ✅ Testing Verification (v1.0.4)

| Target | Method | Status |
|---|---|---|
| Closed Testing (Play Store) | App Signing Key + Play Integrity | ⏳ pending upload |
| Real device debug (`flutter run`) | reCAPTCHA + debug SHA | ✅ Verified |
| `flutter analyze` | All slice files clean | ✅ No new errors |
| Bundle size | `app-release.aab` | 125.8 MB |

---

### 🌍 Localized "What's New" Text (v1.0.4)

**Spanish:**
```
🎉 Gran actualización — v1.0.4

🎥 Nueva pestaña En Vivo — toca para ver shows en directo
🔍 Búsqueda unificada: productos, vendedores, shows en vivo, reels
💰 Puja máxima automática en subastas en directo
📦 Envío combinado — una sola tarifa para varias ganancias del mismo vendedor
🤝 Haz una oferta en productos Buy-Now (aceptar, contraofertar, rechazar)
📡 Chip LIVE NOW en reels y carrusel En Directo en el inicio
❤️ Lista de deseos fijada en la parte superior
```

**French:**
```
🎉 Grande mise à jour — v1.0.4

🎥 Nouvel onglet En Direct — un appui pour voir les shows
🔍 Recherche unifiée : produits, vendeurs, shows en direct, reels
💰 Enchère maximale automatique sur les ventes en direct
📦 Livraison groupée — un seul frais pour plusieurs gains chez le même vendeur
🤝 Faites une offre sur les produits Buy-Now (accepter, contre-offre, refuser)
📡 Badge LIVE NOW sur les reels + carrousel En Direct sur l'accueil
❤️ Liste de souhaits épinglée en haut
```

**Arabic:**
```
🎉 تحديث ميزات كبير — v1.0.4

🎥 تبويب البث المباشر الجديد — انقر للوصول إلى العروض الحية
🔍 بحث موحّد: المنتجات، البائعين، البث المباشر، الريلز
💰 المزايدة التلقائية بحد أقصى في المزادات الحية
📦 شحن مجمّع — رسوم شحن واحدة لعدة فوزات من البائع نفسه
🤝 قدّم عرض سعر على منتجات الشراء الفوري (قبول، مقابلة، رفض)
📡 شارة LIVE NOW على الريلز + سلسلة البث المباشر الآن
❤️ قائمة الرغبات مثبتة في أعلى الصفحة الرئيسية
```

**German:**
```
🎉 Großes Funktions-Update — v1.0.4

🎥 Neuer Live-Tab — auf einen Tap zu allen On-Air-Shows
🔍 Vereinheitlichte Suche: Produkte, Verkäufer, Live-Shows, Reels
💰 Maximalgebot mit Auto-Bieten in Live-Auktionen
📦 Kombinierter Versand — eine Gebühr für mehrere Gewinne pro Verkäufer
🤝 Mach ein Angebot auf Buy-Now-Artikel (annehmen, kontern, ablehnen)
📡 LIVE-NOW-Chip auf Reels + "Jetzt live"-Leiste auf der Startseite
❤️ Wunschliste oben in der Top-Leiste verankert
```

**Turkish:**
```
🎉 Büyük özellik güncellemesi — v1.0.4

🎥 Yeni Canlı sekmesi — yayındaki tüm gösterilere tek dokunuşla erişim
🔍 Birleşik arama: ürünler, satıcılar, canlı gösteriler, reels
💰 Canlı açık artırmalarda otomatik maksimum teklif
📦 Birleştirilmiş kargo — aynı satıcıdan birden fazla kazanca tek ücret
🤝 Buy-Now ürünlerinde Teklif Ver (kabul, karşı teklif, reddet)
📡 Reels'lerde LIVE NOW rozeti + ana sayfada Şu Anda Canlı şeridi
❤️ İstek listesi ana sayfanın üstüne sabitlendi
```

---
## Version 1.0.3 - Hotfix: Crash Stability Improvements
*(Play Store: What's New)*

**Version:** 1.0.3
**Build Number:** 6
**Release Date:** April 2026
**Type:** Hotfix / Stability

### English (Default)
*(Max 500 characters on Play Store)*

```
Bug Fix Update - v1.0.3

Fixed a dropdown-related crash in seller product flows.
Fixed a gallery image picker crash that could happen on some Samsung/Android devices.
Improved stability when selecting product photos and changing listing options.
```

### Full Internal Release Notes (for your team)

#### Bug Fixes in v1.0.3

**Dropdown overlay crash fix:**
- Fixed a crash caused by `DropdownController.close()` attempting to remove an overlay entry after it had already been detached.
- Root cause: the vendored `cool_dropdown` controller was not guarding repeated close calls during async overlay teardown.
- Fix: patched the local `cool_dropdown` package to make `close()` idempotent, verify the overlay is still mounted, and clean up controller state safely.

**Listing photo picker null crash:**
- Fixed a crash in `ListingController.productPickFromGallery()` where `pickImage()` could return `null` and the code immediately forced `image!.path`.
- This was most visible on some Samsung devices and Android gallery/provider edge cases.
- Fix: added null checks, empty-path protection, file existence validation, and graceful error handling before adding the image to the listing.

#### Files Changed
| File | Change |
|---|---|
| `pubspec.yaml` | Version bumped `1.0.2+5` -> `1.0.3+6` and local override added for `cool_dropdown` |
| `lib/seller_pages/listing/controller/listing_controller.dart` | Guarded gallery image picking against null and invalid file results |
| `packages/cool_dropdown/lib/controllers/dropdown_controller.dart` | Patched overlay close lifecycle handling |

---
## 🔧 Version 1.0.2 — Hotfix: Firebase Auth Fix for Play Store
*(Play Store: What's New)*

**Version:** 1.0.2
**Build Number:** 5
**Release Date:** April 2026
**Type:** Hotfix / Security

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Bug Fix Update – v1.0.2

✅ Fixed "not authorized" Firebase Authentication error on Play Store builds
✅ Resolved Play Integrity token verification failure
✅ Improved sign-in reliability for phone number (OTP) login
✅ Security improvement: sensitive config files removed from source control

All existing features remain unchanged.
```

### 📋 Full Internal Release Notes (for your team)

#### 🐛 Bug Fixes in v1.0.2

**Firebase Authentication — Play Store Build Fix:**
- **Fixed:** Firebase Authentication error on Play Store (closed testing) builds:
  *"This app is not authorized to use Firebase Authentication. A play_integrity_token was passed, but no matching SHA-256 was registered in the Firebase console."*
- **Root cause:** Google Play App Signing re-signs the AAB with a Google-managed key.
  The SHA-256 of this App Signing Key (`C8:5C:E5:C6:09:AB:78:38:4A:E8:D1:EB:98:50:21:B3:DE:2C:A2:5D:7D:B5:E2:00:26:52:7B:B6:FD:9F:B7:6E`)
  was not registered in Firebase Console, so Play Integrity token verification failed.
- **Fix:** Added Google Play App Signing Key SHA-256 to Firebase Console
  (Project Settings → com.waxxapp → SHA certificate fingerprints).

**Security Improvement:**
- Removed `android/app/google-services.json` from git tracking via `.gitignore`
  to prevent sensitive Firebase API keys and config from being exposed in the repository.

#### 📁 Files Changed
| File | Change |
|---|---|
| `pubspec.yaml` | Version bumped `1.0.1+4` → `1.0.2+5` |
| `android/app/.gitignore` | `google-services.json` excluded from git (already present) |
| `android/app/google-services.json` | Removed from git index (`git rm --cached`) |

#### 🔑 Firebase SHA Fingerprints (Full List after v1.0.2)
| Fingerprint | Type | Source |
|---|---|---|
| `8A:94:18:DE...3C:1D:A8` | SHA-1 | Upload key (`waxx_release.jks`) |
| `18:81:C6:24...64:1A:C4` | SHA-1 | Debug keystore |
| `DE:FC:1D:B3...19:BE:D3` | SHA-256 | Upload key (`waxx_release.jks`) |
| `9B:83:91:45...7B:85:6A` | SHA-256 | Debug keystore |
| `C8:5C:E5:C6...B7:6E` ✅ **(NEW)** | SHA-256 | Google Play App Signing Key |

#### ✅ Testing Verification (v1.0.2)
| Target | Method | Status |
|---|---|---|
| Closed Testing (Play Store) | Play Integrity (App Signing Key) | ✅ Fixed |
| Sideload / Local APK | Upload key SHA | ✅ Works |
| Real device debug (`flutter run`) | reCAPTCHA + debug SHA | ✅ Works |
| Emulator (Google APIs image) | Firebase test numbers | ⚠️ Use test numbers |

---

### 🌍 Localized "What's New" Text (v1.0.2)

**Spanish:**
```
🔧 Actualización de corrección v1.0.2
✅ Solucionado: error de autenticación Firebase en Play Store
✅ Corrección del fallo de verificación Play Integrity
✅ Inicio de sesión con OTP más confiable
```

**French:**
```
🔧 Mise à jour corrective v1.0.2
✅ Corrigé : erreur d'authentification Firebase sur Play Store
✅ Correction de l'échec de vérification Play Integrity
✅ Connexion OTP par téléphone plus fiable
```

**Arabic:**
```
🔧 تحديث إصلاح الأخطاء v1.0.2
✅ تم إصلاح: خطأ في مصادقة Firebase على متجر Play
✅ إصلاح فشل التحقق من Play Integrity
✅ تسجيل الدخول عبر OTP أكثر موثوقية
```

**German:**
```
🔧 Fehlerbehebungs-Update v1.0.2
✅ Behoben: Firebase-Authentifizierungsfehler im Play Store
✅ Behebung des Play Integrity Verifizierungsfehlers
✅ Zuverlässigere OTP-Anmeldung per Telefon
```

**Turkish:**
```
🔧 Hata düzeltme güncellemesi v1.0.2
✅ Düzeltildi: Play Store'da Firebase kimlik doğrulama hatası
✅ Play Integrity doğrulama hatası giderildi
✅ Telefon OTP girişi daha güvenilir
```

---

## 🔧 Version 1.0.1 — Hotfix: Phone Login Fix
*(Play Store: What's New)*

**Version:** 1.0.1
**Build Number:** 4
**Release Date:** April 2026
**Type:** Hotfix / Patch

### English (Default)
*(Max 500 characters on Play Store)*

```
🔧 Bug Fix Update – v1.0.1

✅ Fixed phone number (SMS OTP) login not working
✅ Fixed "operation not allowed" error on sign-in
✅ Improved app verification for faster, more reliable OTP delivery
✅ Better support for debug testing builds

All existing features remain unchanged.
```

### 📋 Full Internal Release Notes (for your team)

#### 🐛 Bug Fixes in v1.0.1

**Firebase Phone Authentication — Critical Fix:**
- **Fixed:** SMS OTP login failing in closed testing with error:
  *"This operation is not allowed … SMS unable to be sent until this region enabled"*
- **Root cause:** `forceRecaptchaFlow: true` was hardcoded in **4 files**
  (`main.dart`, `mobile_login_controller.dart`, `seller_common_controller.dart`,
  `seller_enter_otp.dart`). This forced reCAPTCHA even in release builds where
  Play Integrity is available, causing Firebase to reject the app verification request.
- **Fix:** Changed all occurrences to `forceRecaptchaFlow: kDebugMode` — reCAPTCHA
  only in debug/emulator builds; Play Integrity used automatically in release builds.

**Firebase SHA Fingerprint Registration:**
- Added debug SHA-1 fingerprint to Firebase project (`waxxapp-7ab79`) and
  re-downloaded `google-services.json` to include both:
  - Release SHA-1: `8A:94:18:DE:E8:8F:0B:0A:40:F8:49:79:CB:2E:42:B1:47:3C:1D:A8` *(was already registered)*
  - Debug SHA-1: `18:81:C6:24:6C:D6:CF:CC:C6:2C:40:24:91:2E:64:0F:97:64:1A:C4` *(newly added)*

#### 📁 Files Changed
| File | Change |
|---|---|
| `pubspec.yaml` | Version bumped `1.0.0+2` → `1.0.1+4` |
| `lib/main.dart` | `forceRecaptchaFlow: true` → `kDebugMode` |
| `lib/View/UserLogin/mobile_login/controller/mobile_login_controller.dart` | `forceRecaptchaFlow: true` → `kDebugMode` |
| `lib/Controller/GetxController/seller/seller_common_controller.dart` | `forceRecaptchaFlow: true` → `kDebugMode` |
| `lib/View/MyApp/Seller/SellerAccount/seller_enter_otp.dart` | `forceRecaptchaFlow: true` → `kDebugMode` (resend OTP) |
| `android/app/google-services.json` | Added debug SHA-1 fingerprint |

#### ✅ Testing Verification (v1.0.1)
| Target | Method | Status |
|---|---|---|
| Closed Testing (Play Store) | Play Integrity | ✅ Fixed |
| Real device debug (`flutter run`) | reCAPTCHA + debug SHA | ✅ Works |
| Emulator (Google Play image) | reCAPTCHA + debug SHA | ✅ Works |
| Emulator (Google APIs image) | Firebase test numbers | ⚠️ Use test numbers |

---

### 🌍 Localized "What's New" Text (v1.0.1)

**Spanish:**
```
🔧 Actualización de corrección v1.0.1
✅ Solucionado: inicio de sesión con número de teléfono no funcionaba
✅ Corrección del error "operación no permitida" al iniciar sesión
✅ Entrega de OTP más rápida y confiable
```

**French:**
```
🔧 Mise à jour corrective v1.0.1
✅ Corrigé : connexion par numéro de téléphone ne fonctionnait pas
✅ Correction de l'erreur "opération non autorisée" à la connexion
✅ Livraison OTP plus rapide et fiable
```

**Arabic:**
```
🔧 تحديث إصلاح الأخطاء v1.0.1
✅ تم إصلاح: تسجيل الدخول برقم الهاتف لم يكن يعمل
✅ إصلاح خطأ "العملية غير مسموح بها" عند تسجيل الدخول
✅ تسليم OTP أسرع وأكثر موثوقية
```

**German:**
```
🔧 Fehlerbehebungs-Update v1.0.1
✅ Behoben: Anmeldung per Telefonnummer funktionierte nicht
✅ Behebung des Fehlers „Vorgang nicht erlaubt" bei der Anmeldung
✅ Schnellere und zuverlässigere OTP-Zustellung
```

**Turkish:**
```
🔧 Hata düzeltme güncellemesi v1.0.1
✅ Düzeltildi: Telefon numarasıyla giriş çalışmıyordu
✅ Giriş sırasında "işleme izin verilmiyor" hatası düzeltildi
✅ Daha hızlı ve güvenilir OTP iletimi
```


---

## 🚀 Version 1.0.0 — Initial Release
*(Play Store: What's New)*

### English (Default)
*(Max 500 characters on Play Store)*

```
🎉 Welcome to Waxx App – Version 1.0!

🛍️ Shop live, watch product reels & place auction bids
🎥 Watch sellers go LIVE and buy in real-time
📹 Discover products through short video reels
🔨 Bid on exclusive items in live auctions
🏪 Sellers: list products, go live & manage orders
💳 Multiple payment options (Card, Razorpay, Stripe, COD)
🌍 Available in 14+ languages
🔒 Secure phone OTP & Google/Apple sign-in

Download now & start exploring!
```

---

### 📋 Full Internal Release Notes (for your team)

**Version:** 1.0.0  
**Build Number:** 1  
**Release Date:** March 2026  
**Platform:** Android (Google Play Store)

#### ✅ Features Included in v1.0.0

**Authentication:**
- Phone number login with OTP verification
- Email & password login/registration
- Google Sign-In integration
- Apple Sign-In integration
- Demo login mode (for testing)
- Forgot password with OTP flow

**User (Buyer) Features:**
- Home page with new collections, flash sales, live selling section, "just for you" recommendations
- Product browsing by category with filter and search
- Product detail page with reviews and ratings
- Add to cart and checkout flow
- Multiple payment methods: Razorpay, Stripe, Flutterwave, Cash on Delivery
- Order tracking: Pending → Confirmed → Out for Delivery → Delivered
- Order cancellation
- Wishlist / Favorites
- User profile management
- Address management (add, edit, delete)
- Real-time chat with sellers
- Push notifications (order updates, messages, promotions)
- Follow/unfollow sellers
- Product sharing via Branch.io deep links
- Auction bidding with real-time updates

**Video & Live Features:**
- Short video Reels feed (TikTok-style)
- Like/comment on reels
- Live selling sessions via Zego (ZEGOCLOUD)
- Live auction during streams

**Seller Features:**
- Seller registration with document verification
- Product listing with multiple images and categories
- Edit and manage product catalog
- Live selling sessions
- Create and upload short promotional reels
- Order management: Pending, Confirmed, Out for Delivery, Delivered, Cancelled
- Earnings wallet with payout requests
- Bank account management
- Seller profile page visible to buyers
- Follower/following count

**App-wide Features:**
- Dark mode / Light mode toggle
- 14+ language support (English, Arabic, French, Spanish, German, Hindi, Korean, Chinese, Turkish, Indonesian, Russian, Portuguese, Italian, Swahili)
- Connectivity monitoring with "No Internet" dialog
- Firebase Crashlytics integration
- Branch.io deep linking
- Real-time Socket.io for live features

---

### 🌍 Localized "What's New" Text

**Spanish:**
```
🎉 ¡Bienvenido a Waxx App – Versión 1.0!
Compra en vivo, descubre reels de productos y haz pujas en subastas.
Vendedores: lista productos, transmite en vivo y gestiona pedidos.
Pagos seguros con múltiples métodos. ¡Disponible en 14+ idiomas!
```

**French:**
```
🎉 Bienvenue sur Waxx App – Version 1.0 !
Achetez en direct, découvrez des reels produits et participez aux enchères.
Vendeurs : listez vos produits, vendez en direct et gérez vos commandes.
Paiements sécurisés, disponible en 14+ langues !
```

**Arabic:**
```
🎉 مرحباً بك في Waxx App – الإصدار 1.0!
تسوّق مباشرةً، اكتشف ريلز المنتجات وشارك في المزادات.
للبائعين: أضف منتجاتك، ابث مباشرةً وأدر طلباتك.
دفع آمن، متاح بأكثر من 14 لغة!
```

**German:**
```
🎉 Willkommen bei Waxx App – Version 1.0!
Live einkaufen, Produkt-Reels entdecken und bei Auktionen mitbieten.
Verkäufer: Produkte listen, live gehen & Bestellungen verwalten.
Sichere Zahlung, verfügbar in 14+ Sprachen!
```

**Turkish:**
```
🎉 Waxx App'e Hoş Geldiniz – Sürüm 1.0!
Canlı alışveriş yapın, ürün reellerini keşfedin ve açık artırmalara katılın.
Satıcılar: ürün ekleyin, canlı yayın yapın, siparişleri yönetin.
Güvenli ödeme, 14+ dil desteği!
```

