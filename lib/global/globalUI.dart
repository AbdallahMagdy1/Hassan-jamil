import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hj_app/controller/locale_controller.dart';
import 'package:hj_app/global/globalUrl.dart';
import 'package:hj_app/model/notification.dart';
import 'package:hj_app/view/Login/loginUserNameScreen.dart';
import 'package:hj_app/view/screen/mainView.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/getUserAccountTypes.dart';
import '../view/morePage.dart';
import '../view/screen/globalWebView.dart';

var locale = const Locale('en', 'ar');
var keyLanguage = "language";
var keyTheme = "theme";
var keyNotifications = "key_notifications";

// svg Picture
const svgFavorite = "assets/icons/favorite.svg";
const svgMain = "assets/icons/main.svg";
const svgMore = "assets/icons/more.svg";
const svgShop = "assets/icons/shop.svg";
const svgMyRequests = "assets/icons/myRequests.svg";
const svgMyBookings = "assets/icons/myBookings.svg";
const svgMyReservations = "assets/icons/myReservations.svg";
const svgMaintenance = "assets/icons/maintenance.svg";
const svgFinance = "assets/icons/finance.svg";
const svgInformationAboutUs = "assets/icons/informationAboutUs.svg";
const svgCallUs = "assets/icons/callUs.svg";
const svgRecruitment = "assets/icons/recruitment.svg";
const svgSettings = "assets/icons/settings.svg";
const svgSignOut = "assets/icons/signOut.svg";
const svgSignIn = "assets/icons/signIn.svg";
const svgBasket = "assets/icons/basket.svg";
const svgCompare = "assets/icons/compare.svg";
const svgFacebook = "assets/icons/facebook.svg";
const svgGoogle = "assets/icons/google.svg";
const svgLocation = "assets/icons/location.svg";
const svgAlarm = "assets/icons/alarm.svg";
const svgSearch = "assets/icons/search.svg";
const svgLoading = "assets/icons/loading.svg";
const svgIconPassword = "assets/icons/iconPassword.svg";
const svgEyeOn = "assets/icons/eyeOn.svg";
const svgLogoCamera = "assets/icons/logoCamera.svg";
const svgLogoLibrary = "assets/icons/logoLibrary.svg";
const svgTips = "assets/icons/tips.svg";
const svgMenu = "assets/icons/menu.svg";
// png Picture
const pngErrorBottomSheet = "assets/images/errorBottomSheet.png";
const pngCharacter = "assets/images/character.png";
const pngInsertPhotoID = "assets/images/insertPhotoID.png";
const pngLogoOptionLogin = "assets/images/logoOptionLogin.png";
const pngLogoOptionRegister = "assets/images/logoOptionRegister.png";
const pngPleaseLoginForABetterExperience =
    "assets/images/pleaseLoginForABetterExperience.png";
const pngVerificationConfirm = "assets/images/verificationConfirm.png";
const pngLoginPassWord = "assets/images/loginPassWord.png";
const pngResetPassword = "assets/images/resetPassword.png";
const pngNoInternetConnection = "assets/images/noInternetConnection.png";

// gif Picture
const gifSplash = "assets/images/logoHJ.gif";

String language = 'ar';
var settingsVersion = 0.obs;

// Colors
Color greyColor = const Color(0xffECECEC);
Color greyColor2 = const Color(0xffA5A5A5);
Color greyColor3 = const Color(0xff707070);
Color greyDarkColor = const Color(0xffB0B0B0);
Color greenColor = const Color(0xff00b362);
Color redColor = const Color(0xffF90101);
Color blackColor = const Color(0xff090D0B);
Color blueColor = const Color(0xff004BC8);
Color greyc = const Color(0xffE7E7E7);
Color arww = const Color(0xffc6c6c6);
Color greyColor4 = const Color(0xfff0f0f0);
Color greyColor5 = const Color(0xfff8f8F8);
Color greyColor6 = const Color(0xffFAFAFA);
Color buttonDarkColor = const Color(0xff39393D);
Color darkColor = const Color(0xff1C1C1E);

