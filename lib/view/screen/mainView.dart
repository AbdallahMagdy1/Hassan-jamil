import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hj_app/view/favorite.dart';
import 'package:hj_app/view/mainPage.dart';
import 'package:hj_app/view/store.dart';
import 'package:hj_app/view/widget/customButtomNavigationBar.dart';
import 'package:lottie/lottie.dart';

import '../../global/globalUI.dart';
import '../../global/globalUrl.dart';
import 'package:hj_app/controller/themeController.dart';
import '../Login/loginUserNameScreen.dart';
import '../cart.dart';
import 'globalWebView.dart';
import '../../controller/maintenance_tracking_controller.dart';
import 'maintenance_tracking_screen.dart';

class MainView extends StatefulWidget {
  final StatefulWidget? lastPageNavigator;
  final int navigatorTo;

  const MainView({super.key, this.lastPageNavigator, this.navigatorTo = 0});

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var isLogin = readGetStorage(loginKey);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.navigatorTo != 0 ? widget.navigatorTo : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.lastPageNavigator is LoginUserName) {
        Get.to(widget.lastPageNavigator);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = isLogin == null
        ? [
            const Store(), // 0
            GlobalWebView('$webUrl$language/search', isStandalone: false), // 1
            const Cart(), // 2 (FAB)
          ]
        : [
            const MainPage(), // 0
            const Store(), // 1
            const Cart(), // 2 (FAB)
            const Favorite(), // 3
            GlobalWebView('$webUrl$language/search', isStandalone: false), // 4
          ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (backPressCounter < 1) {
          Fluttertoast.showToast(msg: 'pressBackAgainToExit'.tr);
          backPressCounter++;
          Future.delayed(const Duration(seconds: 2), () => backPressCounter--);
          return;
        }
        SystemNavigator.pop();
      },
      child: GetBuilder<ThemeController>(
        builder: (controller) {
          Color navBgColor = themeModeValue == 'dark'
              ? Colors.black
              : Colors.white;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: themeModeValue == 'dark'
                ? blackColor
                : Colors.white,
            appBar: appBarMainPage(context, title: 'main', isLogin: isLogin),
            body: Stack(
              children: [
                children[_currentIndex],
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    final ctrl = Get.find<MaintenanceTrackingController>();
                    if (!ctrl.showFab.value) return const SizedBox.shrink();
                    return _SpiderFab(
                      hasTracking: ctrl.showFab.value,
                      isTrackingFinished: ctrl.isTrackingFinished.value,
                      navBgColor: navBgColor,
                      onCartPressed: () => setState(() => _currentIndex = 2),
                      onTrackPressed: ctrl.onFabPressed,
                    );
                  }),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GetBuilder<MaintenanceTrackingController>(
              builder: (ctrl) => Obx(() {
                if (!ctrl.showFab.value) {
                  return FloatingActionButton(
                    onPressed: () => setState(() => _currentIndex = 2),
                    backgroundColor: greenColor,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: SvgPicture.asset(
                      svgBasket,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: 26,
                    ),
                  );
                }
                return IgnorePointer(
                  child: FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    disabledElevation: 0,
                    shape: const CircleBorder(),
                    child: const SizedBox.shrink(),
                  ),
                );
              }),
            ),
            bottomNavigationBar: BottomAppBar(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.zero,
              color: navBgColor,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,

              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              height: 60,
              child: Row(
                children: isLogin == null
                    ? [
                        CustomButtomNavigationBar(
                          onPressed: () => setState(() => _currentIndex = 0),
                          iconPath: svgShop,
                          text: 'theShop'.tr,
                          active: _currentIndex == 0,
                        ),
                        const SizedBox(width: 70), // Center gap
                        CustomButtomNavigationBar(
                          onPressed: () => setState(() => _currentIndex = 1),
                          iconPath: svgSearch,
                          text: 'search'.tr,
                          active: _currentIndex == 1,
                        ),
                      ]
                    : [
                        Expanded(
                          child: Row(
                            children: [
                              CustomButtomNavigationBar(
                                onPressed: () =>
                                    setState(() => _currentIndex = 0),
                                iconPath: svgMain,
                                text: 'main'.tr,
                                active: _currentIndex == 0,
                              ),
                              CustomButtomNavigationBar(
                                onPressed: () =>
                                    setState(() => _currentIndex = 1),
                                iconPath: svgShop,
                                text: 'theShop'.tr,
                                active: _currentIndex == 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 70), // Center gap
                        Expanded(
                          child: Row(
                            children: [
                              CustomButtomNavigationBar(
                                onPressed: () =>
                                    setState(() => _currentIndex = 3),
                                iconPath: svgFavorite,
                                text: 'favorite'.tr,
                                active: _currentIndex == 3,
                              ),
                              CustomButtomNavigationBar(
                                onPressed: () =>
                                    setState(() => _currentIndex = 4),
                                iconPath: svgSearch,
                                text: 'search'.tr,
                                active: _currentIndex == 4,
                              ),
                            ],
                          ),
                        ),
                      ],
              ),
            ),
          );
        },
      ),
    );
  }

  int backPressCounter = 0;
  int backPressTotal = 1;
}

