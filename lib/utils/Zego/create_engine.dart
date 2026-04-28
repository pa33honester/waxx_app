import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

import 'key_center.dart';

Future<void> createEngine() async {
  print("appSign:::::ddd$appSign");
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
      appID,
      ZegoScenario.Broadcast,
      appSign: appSign,
    ));
    // Bump publish quality to 720p (1280x720 @ ~1.5 Mbps) so the seller's
    // broadcast doesn't fall back to the SDK default ~360p. Matches the
    // resolution band TikTok / IG Live use; the bandwidth cost is borne by
    // the seller, which is acceptable for a live-selling product.
    await ZegoExpressEngine.instance.setVideoConfig(
      ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset720P),
    );
  } catch (e) {
    log("createEngine::::ZegoExpressEngine ::::::$e");
  }
}
