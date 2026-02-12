import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/view/favorite.dart';
import 'package:hj_app/view/mainPage.dart';
import 'package:hj_app/view/store.dart';
import 'package:hj_app/view/widget/customButtomNavigationBar.dart';

import '../../global/globalUI.dart';
import '../../global/globalUrl.dart';
import 'package:hj_app/controller/themeController.dart';
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
            body: children[_currentIndex],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: InkWell(
              onTap: () => setState(() => _currentIndex = 2),
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: greenColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: navBgColor,
                    width: 3,
                  ), // Match nav background for clean notch
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    svgBasket,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
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
