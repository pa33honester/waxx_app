# Release Notes — Waxx App

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