Map<int, Color> color = {
  50: const Color.fromRGBO(79, 216, 113, .1),
  100: const Color.fromRGBO(98, 221, 129, .2),
  200: const Color.fromRGBO(118, 225, 144, .3),
  300: const Color.fromRGBO(137, 229, 160, .4),
  400: const Color.fromRGBO(157, 234, 176, .5),
  500: const Color.fromRGBO(177, 238, 192, .6),
  600: const Color.fromRGBO(196, 242, 208, .7),
  700: const Color.fromRGBO(216, 246, 223, .8),
  800: const Color.fromRGBO(235, 251, 239, .9),
  900: const Color.fromRGBO(255, 255, 255, 1),
};

String getLanguage() {
  language =
      readGetStorage(keyLanguage) ?? (Get.deviceLocale?.languageCode ?? 'ar');

  debugPrint('Detected language: $language');

  writeGetStorage(keyLanguage, language);
  Get.find<LocaleController>().changeLocale(Locale(language));

  return language;
}

// Get Storage Key
const loginKey = 'login';
const listUserAccountTypesKey = 'listUserAccountTypes';
const isShowLoginPage = 'isShowLoginPage';
const userNameKey = 'userName';
const passWordKey = 'passWord';
const remeberMeKey = 'remeberMe';
const rememberUserName = 'rememberUserName';
const rememberPassWord = 'rememberPassWord';

List<NotificationClass> notificationData() {
  return NotificationClass.listFromJson(readGetStorage(keyNotifications) ?? []);
}

dynamic notificationDelete(int index) {
  List<NotificationClass> notifications =
      readGetStorage(keyNotifications) ?? [];
  notifications.removeAt(index);
  return writeGetStorage(keyNotifications, notifications);
}

dynamic notificationAdd(NotificationClass noti) {
  List<NotificationClass> notifications =
      readGetStorage(keyNotifications) ?? [];
  notifications.add(noti);
  return writeGetStorage(keyNotifications, notifications);
}

dynamic readGetStorage(String key) {
  return GetStorage().read(key);
}

Future<void> writeGetStorage(String key, var value) {
  return GetStorage().write(key, value);
}

Future<void> removeGetStorage(String key) {
  return GetStorage().remove(key);
}

Text widgetText(
  context,
  String text, {
  color,
  double? fontSize,
  fontWeight,
  textDirection,
  textAlign,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: color ?? (themeModeValue == 'light' ? darkColor : Colors.white),
      fontSize: fontSize ?? Get.width * .045,
      fontWeight: fontWeight ?? FontWeight.normal,
    ),
    textDirection: textDirection,
  );
}

StatelessWidget widgetButton(
  context,
  text, {
  colorText,
  colorButton,
  fontSize,
  fontWeight,
  width,
  height,
  onTap,
  bool isProgress = false,
}) {
  return isProgress
      ? Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: width ?? Get.width * .3,
          height: height ?? Get.height * .05,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * .001),
            child: SizedBox(
              height: Get.height * .02,
              width: Get.height * .02,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        )
      : InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorButton ?? greyDarkColor,
              borderRadius: BorderRadius.circular(8),
            ),
            width: width ?? Get.width * .3,
            height: height ?? Get.height * .05,
            child: widgetText(
              context,
              text,
              textAlign: TextAlign.center,
              color: colorText,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        );
}

Container widgetTextForm(
  context, {
  String? hintText,
  textInputType,
  inputFormatters,
  validatorError,
  controller,
  onChanged,
  bool obscureText = false,
  suffixIcon,
  errorText,
  initialValue,
  bool readOnly = false,
  bool centerAlign = false,
  textDirection,
  prefixIcon,
}) {
  return Container(
    alignment: Alignment.center,
    height: errorText == null ? Get.height * .065 : Get.height * .08,
    margin: EdgeInsets.only(
      bottom: Get.height * .017,
      left: Get.width * .01,
      right: Get.width * .01,
    ),
    decoration: BoxDecoration(
      boxShadow: [
        themeModeValue == 'light'
            ? const BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: -5,
              )
            : const BoxShadow(color: Colors.transparent),
      ],
    ),
    child: TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      textAlignVertical: TextAlignVertical.bottom,
      obscureText: obscureText,
      controller: controller,
      textAlign: centerAlign ? TextAlign.center : TextAlign.start,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: (themeModeValue == 'light' ? Colors.white : buttonDarkColor),
        focusColor: greyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 16.0,
            color: themeModeValue == 'light' ? greyColor : Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: themeModeValue == 'light' ? greyColor : Colors.transparent,
          ),
        ),
        contentPadding: const EdgeInsets.only(
          bottom: 25.0,
          right: 25.0,
          left: 25.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: themeModeValue == 'light' ? greyColor : Colors.transparent,
          ),
        ),
        hintText: hintText?.tr,
        errorText: errorText,
        hintStyle: TextStyle(fontSize: Get.width * .035, color: greyColor3),
      ),
      textDirection: textDirection ?? TextDirection.ltr,
      validator: (value) {
        if (value!.isEmpty) {
          return '$validatorError'.tr;
        }
        return null;
      },
      keyboardType: textInputType ?? TextInputType.emailAddress,
      onChanged: onChanged,
    ),
  );
}

