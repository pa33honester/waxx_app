# Release Notes — Waxx App

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
