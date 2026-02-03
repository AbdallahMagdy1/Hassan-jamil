import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'mainView.dart';
import '../../global/globalUI.dart';

class WidgetWebViewWithAppBar extends StatefulWidget {
  final String url;

  const WidgetWebViewWithAppBar(this.url, {super.key});

  @override
  State<StatefulWidget> createState() => _WidgetWebViewWithAppBarState();
}

class _WidgetWebViewWithAppBarState extends State<WidgetWebViewWithAppBar> {
  late final WebViewController _controller;

  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
code: ${error.errorCode}
description: ${error.description}
errorType: ${error.errorType}
isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/goBack')) {
              Get.back();
              return NavigationDecision.prevent;
            } else if (request.url.contains('/home')) {
              Get.offAll(MainView(navigatorTo: 0));
              return NavigationDecision.prevent;
            } else if (request.url.contains('/store')) {
              Get.offAll(MainView(navigatorTo: 1));
              return NavigationDecision.prevent;
            } else if (request.url.toString().contains(widget.url)) {
              return NavigationDecision.navigate;
            }

            Get.to(
              WidgetWebViewWithAppBar(request.url),
              preventDuplicates: false,
            );
            return NavigationDecision.prevent;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          Get.showSnackbar(
            GetSnackBar(
              message: message.message,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
            size: Get.width * .04,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
