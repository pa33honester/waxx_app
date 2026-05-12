# Changelog

All notable changes to the Waxxapp Flutter app are documented here.

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
