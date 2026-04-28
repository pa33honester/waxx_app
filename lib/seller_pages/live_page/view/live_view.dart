import 'dart:async';
import 'dart:developer';
import 'package:waxxapp/ApiModel/user/GetLiveSellerListModel.dart';
import 'package:waxxapp/ApiService/seller/live_seller_for_selling_service.dart';
import 'package:waxxapp/ApiService/user/fetch_live_chat_history_service.dart';
import 'package:waxxapp/custom/loading_ui.dart';
import 'package:waxxapp/seller_pages/live_page/controller/live_controller.dart';
import 'package:waxxapp/seller_pages/live_page/widget/live_widget.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:waxxapp/utils/database.dart';


class LivePageView extends StatefulWidget {
  const LivePageView({
    super.key,
    required this.liveUserList,
    required this.isHost,
    required this.isActive,
  });

  final LiveSeller liveUserList;
  final bool isHost;
  final bool isActive;

  @override
  State<LivePageView> createState() => _LivePageViewState();
}

class _LivePageViewState extends State<LivePageView> with RouteAware {
  @override
  void didPush() {
    SocketServices.registerLiveScreen(); // Start socket when entering
  }

  @override
  void didPop() {
    SocketServices.unregisterLiveScreen(); // Clean up when exiting
  }

  LiveController liveController = Get.put(LiveController());
  String currentPageUserId = "";
  RxBool isLoading = false.obs;
  Timer? _initTimer;
  Timer? _heartbeatTimer;
  bool _isInitialized = false;

  // Zego variables
  String localUserID = Database.loginUserId;
  String localUserName = "Hello Developer";
  String roomID = "";

  Widget? localView;
  int? localViewID;
  Widget? remoteView;
  int? remoteViewID;
  // Stream id we asked the engine to play is persisted on [LiveController.remoteStreamID]
  // so the buyer-side exit path can stopPlayingStream + destroyCanvasView (without that
  // teardown the native audio/video pipeline leaks for the rest of the process and the
  // next loginRoom often can't attach a fresh stream) AND so the right-column Sound
  // Mute button can call mutePlayStreamAudio against the correct id.

  @override
  void initState() {
    log("Live Page InitState call>>>>>>>");
    log("Socket >>>>>>>>>>>>${socket?.id ?? ''}");
    log("Socket >>>>>>>>>>>>${socket?.connected ?? ''}");
    log("Socket >>>>>>>>>>>>${socket?.query ?? ''}");
    super.initState();
    if (SocketServices.mainLiveComments.isNotEmpty) {
      SocketServices.mainLiveComments.clear();
    }

    // Replay any persisted chat backlog so a buyer joining mid-stream
    // sees what was already said. Fire-and-forget; the socket starts
    // appending new comments shortly after, and chronological order is
    // preserved because the history is sorted oldest-first server-side.
    final historyId = widget.liveUserList.liveSellingHistoryId ?? "";
    if (historyId.isNotEmpty && !widget.isHost) {
      FetchLiveChatHistoryService.fetch(liveSellingHistoryId: historyId).then((rows) {
        if (!mounted || rows.isEmpty) return;
        SocketServices.mainLiveComments.addAll(rows);
      });
    }

    _setupController();
    if (widget.isActive) {
      liveController.image = widget.liveUserList.image ?? "";
      liveController.name = "${widget.liveUserList.firstName ?? ""} ${widget.liveUserList.lastName ?? ""}";
      liveController.userName = widget.liveUserList.firstName ?? "";
      roomID = widget.liveUserList.liveSellingHistoryId ?? "";
      log("Live Page InitState call>>>>>>>");
      SocketServices.onGetUserLiveDetails(
        liveHistoryId: widget.liveUserList.liveSellingHistoryId ?? "",
      );
      log("Live Page Init  widget.liveUserList:");
      800.milliseconds.delay().then((value) {
        log("Live Page Init  widget.liveUserList: ${widget.liveUserList.toJson()}");
        log("Live Page Init  widget.updatedLiveUserList: ${liveController.updatedLiveUserList?.toJson()}");
        _startInitialization(liveUserList: liveController.updatedLiveUserList ?? widget.liveUserList);
      });
    } else {
      _startInitialization(liveUserList: liveController.updatedLiveUserList ?? widget.liveUserList);
    }
  }

  void _setupController() {
    // final controllerTag = "live_${widget.liveUserList.liveHistoryId}";

    if (Get.isRegistered<LiveController>()) {
      liveController = Get.find<LiveController>();
    } else {
      liveController = Get.put(
        LiveController(),
      );
    }
  }

