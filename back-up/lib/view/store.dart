import 'package:flutter/material.dart';
import 'package:hj_app/global/globalUrl.dart';
import '../global/globalUI.dart';
import 'screen/globalWebView.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<StatefulWidget> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  var isLogin = readGetStorage(loginKey);

  @override
  Widget build(BuildContext context) {
    return GlobalWebView(
      isLogin == null
          ? '$webUrl$language/store/logout'
          : '$webUrl$language/store',
      isStandalone: false,
    );
  }
}
