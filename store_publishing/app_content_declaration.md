# App Content Declaration — Waxx App
## (For Google Play Console → Policy → App Content)

---

## 1. 🎯 APP CATEGORY
```
Category: Shopping
Tags: marketplace, live shopping, auctions, video reels, ecommerce
```

---

## 2. 👥 TARGET AUDIENCE & CONTENT RATING

### Target Audience
```
Age Group: Adults (18+)
Reason: Financial transactions, bank account management, seller business operations
```

### Content Rating Questionnaire Answers
*(Go to: Policy → App content → Content rating → Start questionnaire)*

| Question | Answer |
|----------|--------|
| Does the app contain violence? | No |
| Does the app contain sexual content? | No |
| Does the app contain profanity/crude language? | No |
| Does the app contain controlled substances? | No |
| Does the app contain gambling? | **Yes** — Auction/bidding feature |
| Does the app allow user-generated content? | **Yes** — Product reviews, reels, live streams |
| Does the app allow real-money transactions? | **Yes** — In-app purchases/orders |
| Does the app contain ads? | No |

**Expected Rating:** PEGI 18 / Everyone 10+ (ESRB) — likely **Teen or Mature** due to financial transactions and user-generated content.

---

## 3. 📞 DATA SAFETY (Play Console → Policy → App content → Data safety)

### Data Collected & Shared:

| Data Type | Collected? | Shared? | Purpose |
|-----------|------------|---------|---------|
| Name | ✅ Yes | With sellers (for orders) | Account, Orders |
| Email address | ✅ Yes | No | Account, Login |
| Phone number | ✅ Yes | No | Login (OTP) |
| Profile photo | ✅ Yes | Public (seller/buyer profile) | Profile |
| Device ID | ✅ Yes | Firebase/Analytics | Security, Analytics |
| Payment info | ✅ Yes (via gateway) | Payment processors | Purchases |
| Address | ✅ Yes | With sellers | Order delivery |
| App interactions | ✅ Yes | Analytics | App improvement |
| Crash logs | ✅ Yes | Firebase Crashlytics | Bug fixes |
| Photos/Videos | ✅ Yes | Public (product images, reels) | Product listing, Reels |
| Audio | ✅ Yes | Public (live stream audio) | Live streaming |
| Bank account info | ✅ Yes (sellers only) | Payment processor | Seller payouts |

### Is data encrypted in transit?
```
✅ Yes — HTTPS/TLS for all network requests
```

### Can users request data deletion?
```
✅ Yes — Contact support@waxxapp.com or via account settings
```

---

## 4. 🔐 PERMISSIONS DECLARATION

### Permissions & Justification:

| Permission | Declaration for Play Store |
|-----------|---------------------------|
| `CAMERA` | Required to take profile photos, product photos, and for live streaming |
| `RECORD_AUDIO` | Required for live selling streams and video reels with audio |
| `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES` | Required to upload product images and profile pictures from gallery |
| `READ_MEDIA_VIDEO` | Required to upload promotional video reels |
| `INTERNET` | Core functionality — all API calls, streaming, payments |
| `ACCESS_NETWORK_STATE` | Monitor connectivity to show "No Internet" warning |
| `RECEIVE_BOOT_COMPLETED` | For scheduling local notifications |
| `VIBRATE` | Haptic feedback for notifications and interactions |
| `READ_PHONE_STATE` | Required to get device identifier for security and fraud prevention |
| `POST_NOTIFICATIONS` | Send push notifications for orders and messages |

---

## 5. 💰 FINANCIAL FEATURES DECLARATION

```
✅ This app processes real-money transactions
✅ Payment methods: Credit/Debit Card, Razorpay, Stripe, Flutterwave, Cash on Delivery
✅ This app has a seller payout/wallet system
✅ This app contains an auction/bidding feature (real money)
```

**Play Store requires:**
- [ ] Declare financial features in App Content section
- [ ] Make sure your privacy policy covers financial data
- [ ] Comply with applicable financial regulations in your target countries

---

## 6. 📹 USER-GENERATED CONTENT DECLARATION

```
✅ This app contains user-generated content:
  - Product photos and descriptions (by sellers)
  - Short video reels (by sellers)
  - Live streaming video (by sellers)
  - Product reviews and ratings (by buyers)
  - Chat messages (between buyers and sellers)

Content moderation: Platform admin can remove violating content.
Users can report inappropriate content.
```

---

## 7. 🔑 LOGIN & ACCOUNT MANAGEMENT

```
✅ Account creation required: Yes
✅ Account deletion available: Yes (contact support or in-app settings)
✅ Sign-in methods:
   - Phone OTP
   - Email & Password
   - Google Sign-In
   - Apple Sign-In
   - Demo/Guest mode
```

---

## 8. 📋 GOVERNMENT ID / SELLER VERIFICATION

```
⚠️ IMPORTANT FOR PLAY STORE REVIEW:
This app requires sellers to upload government ID, address proof,
and registration certificates for business verification.
These documents are used ONLY for seller identity verification
and are handled securely as described in our Privacy Policy.
This is NOT required from regular buyers.
```

---

## 9. 🌐 STORE PRESENCE CHECKLIST

### Required Before Submission:
- [ ] App icon: 512×512 PNG (no alpha)
- [ ] Feature graphic: 1024×500 PNG or JPG
- [ ] Phone screenshots: minimum 2 (16:9 or 9:16)
- [ ] Short description (max 80 chars)
- [ ] Full description (max 4000 chars)
- [ ] Privacy policy URL (hosted and accessible)
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] Target audience set (18+)
- [ ] App category: Shopping

### Recommended:
- [ ] Tablet screenshots (7" and 10")
- [ ] Promo video (YouTube link, 30 seconds)
- [ ] Multiple language translations of store listing

---

## 10. 🚀 RELEASE TRACK RECOMMENDATION

For first release, use this order:
```
1. Internal Testing (your team — immediate)
2. Closed Testing / Beta (selected users — 1-2 weeks)
3. Production — Full rollout
```

This minimizes risk of issues on your first Play Store submission.