  @override
  void didUpdateWidget(LivePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (SocketServices.mainLiveComments.isNotEmpty) {
      SocketServices.mainLiveComments.clear();
    }

    if (widget.isActive && !oldWidget.isActive && !_isInitialized) {
      log("Live Page Init  widget.liveUserList: ${widget.liveUserList.toJson()}");
      log("Live Page Init  widget.updatedLiveUserList: ${liveController.updatedLiveUserList?.toJson()}");
      if (!widget.isHost) {
        liveController.image = widget.liveUserList.image ?? "";
        liveController.name = "${widget.liveUserList.firstName ?? ""} ${widget.liveUserList.lastName ?? ""}" ?? "";
        liveController.userName = widget.liveUserList.firstName ?? "";

        SocketServices.onGetUserLiveDetails(
          liveHistoryId: widget.liveUserList.liveSellingHistoryId ?? "",
        );

        800.milliseconds.delay().then((value) {
          log("Live Page Init  widget.liveUserList: ${widget.liveUserList.toJson()}");
          log("Live Page Init  widget.updatedLiveUserList: ${liveController.updatedLiveUserList?.toJson()}");
          _startInitialization(liveUserList: liveController.updatedLiveUserList ?? widget.liveUserList);
        });
      }
    } else if (!widget.isActive && oldWidget.isActive) {
      _pauseStream();
    }
  }

  void _startInitialization({LiveSeller? liveUserList}) async {
    if (_isInitialized) return;

    isLoading.value = true;
    roomID = liveUserList?.liveSellingHistoryId ?? "";

    // Set controller data
    liveController.roomId = liveUserList?.liveSellingHistoryId ?? "";
    liveController.userId = liveUserList?.id ?? "";
    liveController.sellerId = liveUserList?.sellerId ?? "";

    liveController.Id = liveUserList?.id ?? "";
    liveController.liveType = liveUserList?.liveType ?? 0;
    liveController.isHost = widget.isHost;
    liveController.liveSelectedProducts = liveUserList?.selectedProducts ?? [];
    liveController.businessName = liveUserList?.businessName ?? "";
    liveController.businessTag = liveUserList?.businessTag ?? "";

    log("message>>>>>>>>>${liveController.isHost}");
    log("message>>>>>>>>>liveController.liveType${liveController.liveType}");

    // Initialize Zego
    await _initializeZego();

    if (mounted) {
      isLoading.value = false;
      _isInitialized = true;
    }
  }

