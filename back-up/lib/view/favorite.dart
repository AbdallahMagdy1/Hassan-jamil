import 'package:flutter/material.dart';
import 'package:hj_app/global/globalUrl.dart';
import '../global/globalUI.dart';
import 'screen/globalWebView.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  var isLogin = readGetStorage(loginKey);

  @override
  Widget build(BuildContext context) {
    return GlobalWebView(
      '$webUrl$language/favorite/${isLogin['Web_UserID']}/${isLogin['GUID']}',
      isStandalone: false,
    );
  }
}
