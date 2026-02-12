import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../global/globalUI.dart';

class CustomButtomNavigationBar extends StatelessWidget {
  const CustomButtomNavigationBar({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.text,
    required this.active,
  });

  final void Function() onPressed;
  final String iconPath;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: active ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  active
                      ? greenColor
                      : (themeModeValue == 'dark'
                            ? Colors.white
                            : Colors.black54),
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                color: active
                    ? greenColor
                    : (themeModeValue == 'dark'
                          ? Colors.white70
                          : Colors.black54),
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
