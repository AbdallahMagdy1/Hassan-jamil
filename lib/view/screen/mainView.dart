import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/view/favorite.dart';
import 'package:hj_app/view/mainPage.dart';
import 'package:hj_app/view/store.dart';

import '../../global/globalUI.dart';
import '../../global/globalUrl.dart';
import 'package:hj_app/controller/themeController.dart';
import '../../global/responsive.dart';
import '../Login/loginUserNameScreen.dart';
import '../cart.dart';
import 'globalWebView.dart';

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
            const Store(),
            const Cart(),
            // Search is handled in onTabTapped
          ]
        : [
            const MainPage(),
            const Store(),
            const Cart(),
            const Favorite(),
            // Search is handled in onTabTapped
          ];
    // compute responsive sizes
    final navFontSize = Responsive.scaledFont(context, 13);
    final navIconSize = Responsive.isTablet(context) ? 36.0 : 30.0;
    final navPadding = EdgeInsets.all(Responsive.wp(context, 0.02));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        if (backPressCounter < 1) {
          Fluttertoast.showToast(msg: 'pressBackAgainToExit'.tr);
          backPressCounter++;
          Future.delayed(const Duration(seconds: 2), () {
            backPressCounter--;
          });
          return;
        }

        SystemNavigator.pop();
      },
      child: GetBuilder<ThemeController>(
        builder: (controller) => AnnotatedRegion<SystemUiOverlayStyle>(
          // This forces the system UI to stay white even if the theme changes
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: themeModeValue == 'dark'
                ? Colors.black
                : Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: themeModeValue == 'dark'
                ? Colors.black
                : Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Colors.grey,
            appBar: appBarMainPage(context, title: 'main', isLogin: isLogin),
            body: children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: themeModeValue == 'dark'
                  ? Colors.black
                  : Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: navFontSize,
              unselectedFontSize: navFontSize,
              iconSize: navIconSize,
              selectedItemColor: Colors.green,
              onTap: onTabTapped,
              // new
              currentIndex: _currentIndex,
              // new
              items: isLogin == null
                  ? [
                      // BottomNavigationBarItem(
                      //     icon: Padding(
                      //         padding: const EdgeInsets.all(2),
                      //         child: SvgPicture.asset(
                      //           svgMain,
                      //           colorFilter: ColorFilter.mode(
                      //               (_currentIndex == 0
                      //                       ? Colors.green[500]
                      //                       : null) ??
                      //               BlendMode.srcIn),
                      //     label: 'main'.tr),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgShop,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 0 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'theShop'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgBasket,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 1 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'basket'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgSearch,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 2 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'search'.tr,
                      ),
                    ]
                  : [
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgMain,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 0 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'main'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgShop,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 1 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'theShop'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgBasket,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 2 ? Colors.green[500] : null) ??
                                  Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'basket'.tr,
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgFavorite,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 3 ? Colors.green[500] : null) ??
                                  const Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'favorite'.tr,
                      ),
                      // BottomNavigationBarItem(
                      //     icon: Padding(
                      //         padding: const EdgeInsets.all(10),
                      //         child: SvgPicture.asset(
                      //           svgCompare,
                      //           colorFilter: ColorFilter.mode(
                      //               (_currentIndex == 4
                      //                       ? Colors.green[500]
                      //                       : null) ??
                      //                   Color(0xFF9E9E9E),
                      //               BlendMode.srcIn),
                      //         )),
                      //     label: 'compare'.tr),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: navPadding,
                          child: SvgPicture.asset(
                            svgSearch,
                            colorFilter: ColorFilter.mode(
                              (_currentIndex == 4 ? Colors.green[500] : null) ??
                                  const Color(0xFF9E9E9E),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        label: 'search'.tr,
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  int backPressCounter = 0;
  int backPressTotal = 1;

  void onTabTapped(int index) {
    var isLogin = readGetStorage(loginKey);
    int searchIndex = isLogin == null ? 2 : 4;

    // If search icon is tapped, navigate to search page
    if (index == searchIndex) {
      Get.to(GlobalWebView('$webUrl$language/search'));
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
