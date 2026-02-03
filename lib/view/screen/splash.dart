import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hj_app/controller/loginAndRegisterControl.dart';
import 'package:hj_app/controller/settingController.dart';
import 'package:hj_app/global/globalUI.dart';
import 'package:hj_app/view/Login/loginUserNameScreen.dart';
import 'package:hj_app/view/screen/mainView.dart';
import 'package:video_player/video_player.dart';

class Splash extends StatefulWidget {
  final String version;

  const Splash({super.key, required this.version});

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  final LoginAndRegisterControl _loginAndRegisterControl = Get.put(
    LoginAndRegisterControl(),
  );
  final SettingController _settingController = Get.put(SettingController());

  VideoPlayerController? _controller;

  late Future googleFontsPending;

  @override
  void initState() {
    super.initState();

    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.getFont('Roboto'),
      GoogleFonts.getFont('Almarai'),
    ]);

    _initVideoController();

    // Observe app lifecycle so we can request ATT when the app is in foreground.
    WidgetsBinding.instance.addObserver(this);

    // As a fallback, attempt requesting ATT once after first frame (will be no-op
    // if the status is already determined). The reliable request happens on resume.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _maybeRequestTracking(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Request ATT when the app resumes (visible to the user).
      _maybeRequestTracking();
    }
  }

  Future<void> _maybeRequestTracking() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('ATT current status: $status');

      if (status == TrackingStatus.notDetermined) {
        debugPrint('ATT: requesting tracking authorization...');
        final newStatus =
            await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('ATT: new status => $newStatus');
      } else {
        debugPrint('ATT: no request needed (status != notDetermined)');
      }
    } catch (e, st) {
      debugPrint('ATT request error: $e');
      debugPrint('$st');
    }
  }

  Future<void> _initVideoController() async {
    // Create a new controller and initialize it safely.
    _controller = VideoPlayerController.asset(
      'assets/images/splash.mp4',
      viewType: VideoViewType.platformView,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );

    try {
      await _controller?.initialize();
      if (!mounted) return;
      setState(() {});
      _controller
        ?..setLooping(true)
        ..setVolume(0)
        ..play();
    } catch (e) {
      // Initialization can fail on some devices; log for debugging but keep the app alive.
      debugPrint('Splash video init error: $e');
    }
  }

  Future<void> _disposeVideoController() async {
    try {
      if (_controller?.value.isPlaying ?? false) {
        await _controller?.pause();
      }
    } catch (_) {}

    try {
      await _controller?.dispose();
    } catch (_) {}

    _controller = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: (_controller != null && _controller!.value.isInitialized)
                ? FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: (_controller!.value.size.width),
                      height: (_controller!.value.size.height),
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : Container(),
          ),
          Opacity(
            opacity: 0.3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: themeModeValue == 'dark'
                        ? Color.fromARGB(221, 9, 13, 11)
                        : Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                color: themeModeValue == 'dark'
                    ? blackColor
                    : Colors.transparent,
              ),
            ),
          ),
          FutureBuilder(
            future: googleFontsPending,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              return SizedBox.expand(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            _settingController.changeLanguage();
                            setState(() {});
                          },
                          child: Opacity(
                            opacity: 0.7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 20,
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  mainAxisAlignment: language == 'en'
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/world.png',
                                      width: 24,
                                      height: 24,
                                      color: Colors.grey[800],
                                    ),
                                    SizedBox(width: 4),
                                    AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      style: (language == 'en')
                                          ? GoogleFonts.roboto(
                                              fontSize: 18,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w900,
                                            )
                                          : GoogleFonts.almarai(
                                              fontSize: 18,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w900,
                                            ),
                                      child: Text(
                                        language.toUpperCase(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * .14),
                      Image.asset(
                        'assets/images/hj.png',
                        width: Get.width * .2,
                      ),
                      SizedBox(height: Get.height * .02),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        child: Text('Hassan Jameel Motors'),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.almarai(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        child: Text('حسن جميل للسيارات'),
                      ),
                      SizedBox(height: Get.height * .1),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white30,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: Get.width * .15,
                              vertical: Get.height * .015,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // Dispose the video before navigating to avoid playing or
                          // accessing a disposed controller while another route is active.
                          await _disposeVideoController();
                          await Get.to(LoginUserName());
                          // Reinitialize the splash video after returning.
                          await _initVideoController();
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: (language == 'en')
                              ? GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                )
                              : GoogleFonts.almarai(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          child: Text('signIn'.tr),
                        ),
                      ),
                      SizedBox(height: Get.height * .015),
                      TextButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.white, width: 1),
                          ),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal:
                                  Get.width * .15 +
                                  (language == 'en' ? -2 : -2),
                              vertical: Get.height * .015,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await _disposeVideoController();
                          await _loginAndRegisterControl.getUserAccountTypes(
                            'numberPhone'.tr,
                            false,
                          );
                          await _initVideoController();
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: (language == 'en')
                              ? GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                )
                              : GoogleFonts.almarai(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          child: Text('createAnAccount'.tr),
                        ),
                      ),
                      SizedBox(height: Get.height * .01),
                      TextButton(
                        onPressed: () {
                          Get.offAll(MainView());
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: (language == 'en')
                              ? GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.white,
                                )
                              : GoogleFonts.almarai(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          child: Text('skip'.tr),
                        ),
                      ),
                      SizedBox(height: Get.height * .05),
                      // if (false)
                      //   Expanded(
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           '${'version'.tr} ${widget.version}',
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: Get.mediaQuery.padding.bottom +
                      //               Get.height * .05,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
