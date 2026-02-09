import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/journify_controller.dart';
import 'dart:async'; // Add Timer import
import 'package:hj_app/global/globalUrl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global/globalUI.dart';
import 'widgetWebView.dart';
import '../Login/loginUserNameScreen.dart';
import 'mainView.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class GlobalWebView extends StatefulWidget {
  final String url;
  final bool isStandalone;

  const GlobalWebView(this.url, {super.key, this.isStandalone = true});

  @override
  State<StatefulWidget> createState() => _GlobalWebViewState();
}

class _GlobalWebViewState extends State<GlobalWebView> {
  int showErrorPage = 0;
  bool isLoading = true;
  bool isWebViewReady = false;
  bool isWebViewVisible = false;
  InAppWebViewController? _webViewController;
  // Keep track of last navigation base (scheme+host+path) to detect loops
  String? _lastNavigationBase;
  int _sameNavigationCount = 0;
  final int _sameNavigationThreshold = 9;
  // Fallback timer to ensure WebView is shown if appReady signal is missed
  // ignore: unused_field
  Timer? _fallbackTimer;

  void _showWebView() {
    if (mounted && (isLoading || !isWebViewVisible)) {
      debugPrint("Showing WebView via signal or fallback");
      _fallbackTimer?.cancel();
      setState(() {
        isLoading = false;
        isWebViewVisible = true;
      });
    }
  }

  void initStateAsync() async {
    // Don't check connection upfront to avoid false positives.
    // Let the WebView try to load and fail if there's no internet.
    showErrorPage = 0;
    setState(() {});
  }

