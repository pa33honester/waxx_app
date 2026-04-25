# Release Notes — Waxx App

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