Container widgetTextFormWithBorderColorWhite(
  context, {
  String? hintText,
  textInputType,
  inputFormatters,
  validatorError,
  controller,
  onChanged,
  bool obscureText = false,
  errorText,
  textDirection,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: errorText == null
          ? [
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 11,
                spreadRadius: -2,
              ),
            ]
          : [],
    ),
    child: TextFormField(
      obscureText: obscureText,
      controller: controller,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 3.3, color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 3.3, color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 1.5, color: redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 1.5, color: redColor),
        ),
        hintText: hintText?.tr,
        errorText: errorText,
      ),
      textDirection: textDirection,
      validator: (value) {
        if (value!.isEmpty) {
          return '$validatorError'.tr;
        }
        return null;
      },
      keyboardType: textInputType ?? TextInputType.text,
      onChanged: onChanged,
    ),
  );
}

Container widgetUploadImage(
  context, {
  String? buttonText,
  String? textNextButton,
  textInputType,
  inputFormatters,
  validatorError,
  controller,
  onChanged,
  onPressed,
  bool obscureText = false,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        themeModeValue == 'light'
            ? const BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: -5,
              )
            : const BoxShadow(color: Colors.transparent),
      ],
    ),
    child: Container(
      height: Get.height * .075,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
      ),
      child: Row(
        children: [
          SizedBox(width: Get.width * .05),
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                BorderSide(
                  color: themeModeValue == 'dark' ? Colors.white : darkColor,
                ),
              ),
              foregroundColor: WidgetStateProperty.all(darkColor),
              backgroundColor: WidgetStateProperty.all(greyColor),
            ),
            child: widgetText(context, buttonText!, fontSize: Get.width * .035),
          ),
          SizedBox(width: Get.width * .03),
          widgetText(context, textNextButton!, fontSize: Get.width * .035),
        ],
      ),
    ),
  );
}

String? userAccountTypesValue;

Container widgetDropdownGetUserAccountTypes(
  context,
  List<GetUserAccountTypes> list,
  var language, {
  onChanged,
  bool errorColor = false,
  hint,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: themeModeValue == 'light'
          ? [
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ]
          : [const BoxShadow(color: Colors.transparent)],
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
      decoration: BoxDecoration(
        border: Border.all(
          color: errorColor ? redColor : Colors.transparent,
          width: 1.5,
        ),
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton(
        isExpanded: true,
        underline: const SizedBox(),
        hint: hint != null
            ? widgetText(context, '$hint')
            : widgetText(context, 'userAccountType'.tr),
        value: userAccountTypesValue,
        items: list.map((list) {
          return DropdownMenuItem(
            value: list.id,
            child: widgetText(
              context,
              language == 'en' ? list.descriptionEn : list.descriptionAr,
              fontSize: Get.width * .035,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

StatelessWidget widgetLoginButton(
  context,
  String text, {
  onTap,
  backgroundColor,
  colorFont,
  isActive,
  boxShadow,
  bool isProgress = false,
  bool fontWeight = false,
  fontSize,
  widthButton,
}) {
  return isProgress
      ? Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((255 * 0.5).toInt()),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: greenColor,
            borderRadius: BorderRadius.circular(10),
          ),
          width: widthButton ?? Get.width * .9,
          height: Get.height * .05,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * .001),
            child: SizedBox(
              height: Get.height * .02,
              width: Get.height * .02,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        )
      : InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow:
                  boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.grey.withAlpha((255 * 0.3).toInt()),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
              color: backgroundColor ?? greyDarkColor,
              borderRadius: BorderRadius.circular(10),
            ),
            width: Get.width * .9,
            height: Get.height * .05,
            child: widgetText(
              context,
              text.tr,
              color: colorFont ?? Colors.white,
              fontSize: Get.width * .04,
              fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
}

Future errorDialog({
  required String title,
  required String body,
  bool isFindLoading = false,
}) {
  return Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Get.back();
            if (isFindLoading) {
              Get.back();
              Get.back();
            }
          },
          child: const Text('😑'),
        ),
      ],
    ),
  );
}

void bottomSheetError(context, {text}) {
  FocusManager.instance.primaryFocus?.unfocus();

  Get.bottomSheet(
    Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: Get.height * .06),
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * .03,
        vertical: Get.height * .03,
      ),
      height: Get.height * .37,
      width: Get.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(pngErrorBottomSheet),
          fit: BoxFit.fill,
        ),
      ),
      child: SizedBox(
        width: Get.width * .4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(child: widgetText(context, text))],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    isDismissible: false,
    enableDrag: false,
  );
  Future.delayed(const Duration(seconds: 4), () {
    Get.back();
  });
}

