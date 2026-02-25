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
}catch(e){
  log("createEngine::::ZegoExpressEngine ::::::$e");
}
}