class _SpiderFab extends StatefulWidget {
  final bool hasTracking;
  final bool isTrackingFinished;
  final Color navBgColor;
  final VoidCallback onCartPressed;
  final VoidCallback onTrackPressed;

  const _SpiderFab({
    required this.hasTracking,
    required this.isTrackingFinished,
    required this.navBgColor,
    required this.onCartPressed,
    required this.onTrackPressed,
  });

  @override
  State<_SpiderFab> createState() => _SpiderFabState();
}

class _SpiderFabState extends State<_SpiderFab> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasTracking && _isExpanded) {
      _isExpanded = false;
    }

    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // ── Sub Button 1: Cart (Fan Left-Up) ───────────────────────────────
            _AnimatedSubButton(
              isExpanded: _isExpanded,
              offset: const Offset(-50, -85),
              label: 'Cart',
              icon: SvgPicture.asset(
                svgBasket,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 18,
              ),
              color: greenColor, // Cart parent radius bg green as requested
              onTap: () {
                _toggle();
                widget.onCartPressed();
              },
            ),

            // ── Sub Button 2: Car/Track (Fan Right-Up) ─────────────────────────
            _AnimatedSubButton(
              isExpanded: _isExpanded,
              offset: const Offset(50, -85),
              label: 'Track your maintenance',
              icon: Icon(
                widget.isTrackingFinished
                    ? Icons.check_circle_rounded
                    : Icons.car_repair_rounded,
                color: Colors.white, // Tracking icon with white as requested
                size: 24,
              ),
              color:
                  redColor, // Keeping tracking background red for recording theme
              onTap: () {
                _toggle();
                widget.onTrackPressed();
              },
            ),

            // ── Center Toggle Button ─────────────────────────────────────────
            _buildMainButton(
              onTap: _toggle,
              icon: _isExpanded
                  ? const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 28,
                    )
                  : LottieBuilder.asset(
                      "assets/lottie/Maintenance.json",
                      width: 55,
                      height: 55,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
              color: _isExpanded
                  ? greyDarkColor
                  : (Get.isDarkMode ? Color(0xff1e1e1e) : Colors.white24),
              isPulsing: !widget.isTrackingFinished && !_isExpanded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required Widget icon,
    required VoidCallback onTap,
    Color? color,
    bool isPulsing = false,
  }) {
    final baseColor = color ?? greenColor;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPulsing)
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.5).animate(
                CurvedAnimation(
                  parent: _pulseController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: FadeTransition(
                opacity: Tween(begin: 0.5, end: 0.0).animate(
                  CurvedAnimation(
                    parent: _pulseController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
              border: Border.all(color: widget.navBgColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: baseColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSubButton extends StatelessWidget {
  final bool isExpanded;
  final Offset offset;
  final Widget icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedSubButton({
    required this.isExpanded,
    required this.offset,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: icon,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: greenColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
        .animate(target: isExpanded ? 1 : 0)
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
          duration: 600.ms,
        )
        .move(
          begin: Offset.zero,
          end: offset,
          curve: Curves.elasticOut,
          duration: 600.ms,
        );
  }
}