  Future<void> _initializeZego() async {
    log("Live Page Init${widget.liveUserList.sellerId}");
    try {
      _startListenEvent();
      await _loginRoom();
      log("Live Page Init${widget.liveUserList.sellerId}");
      if (widget.isHost) {
        liveController.onChangeTime();
        _startHeartbeat();
      } else {
        liveController.onChangeTime();
        // Set timeout for remote view
        Timer(Duration(seconds: 8), () {
          if (mounted && remoteView == null && widget.isActive) {
            log('Remote view timeout for room: $roomID');
            Get.snackbar(
              'Stream unavailable',
              'This live stream isn\'t broadcasting right now. Please try again later.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.black.withValues(alpha: 0.85),
              colorText: AppColors.white,
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            );
            // Give the snackbar a moment to render before popping the page.
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted && remoteView == null) Get.back();
            });
          }
        });
      }

      WakelockPlus.enable();
    } catch (e) {
      log('Zego initialization error: $e');
      if (mounted) {
        isLoading.value = false;
      }
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    final sellerId = widget.liveUserList.sellerId ?? liveController.sellerId;
    if (sellerId.isEmpty) return;
    // Fire once immediately so the row's lastHeartbeatAt is fresh, then every 30s.
    LiveHeartbeatApi.ping(sellerId: sellerId);
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      LiveHeartbeatApi.ping(sellerId: sellerId);
    });
  }

  void _pauseStream() {
    // Pause the stream when not active to save resources
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.mutePlayStreamVideo("${roomID}_*", true);
      ZegoExpressEngine.instance.mutePlayStreamAudio("${roomID}_*", true);
    }
  }

  void _resumeStream() {
    // Resume the stream when becoming active
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.mutePlayStreamVideo("${roomID}_*", false);
      ZegoExpressEngine.instance.mutePlayStreamAudio("${roomID}_*", false);
    }
  }

  @override
  void dispose() {
    log("Live Page Dispose${widget.liveUserList.sellerId}");
    _initTimer?.cancel();
    _heartbeatTimer?.cancel();

    if (_isInitialized) {
      _cleanupZego();
    }

    // Don't delete the controller here as it might be used by other instances
    super.dispose();
  }

  void _cleanupZego() {
    try {
      _stopListenEvent();
      // Buyer-side: tear down the play stream + canvas BEFORE logoutRoom.
      // logoutRoom alone leaves the native player/audio sink alive, which
      // (a) leaks the emulator audio HAL into a `pcm_writei ... I/O error`
      // spam at ~10 Hz, and (b) makes a subsequent loginRoom unable to
      // attach a fresh stream — buyers exit/rejoin and see a black page.
      if (!widget.isHost && liveController.remoteStreamID != null) {
        _stopPlayStream(liveController.remoteStreamID!);
      }
      _logoutRoom();
      SocketServices.onLiveRoomExit(isHost: widget.isHost, liveHistoryId: roomID);
      liveController.isLivePage = false;
      WakelockPlus.disable();
    } catch (e) {
      log('Zego cleanup error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Container(
          height: Get.height,
          width: Get.width,
          color: AppColors.black,
          child: LiveUi(
            liveScreen: widget.isHost ? (localView ?? const SizedBox.shrink()) : remoteView ?? LoadingUi(),
            isLoading: isLoading,
            isHost: widget.isHost,
            liveRoomId: roomID,
            liveUserId: liveController.userId,
            liveUserImage: liveController.image,
          ),
        ),
      ),
    );
  }

  // Zego methods
  Future<ZegoRoomLoginResult> _loginRoom() async {
    final user = ZegoUser(localUserID, localUserName);
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()..isUserStatusNotify = true;

    // Defensive logout. The Zego engine is a singleton and remembers the
    // last room it was logged into across LivePageView instances (deep-link
    // taps from a backgrounded app, route stacks where the previous live
    // page didn't dispose, etc). Calling loginRoom again for the same
    // roomID without logging out first returns errorCode 1002001 and the
    // viewer never receives a stream — the buyer gets stuck on the
    // loading spinner. Awaiting logoutRoom is a no-op when we weren't
    // logged in, so it's safe in the cold-start path too.
    await ZegoExpressEngine.instance.logoutRoom(roomID);

    return ZegoExpressEngine.instance.loginRoom(roomID, user, config: roomConfig).then((ZegoRoomLoginResult loginRoomResult) {
      debugPrint('loginRoom: errorCode:${loginRoomResult.errorCode}, extendedData:${loginRoomResult.extendedData}');
      if (loginRoomResult.errorCode == 0) {
        if (widget.isHost) {
          _startPreview();
          _startPublish();
          SocketServices.liveWatchCount.value = 0;
          log("Live Page Init>>>>>>>> loginUserId: ${Database.loginUserId}");
          SocketServices.onLiveRoomConnect(loginUserId: Database.loginUserId, liveHistoryId: roomID);
        } else {
          SocketServices.onAddView(loginUserId: Database.loginUserId, liveHistoryId: roomID);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login room failed: ${loginRoomResult.errorCode}')));
        }
      }
      return loginRoomResult;
    });
  }

  Future<ZegoRoomLogoutResult> _logoutRoom() async {
    _stopPreview();
    _stopPublish();
    return ZegoExpressEngine.instance.logoutRoom(roomID);
  }

  void _startListenEvent() {
    ZegoExpressEngine.onRoomUserUpdate = (roomID, updateType, List<ZegoUser> userList) {
      debugPrint('onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
    };

    ZegoExpressEngine.onRoomStreamUpdate = (roomID, updateType, List<ZegoStream> streamList, extendedData) {
      debugPrint('onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          _startPlayStream(stream.streamID);
        }
      } else {
        for (final stream in streamList) {
          _stopPlayStream(stream.streamID);
        }
      }
    };

    ZegoExpressEngine.onRoomStateUpdate = (roomID, state, errorCode, extendedData) {
      debugPrint('onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };

    ZegoExpressEngine.onPublisherStateUpdate = (streamID, state, errorCode, extendedData) {
      debugPrint('onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };
  }

  void _stopListenEvent() {
    if (!widget.isHost) {
      SocketServices.onLessView(loginUserId: Database.loginUserId, liveHistoryId: roomID);
    }

    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
  }

  Future<void> _startPreview() async {
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      localViewID = viewID;
      ZegoCanvas previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
    }).then((canvasViewWidget) {
      if (mounted) {
        log('localViewID:>>>>>>> $localViewID');
        setState(() => localView = canvasViewWidget);
      }
    });
  }

  Future<void> _stopPreview() async {
    ZegoExpressEngine.instance.stopPreview();
    if (localViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
      localViewID = null;
      localView = null;
    }
  }

  Future<void> _startPublish() async {
    String streamID = '${roomID}_${localUserID}_call';
    return ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  Future<void> _stopPublish() async {
    return ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<void> _startPlayStream(String streamID) async {
    liveController.remoteStreamID = streamID;
    // If the user toggled Sound Mute before the stream actually started
    // playing, honour that preference now so we don't leak audio for a beat.
    if (!widget.isHost && liveController.isStreamMuted.value) {
      ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, true);
    }
    await ZegoExpressEngine.instance.createCanvasView((viewID) {
      remoteViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
      ZegoPlayerConfig config = ZegoPlayerConfig.defaultConfig();
      config.resourceMode = ZegoStreamResourceMode.Default;
      ZegoExpressEngine.instance.enableCamera(true, channel: ZegoPublishChannel.Main);
      ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas, config: config);
    }).then((canvasViewWidget) {
      if (mounted) {
        setState(() => remoteView = canvasViewWidget);
      }
    });
  }

  Future<void> _stopPlayStream(String streamID) async {
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (liveController.remoteStreamID == streamID) {
      liveController.remoteStreamID = null;
    }
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
      if (mounted) {
        setState(() {
          remoteViewID = null;
          remoteView = null;
        });
      }
    }
  }
}
