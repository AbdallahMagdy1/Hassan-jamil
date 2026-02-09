import 'package:flutter/material.dart';
import 'package:hj_app/global/globalUrl.dart';
import '../global/globalUI.dart';
import 'screen/globalWebView.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<StatefulWidget> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return GlobalWebView('$webUrl$language/cart', isStandalone: false);
  }
}