  @override
  void initState() {
    debugPrint('To be load url => ${widget.url}');
    super.initState();
    initStateAsync();
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget main = showErrorPage == 0
        ? SafeArea(
            bottom: widget.isStandalone,
            right: false,
            left: false,
            child: Stack(
              children: [
                Container(
                  color: themeModeValue == 'dark' ? darkColor : Colors.white,
                ),
                Obx(
                  () => Visibility(
                    visible: isWebViewVisible,
                    maintainState: true,
                    child: InAppWebView(
                      key: ValueKey(
                        '$language-$themeModeValue-${settingsVersion.value}',
                      ),
                      initialSettings: InAppWebViewSettings(
                        useShouldOverrideUrlLoading: true,
                        cacheEnabled: true,
                        supportZoom: false,
                        verticalScrollBarEnabled: false,
                        horizontalScrollBarEnabled: false,
                        useOnDownloadStart: true,
                        javaScriptEnabled: true,
                        domStorageEnabled: true,
                        databaseEnabled: true,
                        useShouldInterceptRequest: true,
                        mediaPlaybackRequiresUserGesture: false,
                        underPageBackgroundColor: themeModeValue == 'dark'
                            ? darkColor
                            : Colors.white,
                        allowUniversalAccessFromFileURLs: true,
                        useHybridComposition: true,
                      ),
                      initialUrlRequest: URLRequest(
                        url: WebUri.uri(
                          (() {
                            final uri = Uri.parse(widget.url);
                            final queryParams = Map<String, String>.from(
                              uri.queryParameters,
                            );
                            queryParams['theme'] = themeModeValue == 'light'
                                ? 'white'
                                : 'dark';
                            return uri.replace(queryParameters: queryParams);
                          })(),
                        ),
                      ),
                      onDownloadStartRequest: (controller, request) async {
                        debugPrint(
                          'Download requested: ' + request.url.toString(),
                        );
                        try {
                          await launchUrl(
                            request.url,
                            mode: LaunchMode.platformDefault,
                          );
                        } catch (e) {
                          debugPrint('Failed to launch download URL: $e');
                        }
                      },
                      // The onLoadStart callback is triggered when the page starts loading.
                      onLoadStart: (controller, url) async {
                        if (mounted) {
                          setState(() {
                            isWebViewReady = true;
                          });
                        }
                      },
                      // The onLoadStop callback is triggered when the page has finished loading.
                      onLoadStop: (controller, url) async {
                        if (mounted) {
                          // Add a small delay to ensure the page is fully painted/rendered
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                          if (mounted) {
                            // Start fallback timer when page finishes loading
                            // If React app is healthy, it should send appReady 'soon'
                            // changing from 800ms delay to waiting for signal with 10s fallback
                            _fallbackTimer?.cancel();

                            // Dynamic fallback duration based on page type
                            // Default is 60ms (very fast) if we trust the page to render quickly
                            // Or longer if we want to wait for the signal
                            int fallbackDuration = 4000;

                            if (widget.url.contains('/news')) {
                              fallbackDuration = 60;
                            } else if (widget.url.contains('/home')) {
                              fallbackDuration = 2000;
                            } else if (widget.url.contains('/cart')) {
                              fallbackDuration = 1000;
                            }

                            _fallbackTimer = Timer(
                              Duration(milliseconds: fallbackDuration),
                              () {
                                debugPrint(
                                  "Fallback timer triggered - showing WebView",
                                );
                                _showWebView();
                              },
                            );
                          }
                        }
                      },
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                            return ServerTrustAuthResponse(
                              action: ServerTrustAuthResponseAction.PROCEED,
                            );
                          },
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;

                        // Handler for React App Ready Signal
                        controller.addJavaScriptHandler(
                          handlerName: 'appReady',
                          callback: (args) {
                            debugPrint("Received appReady signal from React");
                            _showWebView();
                          },
                        );

                        // Make the WebView visible as soon as it's created so we
                        // don't show a permanent white overlay if the page takes
                        // long or never fires onLoadStop on some iOS redirects.
                        controller.addJavaScriptHandler(
                          handlerName: 'journifyBridge',
                          callback: (args) async {
                            // args is List<dynamic>. We'll use args[0] as the message.
                            if (args.isEmpty)
                              return {"ok": false, "error": "no_args"};

                            final dynamic raw = args[0];
                            if (raw is! Map)
                              return {"ok": false, "error": "arg0_not_object"};

                            final current = await controller
                                .getUrl(); // WebUri?
                            final uri = current != null
                                ? Uri.tryParse(current.toString())
                                : null;

                            final journifyCtrl =
                                Get.find<JournifyBridgeController>();
                            return await journifyCtrl.handleFromWeb(
                              message: raw.cast<String, dynamic>(),
                              currentUrl: uri,
                            );
                          },
                        );
                        if (Platform.isIOS && mounted) {
                          setState(() {
                            isWebViewReady = true;
                            // isWebViewVisible = true; // Wait for appReady on iOS too
                          });
                        }
                      },
                      onCreateWindow:
                          (
                            InAppWebViewController controller,
                            CreateWindowAction createWindowAction,
                          ) async {
                            debugPrint("=== CREATE WINDOW DETECTED ===");

                            // Specifically handle _blank targets
                            if (createWindowAction.targetFrame.isBlank ??
                                false) {
                              // Show options to user
                              launchUrl(
                                createWindowAction.request.url!,
                                mode: LaunchMode.externalApplication,
                              );

                              return true; // We handled it
                            }

                            return false; // Let system handle other targets
                          },
                      onConsoleMessage: (controller, consoleMessage) {
                        debugPrint(
                          'WebView console (${consoleMessage.messageLevel}): ${consoleMessage.message}',
                        );
                      },
                      onProgressChanged: (controller, progress) async {
                        // progress is 0..100
                        if (mounted) {
                          if (progress >= 100) {
                            // Do nothing here, wait for onLoadStop -> fallback or appReady signal
                            // We don't want to show it just because progress is 100%
                            // We wait for the specific component ready signal
                          }
                        }
                      },
                      onWebContentProcessDidTerminate:
                          (InAppWebViewController controller) async {
                            debugPrint(
                              'WebView content process terminated — reloading',
                            );
                            FirebaseCrashlytics.instance.log(
                              'WebView content process terminated for ${widget.url}, reloading',
                            );
                            // Try a reload once to recover from web content process termination.
                            try {
                              await controller.reload();
                            } catch (e) {
                              debugPrint(
                                'Reload failed after content termination: $e',
                              );
                              if (mounted) {
                                setState(() {
                                  showErrorPage = 2;
                                });
                              }
                            }
                          },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        final WebUri uri = navigationAction.request.url!;
                        final isBlank =
                            navigationAction.targetFrame?.isBlank ?? false;

                        debugPrint(
                          'Navigating to URL: ${uri.toString()}, isBlank: $isBlank',
                        );

                        // If the navigation is intended for a new window (target=_blank),
                        // open externally to avoid in-app loops.
                        if (isBlank) {
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                          return NavigationActionPolicy.CANCEL;
                        }

                        // Normalize by comparing the base (scheme+host+path) and ignore query params
                        String normalizeBase(String url) {
                          try {
                            final parsed = Uri.parse(url);
                            return parsed
                                .replace(query: '')
                                .removeFragment()
                                .toString();
                          } catch (e) {
                            return url;
                          }
                        }

                        final navBase = normalizeBase(uri.toString());
                        final widgetBase = normalizeBase(widget.url);

                        // If nav target is effectively the same base as the current widget URL,
                        // allow it (this prevents pushes for theme or query param changes).
                        if (navBase == widgetBase) {
                          _lastNavigationBase = navBase;
                          _sameNavigationCount = 0;
                          return NavigationActionPolicy.ALLOW;
                        }

                        // Detect repeated navigations to the same base (possible redirect loop).
                        if (_lastNavigationBase == navBase) {
                          _sameNavigationCount++;
                          if (_sameNavigationCount >=
                              _sameNavigationThreshold) {
                            debugPrint(
                              'Detected potential redirect loop for $navBase — cancelling navigation',
                            );
                            // As a fallback, open externally to break loop and cancel in-app navigation.
                            try {
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              // ignore
                            }
                            return NavigationActionPolicy.CANCEL;
                          }
                        } else {
                          _lastNavigationBase = navBase;
                          _sameNavigationCount = 1;
                        }

                        final urlStr = uri.toString();

                        if ('about:blank' == urlStr) {
                          return NavigationActionPolicy.CANCEL;
                        } else if (urlStr.contains('/login')) {
                          Get.to(const LoginUserName());
                          return NavigationActionPolicy.CANCEL;
                        } else if (urlStr.contains('/goBack')) {
                          await goBack(false);
                          return NavigationActionPolicy.CANCEL;
                        } else if (urlStr.contains('/home')) {
                          if (widget.isStandalone) {
                            Get.offAll(const MainView());
                            return NavigationActionPolicy.CANCEL;
                          }
                          return NavigationActionPolicy.ALLOW;
                        } else if (urlStr.contains('/store/logout')) {
                          // Allow normal navigation logging out within the WebView
                          return NavigationActionPolicy.ALLOW;
                        } else if (urlStr.contains('/store')) {
                          if (!widget.isStandalone) {
                            // If we are in the store tab, allow internal navigation
                            return NavigationActionPolicy.ALLOW;
                          }
                          // Otherwise switch to main tab
                          Get.offAll(const MainView(navigatorTo: 1));
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (urlStr.contains('/cart/carCheckout/')) {
                          Get.to(
                            GlobalWebView(urlStr),
                            preventDuplicates: false,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (urlStr.contains('/shareLink/')) {
                          var urlShare = urlStr.replaceAll('/shareLink/', '');
                          SharePlus.instance.share(ShareParams(text: urlShare));
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (urlStr.contains('hassanjameel.com.sa') ||
                            urlStr.contains('google.com') ||
                            urlStr.contains('maps.app.goo.gl')) {
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (urlStr.contains(
                          'https://secure.paytabs.sa/payment/request/invoice/',
                        )) {
                          Get.to(WidgetWebViewWithAppBar(urlStr));
                          return NavigationActionPolicy.CANCEL;
                        }

                        // HYBRID NAVIGATION LOGIC:
                        // If this is a standalone view (e.g. we pushed this view from a tab),
                        // we want to navigate INTERNALLY to keep specific task depth shallow (max 2).
                        if (widget.isStandalone) {
                          return NavigationActionPolicy.ALLOW;
                        }

                        // If this is a TAB view (isStandalone = false), we push a NEW GlobalWebView
                        // so the user effectively enters "Depth 2".
                        // This page will be isStandalone=true by default.
                        Get.to(GlobalWebView(urlStr), preventDuplicates: false);
                        return NavigationActionPolicy.CANCEL;
                      },
                      onReceivedError:
                          (
                            InAppWebViewController controller,
                            WebResourceRequest request,
                            WebResourceError error,
                          ) {
                            debugPrint(
                              'WebView onReceivedError: ${error.description} for ${request.url}',
                            );
                            FirebaseCrashlytics.instance.recordFlutterError(
                              FlutterErrorDetails(
                                exception: error,
                                library: request.url.toString(),
                              ),
                            );
                            if ([
                              'net::ERR_BLOCKED_BY_ORB',
                              'net::ERR_HTTP2_PROTOCOL_ERROR',
                              'net::ERR_FAILED',
                            ].contains(error.description)) {
                              return;
                            }
                            // Show a static error page to avoid a white/blank screen.
                            // Also catch standard connection errors

                            if (request.url.toString().contains(backendUrl)) {
                              if (mounted) {
                                setState(() {
                                  showErrorPage =
                                      1; // Treat mostly as connection issues for now or 2
                                });
                              }
                            }
                          },
                      onReceivedHttpError:
                          (
                            InAppWebViewController controller,
                            WebResourceRequest request,
                            WebResourceResponse errorResponse,
                          ) {
                            debugPrint(
                              'WebView onReceivedHttpError: ${errorResponse.statusCode} for ${request.url}',
                            );
                            // Render a static error page when HTTP errors occur to avoid
                            // leaving the user with a white screen.
                            // if (mounted) {
                            //   setState(() {
                            //     showErrorPage = 2;
                            //   });
                            // }
                          },
                      onGeolocationPermissionsShowPrompt:
                          (
                            InAppWebViewController controller,
                            String origin,
                          ) async {
                            try {
                              // Use the platform-appropriate permission on iOS
                              // to avoid unexpected behaviors.
                              Permission requestPermission = Platform.isIOS
                                  ? Permission.locationWhenInUse
                                  : Permission.location;

                              // Check current status first to avoid repeatedly prompting
                              var status = await requestPermission.status;

                              if (status.isGranted) {
                                return GeolocationPermissionShowPromptResponse(
                                  origin: origin,
                                  allow: true,
                                  retain: true,
                                );
                              }

                              // Request permission now
                              status = await requestPermission.request();

                              if (status.isGranted) {
                                return GeolocationPermissionShowPromptResponse(
                                  origin: origin,
                                  allow: true,
                                  retain: true,
                                );
                              }

                              // If permission is permanently denied / restricted, don't grant
                              // to the web page. Optionally guide the user to settings.
                              if (status.isPermanentlyDenied ||
                                  status.isRestricted) {
                                // Optionally open app settings so user can grant permission.
                                // Don't block — just deny geolocation to the page.
                                // await openAppSettings();
                                return GeolocationPermissionShowPromptResponse(
                                  origin: origin,
                                  allow: false,
                                  retain: false,
                                );
                              }

                              return GeolocationPermissionShowPromptResponse(
                                origin: origin,
                                allow: false,
                                retain: false,
                              );
                            } catch (e, st) {
                              FirebaseCrashlytics.instance.recordFlutterError(
                                FlutterErrorDetails(
                                  exception: e,
                                  stack: st,
                                  library: 'Geolocation',
                                ),
                              );
                              debugPrint('Geolocation permission error: $e');
                              return GeolocationPermissionShowPromptResponse(
                                origin: origin,
                                allow: false,
                                retain: false,
                              );
                            }
                          },
                      onPermissionRequest:
                          (
                            InAppWebViewController controller,
                            PermissionRequest permissionRequest,
                          ) async {
                            List<PermissionResourceType> resources =
                                permissionRequest.resources;

                            bool isGeolocation = resources.contains(
                              PermissionResourceType.GEOLOCATION,
                            );

                            if (isGeolocation) {
                              // Check the status of native location permission using permission_handler.
                              final status = await Permission.location
                                  .request();

                              if (status.isGranted) {
                                // If the native permission is granted, grant it to the web page.
                                return PermissionResponse(
                                  resources: resources,
                                  action: PermissionResponseAction.GRANT,
                                );
                              } else {
                                // If the native permission is denied, deny it to the web page.
                                return PermissionResponse(
                                  resources: resources,
                                  action: PermissionResponseAction.DENY,
                                );
                              }
                            }

                            return PermissionResponse(
                              resources: permissionRequest.resources,
                              action: PermissionResponseAction.GRANT,
                            );
                          },
                    ),
                  ),
                ),
                if (isLoading || !isWebViewReady)
                  Container(
                    // Use a Container to fill the entire screen with a semi-transparent overlay.
                    color: themeModeValue == 'dark' ? darkColor : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.4),
                    child: Center(
                      // The CircularProgressIndicator is the loading spinner.
                      child: Image.asset(gifSplash),
                    ),
                  ),
              ],
            ),
          )
        : Container(
            color: themeModeValue == 'dark' ? darkColor : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .2),
                  child: Image.asset(pngErrorBottomSheet),
                ),
                SizedBox(height: Get.height * .02),
                widgetText(context, 'anUnexpectedErrorOccurred'.tr),
              ],
            ),
          );

    if (widget.isStandalone) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          await goBack(didPop);
        },
        child: Scaffold(body: main),
      );
    }

    return main;
  }

  Future<void> goBack(bool didPop) async {
    if (didPop) {
      return;
    }

    if (showErrorPage != 0) {
      Get.back();
      return;
    }

    if ((await _webViewController?.canGoBack()) ?? false) {
      _webViewController?.goBack();
      return;
    }

    Get.back();
  }
}
