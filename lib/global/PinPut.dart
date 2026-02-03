import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class FilledRoundedPinPut extends StatefulWidget {
  final TextEditingController verificationCode;
  final ValueChanged<String>? onChanged;

  const FilledRoundedPinPut(this.verificationCode, this.onChanged, {super.key});

  @override
  State<StatefulWidget> createState() => _FilledRoundedPinPutState();

  @override
  String toStringShort() => 'Rounded Filled';
}

class _FilledRoundedPinPutState extends State<FilledRoundedPinPut> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    const length = 4;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * .9).toInt()),
            blurRadius: 6,
            // spreadRadius: -5,
          ),
        ],
      ),
    );

    return SizedBox(
      height: 68,
      child: Pinput(
        length: length,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        controller: widget.verificationCode,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          setState(() => showError = pin != '5555');
        },
        /* focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 64,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: errorColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),*/
        onChanged: widget.onChanged,
      ),
    );
  }
}