String textToMd5(String text) {
  return md5.convert(utf8.encode(text)).toString();
}

Widget logoInAppBar(context, isLogin) {
  if (isLogin != null) {
    if (isLogin['Logo'] == null) {
      return Container(
        width: Get.height * .03,
        height: Get.height * .03,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(pngCharacter),
          ),
        ),
      );
    }

    var bytes = base64.decode(isLogin['Logo']);
    return SizedBox(
      width: Get.width * .08,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: Image.memory(bytes, fit: BoxFit.fill).image,
      ),
    );
  }
  return const SizedBox();
}

AppBar appBar(context, {isLogin, title, bool isViewSearch = false}) {
  return AppBar(
    backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
    title: widgetText(
      context,
      '$title'.tr,
      color: themeModeValue == 'light' ? darkColor : Colors.white,
      fontWeight: FontWeight.bold,
    ),
    centerTitle: true,
    actions: [
      Visibility(
        visible: isViewSearch,
        child: InkWell(
          onTap: () {
            Get.to(GlobalWebView('$webUrl$language/search'));
          },
          child: Padding(
            padding: EdgeInsets.only(left: Get.width * .02),
            child: SvgPicture.asset(
              svgSearch,
              colorFilter: ColorFilter.mode(
                (themeModeValue == 'light' ? darkColor : Colors.white),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: Get.width * .02),
    ],
  );
}

AppBar appBarMainPage(context, {isLogin, title}) {
  return AppBar(
    // Remove leading to eliminate profile icon
    leading: null,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: themeModeValue == 'light'
          ? Brightness.dark
          : Brightness.light,
      statusBarBrightness: themeModeValue == 'light'
          ? Brightness.light
          : Brightness.dark,
    ),
    foregroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : darkColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    ),
    // title: widgetText(context, '$title'.tr,
    //     color: themeModeValue == 'light' ? darkColor : Colors.white,
    //     fontWeight: FontWeight.bold),
    // centerTitle: true,
    // Wrap actions in Directionality RTL to keep icons on the right always
    actions: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: Get.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menu icon - first (rightmost) in the AppBar, navigates to More page
              IconButton(
                onPressed: () {
                  // Navigate directly to MorePage
                  Get.to(MorePage(onSettingUpdate: () {}));
                },
                icon: SvgPicture.asset(
                  svgMenu,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff3BD461), // Green primary color
                    BlendMode.srcIn,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  // final MapController controller = Get.put(MapController());
                  // if (controller.lat.value.isEmpty ||
                  //     controller.finishGetData.value == false) {
                  //   return;
                  // }
                  // launchUrl(
                  //     Uri.parse(
                  //         'https://www.google.com/maps/@${controller.lat.value},${controller.long.value},15.4746z'),
                  //     mode: LaunchMode.externalApplication);
                  // launchUrl(
                  //     Uri.parse('https://maps.app.goo.gl/cLMQJtZqzPovqvhg8'),
                  //     mode: LaunchMode.externalApplication);
                  launchUrl(
                    Uri.parse('https://maps.app.goo.gl/cLMQJtZqzPovqvhg8'),
                    mode: LaunchMode.externalApplication,
                  );
                  // return;

                  // LocationPermission permission = await Geolocator.requestPermission();

                  // if ([LocationPermission.whileInUse, LocationPermission.always]
                  //         .contains(permission) &&
                  //     !await Permission.locationWhenInUse.serviceStatus.isEnabled) {
                  //   await Permission.location.request();
                  //   await Geolocator.openLocationSettings();
                  //   return;
                  // }

                  // Get.to(const MapView());
                },
                icon: SvgPicture.asset(
                  svgLocation,
                  colorFilter: ColorFilter.mode(
                    (themeModeValue == 'light' ? Colors.black : Colors.white),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Container widgetTextFormBorderGrey(
  context, {
  String? hintText,
  textInputType,
  inputFormatters,
  validatorError,
  controller,
  onChanged,
  bool obscureText = false,
  suffixIcon,
  prefixIcon,
  initialValue,
  textAlign,
  readOnly,
  errorText,
  textDirection,
}) {
  return Container(
    height: errorText == null ? Get.height * .06 : Get.height * .09,
    margin: EdgeInsets.only(
      bottom: Get.height * .015,
      left: Get.width * .01,
      right: Get.width * .01,
    ),
    decoration: BoxDecoration(
      boxShadow: errorText == null
          ? [
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: -2,
              ),
            ]
          : [],
    ),
    child: TextFormField(
      textAlign: textDirection != null
          ? TextAlign.left
          : (language == 'en' ? TextAlign.left : TextAlign.right),
      initialValue: initialValue,
      readOnly: readOnly ?? false,
      obscureText: obscureText,
      controller: controller,
      inputFormatters: inputFormatters ?? [],
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: redColor),
        ),
        hintText: hintText?.tr,
        errorText: errorText,
      ),
      textDirection: textDirection,
      validator: (value) {
        if (value!.isEmpty) {
          return '$validatorError'.tr;
        }
        return null;
      },
      keyboardType: textInputType ?? TextInputType.emailAddress,
      onChanged: onChanged,
    ),
  );
}

bool lightMode = false;
bool nightMode = false;
bool systemMode = false;
bool lightModeChoose = false;
bool nightModeChoose = false;
bool systemModeChoose = false;
String themeModeValue = 'system';

Future<void> getThemeStatus() async {
  var isLight = readGetStorage(keyTheme);

  // Normalize stored value and handle null safely
  if (isLight is! String) {
    isLight = null;
  }

  if (isLight == 'themeModeValue = dark') {
    lightMode = false;
    nightMode = true;
    systemMode = false;
    Get.changeThemeMode(ThemeMode.dark);
    writeGetStorage(keyTheme, 'themeModeValue = dark');
    themeModeValue = 'dark';
  } else if (isLight == 'themeModeValue = light') {
    lightMode = true;
    nightMode = false;
    systemMode = false;
    Get.changeThemeMode(ThemeMode.light);
    writeGetStorage(keyTheme, 'themeModeValue = light');
    themeModeValue = 'light';
  } else {
    lightMode = false;
    nightMode = false;
    systemMode = true;
    writeGetStorage(keyTheme, 'themeModeValue = system');

    // Use WidgetsBinding.window.platformBrightness as a safe fallback so
    // this can be called before the first frame / before Get.mediaQuery is
    // available (for example when running initialization in main()).
    Brightness platformBrightness = Brightness.light;
    try {
      platformBrightness = WidgetsBinding.instance.window.platformBrightness;
    } catch (_) {
      // ignore and default to light
    }

    if (platformBrightness == Brightness.dark) {
      themeModeValue = 'dark';
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      themeModeValue = 'light';
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}

void splashLogic() {
  var isShowLoginPageAfterInstall = readGetStorage(isShowLoginPage);
  if (isShowLoginPageAfterInstall == null) {
    writeGetStorage(isShowLoginPage, true);
    Get.offAll(LoginUserName(isFromSplashScreen: true));
  } else {
    StatefulWidget? lastPageNavigator;
    var isLogin = readGetStorage(loginKey);
    if (isLogin == null) {
      lastPageNavigator = LoginUserName(isFromSplashScreen: true);
    }
    Get.offAll(MainView(lastPageNavigator: lastPageNavigator));
  }
}

// Global utility to clear WebView cache
Future<void> clearWebViewCache() async {
  try {
    await InAppWebViewController.clearAllCache();
    settingsVersion.value++; // Trigger reloads in observing WebViews
    debugPrint(
      'WebView cache cleared successfully, version: ${settingsVersion.value}',
    );
  } catch (e) {
    debugPrint('Error clearing WebView cache: $e');
  }
}
