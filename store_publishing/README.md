# 📦 Waxx App — Play Store Publishing Kit

All publishing content for **Waxx App** Google Play Store submission.

---

## 📁 Files in This Folder

| File | Purpose | Where to Use |
|------|---------|-------------|
| `privacy_policy.md` | Full Privacy Policy | Host on your website, paste URL in Play Console |
| `terms_of_service.md` | Terms of Service | Host on your website |
| `play_store_listing.md` | App Name, Short & Full Description, Keywords | Play Console → Store presence → Main store listing |
| `release_notes.md` | What's New text (5 languages) | Play Console → Release → What's new |
| `app_content_declaration.md` | Data Safety, Permissions, Content Rating guide | Play Console → Policy → App content |

---

## ✅ Publishing Checklist

### 🔑 Before You Build
- [x] `android/app/build.gradle` — release signing configured
- [x] `android/gradle.properties` — AGP DSL fix applied
- [ ] `android/app/key.properties` — fill in your keystore passwords
- [ ] `android/app/waxx_release.jks` — generate your keystore

### 🏗️ Build
```bash
# 1. Generate keystore (one-time)
keytool -genkey -v -keystore android/app/waxx_release.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias waxx_key

# 2. Fill android/app/key.properties with your passwords

# 3. Build release AAB
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 🌐 Host Your Legal Pages
You MUST host these on a public URL before submitting:
- [ ] Privacy Policy → `https://yourdomain.com/privacy-policy`
- [ ] Terms of Service → `https://yourdomain.com/terms`

> **Free hosting options:** GitHub Pages, Netlify, Notion (public page), Google Sites

### 🎨 App Assets to Prepare
- [ ] **App Icon** — 512×512 PNG (no transparency)
- [ ] **Feature Graphic** — 1024×500 PNG or JPG
- [ ] **Screenshots** — at least 2 phone screenshots (recommended: 5-8)
  - Recommended sizes: 1080×1920 or 1080×2340

### 📋 Play Console Steps
1. [ ] Create app at [play.google.com/console](https://play.google.com/console)
2. [ ] Fill store listing (use `play_store_listing.md`)
3. [ ] Upload screenshots + feature graphic + icon
4. [ ] Set pricing: **Free**
5. [ ] Set category: **Shopping**
6. [ ] Complete content rating questionnaire (use `app_content_declaration.md`)
7. [ ] Complete data safety form (use `app_content_declaration.md`)
8. [ ] Add privacy policy URL
9. [ ] Set target audience: **18+**
10. [ ] Upload `app-release.aab` → Internal Testing first
11. [ ] Review & publish

---

## 📌 Quick Reference

### App Info
| Field | Value |
|-------|-------|
| App Name | Waxx App – Live Shopping & Deals |
| Package ID | com.waxxapp |
| Version | 1.0.0 (build 1) |
| Min Android | 7.0 (API 24) |
| Category | Shopping |
| Price | Free |
| Target Age | 18+ |

### Short Description (80 chars)
```
Shop live, discover reels & deals. Buy, sell & bid in one social marketplace!
```

### Support Contacts
```
Email: support@waxxapp.com
Website: https://waxxapp.com
```

---

> ⚠️ Remember to replace `support@waxxapp.com` and `https://waxxapp.com` 
> with your actual email and website throughout all documents.
