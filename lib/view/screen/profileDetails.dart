import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/profileController.dart';
import 'package:hj_app/global/globalUI.dart';
import 'package:image_picker/image_picker.dart';

class profileDetails extends StatelessWidget {
  const profileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isLogin = readGetStorage(loginKey);
    bool isDark = themeModeValue == 'dark';

    // Handle null or missing user data
    if (isLogin == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: isDark ? Colors.white : darkColor,
              size: 18,
            ),
          ),
          title: widgetText(
            context,
            'profilePersonally'.tr,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: widgetText(
            context,
            'pleaseSignInViewProfile'.tr,
            fontSize: 16,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: isDark ? Colors.white : darkColor,
            size: 18,
          ),
        ),
        title: widgetText(
          context,
          'profilePersonally'.tr,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * .05,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION: PROFILE HEADER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _containerDecoration(isDark, context),
                child: Row(
                  children: [
                    _buildAvatarSection(isDark, controller, context),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildNameSection(context, isLogin, controller),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SECTION: TAB SELECTOR (Modern Chips)
              _buildTabSelector(isDark, controller, context),

              const SizedBox(height: 20),

              // SECTION: CONTENT CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _containerDecoration(isDark, context),
                child: _buildDynamicContent(
                  context,
                  isDark,
                  controller,
                  isLogin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI CONSTANTS FROM SETTINGS PAGE ---
  BoxDecoration _containerDecoration(bool isDark, BuildContext context) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // --- AVATAR UI ---
  Widget _buildAvatarSection(
    bool isDark,
    ProfileController controller,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () =>
          _showDialogUploadImageFromGalleryOrCameraForLogo(controller, context),
      child: Obx(
        () => Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: greenColor.withOpacity(0.2),
                  width: 2,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: controller.imageProfileBase64.value != null
                      ? MemoryImage(
                          base64.decode(controller.imageProfileBase64.value!),
                        )
                      : AssetImage(pngCharacter) as ImageProvider,
                ),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: greenColor,
              child: const Icon(Icons.edit, size: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER TEXT UI ---
  Widget _buildNameSection(
    BuildContext context,
    dynamic isLogin,
    ProfileController controller,
  ) {
    return Obx(() {
      // Trigger rebuild when optionTap changes (after updates)
      controller.optionTap.value;
      final freshLogin = readGetStorage(loginKey);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widgetText(
            context,
            "${freshLogin?['FirstNameAr'] ?? freshLogin?['FirstNameEn'] ?? ''} ${freshLogin?['LastNameAr'] ?? freshLogin?['LastNameEn'] ?? ''}",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          const SizedBox(height: 4),
          widgetText(
            context,
            _getCustomerGroupName(controller, freshLogin),
            fontSize: 13,
            color: greenColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      );
    });
  }

  String _getCustomerGroupName(ProfileController controller, dynamic isLogin) {
    if (isLogin == null || isLogin['CustGroupID'] == null) {
      return 'clientType'.tr;
    }
    var group = controller.listUserAccountTypes
        .where((e) => e.id == isLogin['CustGroupID']?.toString())
        .toList();
    if (group.isNotEmpty) {
      return language == 'ar' ? group[0].descriptionAr : group[0].descriptionEn;
    }
    return 'clientType'.tr;
  }

  // --- TAB UI ---
  Widget _buildTabSelector(
    bool isDark,
    ProfileController controller,
    BuildContext context,
  ) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _widgetTab(
              'profilePersonally',
              0,
              active: [0, 3].contains(controller.optionTap.value),
              controller: controller,
              context: context,
              isLogin: readGetStorage(loginKey),
            ),
            _widgetTab(
              'contactInformation',
              1,
              active: [1, 4].contains(controller.optionTap.value),
              controller: controller,
              context: context,
              isLogin: readGetStorage(loginKey),
            ),
            _widgetTab(
              'confidentialityAndSecurity',
              2,
              active: [2, 5].contains(controller.optionTap.value),
              controller: controller,
              context: context,
              isLogin: readGetStorage(loginKey),
            ),
            _widgetTab(
              'deleteAnAccount',
              -1,
              active: controller.optionTap.value == -1,
              isDelete: true,
              controller: controller,
              context: context,
              isLogin: readGetStorage(loginKey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetTab(
    String text,
    int intTap, {
    required bool active,
    bool isDelete = false,
    required ProfileController controller,
    required BuildContext context,
    required dynamic isLogin,
  }) {
    return InkWell(
      onTap: () {
        controller.optionTap.value = intTap;
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? (isDelete ? Colors.red : greenColor)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.transparent : greyColor2.withOpacity(0.2),
          ),
        ),
        child: widgetText(
          context,
          text.tr,
          fontSize: 13,
          color: active
              ? Colors.white
              : (themeModeValue == 'dark' ? Colors.white70 : darkColor),
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // --- DYNAMIC CONTENT BODY ---
  Widget _buildDynamicContent(
    BuildContext context,
    bool isDark,
    ProfileController controller,
    dynamic isLogin,
  ) {
    return Obx(() {
      int tap = controller.optionTap.value;
      if (tap == 0) return _viewPersonalSection(context, isLogin, controller);
      if (tap == 3) return _editPersonalSection(context, controller);
      if (tap == 1) return _viewContactSection(context, isLogin, controller);
      if (tap == 4) return _editContactSection(context, controller);
      if (tap == 2) return _viewSecuritySection(context, controller);
      if (tap == 5) return _editSecuritySection(context, controller);
      if (tap == -1) return _deleteAccountSection(context, isLogin, controller);
      return const SizedBox();
    });
  }

  // --- TAB 0: VIEW PERSONAL ---
  Widget _viewPersonalSection(
    BuildContext context,
    dynamic isLogin,
    ProfileController controller,
  ) {
    // Wrap in Obx and re-read from storage to react to updates
    return Obx(() {
      // Trigger rebuild when optionTap changes (forces re-read from storage)
      controller.optionTap.value;
      // Re-read fresh data from storage
      final freshLogin = readGetStorage(loginKey);

      // Helper to get name with fallback to Arabic if English is empty
      String getName(String? arabic, String? english) {
        if (language == "ar") {
          return arabic ?? '';
        } else {
          // If English name exists and is not empty, use it; otherwise fallback to Arabic
          return (english != null && english.isNotEmpty)
              ? english
              : (arabic ?? '');
        }
      }

      // Get gender description
      String genderText = '';
      int? genderId = freshLogin?['GenderID'];
      if (genderId != null && controller.genders.isNotEmpty) {
        var gender = controller.genders.firstWhereOrNull(
          (g) => g.id == genderId,
        );
        genderText = gender?.description ?? '';
      }

      // Get country description
      String countryText = '';
      int? countryId = freshLogin?['CountryID'];
      if (countryId != null && controller.countries.isNotEmpty) {
        var country = controller.countries.firstWhereOrNull(
          (c) => c.id == countryId,
        );
        countryText = country?.description ?? '';
      }

      // Get city description
      String cityText = '';
      int? cityId = freshLogin?['CityID'];
      if (cityId != null && controller.cities.isNotEmpty) {
        var city = controller.cities.firstWhereOrNull((c) => c.id == cityId);
        cityText = city?.description ?? '';
      }

      // Get account type description
      String accountTypeText = '';
      String? custGroupId = freshLogin?['CustGroupID'];
      if (custGroupId != null && controller.listUserAccountTypes.isNotEmpty) {
        var accountType = controller.listUserAccountTypes.firstWhereOrNull(
          (a) => a.id == custGroupId,
        );
        if (accountType != null) {
          accountTypeText = language == 'ar'
              ? accountType.descriptionAr
              : accountType.descriptionEn;
        }
      }

      return Column(
        children: [
          // Names
          _buildDataRow(
            context,
            'firstName'.tr,
            getName(freshLogin?['FirstNameAr'], freshLogin?['FirstNameEn']),
          ),
          _buildDataRow(
            context,
            'middleName'.tr,
            getName(freshLogin?['MiddleNameAr'], freshLogin?['MiddleNameEn']),
          ),
          _buildDataRow(
            context,
            'grandfatherName'.tr,
            getName(
              freshLogin?['GrandFatherNameAr'],
              freshLogin?['GrandFatherNameEn'],
            ),
          ),
          _buildDataRow(
            context,
            'lastName'.tr,
            getName(freshLogin?['LastNameAr'], freshLogin?['LastNameEn']),
          ),

          // Gender
          if (genderText.isNotEmpty)
            _buildDataRow(context, 'gender'.tr, genderText),

          // Country & City
          if (countryText.isNotEmpty)
            _buildDataRow(context, 'country'.tr, countryText),
          if (cityText.isNotEmpty) _buildDataRow(context, 'city'.tr, cityText),

          // Address
          if (freshLogin?['Address'] != null &&
              freshLogin['Address'].toString().isNotEmpty)
            _buildDataRow(
              context,
              'theAddress'.tr,
              freshLogin?['Address'] ?? '',
            ),

          // Account Type
          if (accountTypeText.isNotEmpty)
            _buildDataRow(context, 'accountType'.tr, accountTypeText),

          // Identity Number or Commercial Registration (based on account type)
          if (freshLogin?['IdentityNumber'] != null &&
              freshLogin['IdentityNumber'].toString().isNotEmpty)
            _buildDataRow(
              context,
              'identityNumber'.tr,
              freshLogin?['IdentityNumber'] ?? '',
            ),
          if (freshLogin?['TradeNo'] != null &&
              freshLogin['TradeNo'].toString().isNotEmpty)
            _buildDataRow(
              context,
              'commercialRegistration'.tr,
              freshLogin?['TradeNo'] ?? '',
            ),

          const SizedBox(height: 12),
          widgetButton(
            context,
            'edit'.tr,
            colorButton: greenColor,
            colorText: Colors.white,
            onTap: () {
              controller.reloadFormData(); // Ensure fields are fresh
              controller.isProgress.value = false; // Reset loading state
              controller.optionTap.value = 3;
            },
          ),
        ],
      );
    });
  }

  // --- TAB 3: EDIT PERSONAL ---
  Widget _editPersonalSection(
    BuildContext context,
    ProfileController controller,
  ) {
    return Obx(
      () => Column(
        children: [
          // Arabic Names Section
          widgetText(
            context,
            'arabicNames'.tr,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          const SizedBox(height: 8),
          widgetTextForm(
            context,
            controller: controller.controllerFistName,
            hintText: 'firstName'.tr + 'arabicSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerMiddleName,
            hintText: 'middleName'.tr + 'arabicSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerGrandFatherName,
            hintText: 'grandfatherName'.tr + 'arabicSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerLastName,
            hintText: 'lastName'.tr + 'arabicSuffix'.tr,
          ),

          const SizedBox(height: 16),

          // English Names Section
          widgetText(
            context,
            'englishNames'.tr,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          const SizedBox(height: 8),
          widgetTextForm(
            context,
            controller: controller.controllerFirstNameEn,
            hintText: 'firstName'.tr + 'englishSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerMiddleNameEn,
            hintText: 'middleName'.tr + 'englishSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerGrandFatherNameEn,
            hintText: 'grandfatherName'.tr + 'englishSuffix'.tr,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerLastNameEn,
            hintText: 'lastName'.tr + 'englishSuffix'.tr,
          ),

          const SizedBox(height: 16),

          // Gender Dropdown (Interactive)
          widgetText(context, 'gender'.tr, fontSize: 13, color: greyColor2),
          const SizedBox(height: 4),
          _buildGenderDropdownActive(controller, context),

          // Country Dropdown
          widgetText(context, 'country'.tr, fontSize: 13, color: greyColor2),
          const SizedBox(height: 4),
          _buildCountryDropdown(controller, context),

          // City Dropdown
          widgetText(context, 'city'.tr, fontSize: 13, color: greyColor2),
          const SizedBox(height: 4),
          _buildCityDropdown(controller, context),

          // Address
          widgetTextForm(
            context,
            controller: controller.controllerAddress,
            hintText: 'theAddress'.tr,
          ),

          const SizedBox(height: 16),

          // Account Type Dropdown
          widgetText(
            context,
            'accountType'.tr,
            fontSize: 13,
            color: greyColor2,
          ),
          const SizedBox(height: 4),
          _buildAccountTypeDropdown(controller, context),

          // Dynamic Identity/CR Fields
          _buildDynamicDocumentSection(controller, context),

          const SizedBox(height: 12),
          widgetButton(
            context,
            'save'.tr,
            colorButton: greenColor,
            colorText: Colors.white,
            isProgress: controller.isProgress.value,
            onTap: () async {
              debugPrint("Save button clicked!");
              await controller.updateProfilePersonally();
              debugPrint("updateProfilePersonally returned!");
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 1: VIEW CONTACT ---
  Widget _viewContactSection(
    BuildContext context,
    dynamic isLogin,
    ProfileController controller,
  ) {
    return Obx(() {
      // Trigger rebuild when optionTap changes
      controller.optionTap.value;
      final freshLogin = readGetStorage(loginKey);

      return Column(
        children: [
          _buildDataRow(context, 'mobileNumber'.tr, freshLogin?['Phone'] ?? ''),
          _buildDataRow(context, 'email'.tr, freshLogin?['Email'] ?? ''),
          const SizedBox(height: 12),
          widgetButton(
            context,
            'edit'.tr,
            colorButton: greenColor,
            colorText: Colors.white,
            onTap: () {
              controller.isProgress.value = false; // Reset loading state
              controller.optionTap.value = 4;
            },
          ),
        ],
      );
    });
  }

  // --- TAB 4: EDIT CONTACT ---
  Widget _editContactSection(
    BuildContext context,
    ProfileController controller,
  ) {
    return Obx(
      () => Column(
        children: [
          _widgetPhoneNumber(context, controller, isEnabled: true),
          widgetTextForm(
            context,
            controller: controller.controllerEmail,
            hintText: 'email'.tr,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          widgetButton(
            context,
            'save'.tr,
            colorButton: greenColor,
            colorText: Colors.white,
            isProgress: controller.isProgress.value,
            onTap: () => controller.updatePasswordContactInformation(),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: VIEW SECURITY ---
  Widget _viewSecuritySection(
    BuildContext context,
    ProfileController controller,
  ) {
    return Column(
      children: [
        _buildDataRow(context, 'currentPassword'.tr, '********'),
        const SizedBox(height: 12),
        widgetButton(
          context,
          'edit'.tr,
          colorButton: greenColor,
          colorText: Colors.white,
          onTap: () {
            controller.isProgress.value = false; // Reset loading state
            controller.optionTap.value = 5;
          },
        ),
      ],
    );
  }

  // --- TAB 5: EDIT SECURITY ---
  Widget _editSecuritySection(
    BuildContext context,
    ProfileController controller,
  ) {
    return Obx(
      () => Column(
        children: [
          widgetTextForm(
            context,
            controller: controller.controllerCurrentPassword,
            hintText: 'currentPassword'.tr,
            obscureText: true,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerNewPassword,
            hintText: 'newPassword'.tr,
            obscureText: true,
          ),
          widgetTextForm(
            context,
            controller: controller.controllerReNewPassword,
            hintText: 'retypePassword'.tr,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          widgetButton(
            context,
            'changing'.tr,
            colorButton: greenColor,
            colorText: Colors.white,
            isProgress: controller.isProgress.value,
            onTap: () => controller.updatePassword(),
          ),
        ],
      ),
    );
  }

  Widget _deleteAccountSection(
    BuildContext context,
    dynamic isLogin,
    ProfileController controller,
  ) {
    return Column(
      children: [
        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        widgetText(
          context,
          'deleteAccountConfirmationTitle'.tr,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        const SizedBox(height: 12),
        widgetText(
          context,
          'deleteAccountConfirmationMessage'.tr,
          textAlign: TextAlign.center,
          fontSize: 14,
          color: greyColor2,
        ),
        const SizedBox(height: 32),
        widgetButton(
          context,
          'deleteAnAccount'.tr,
          colorButton: Colors.red,
          colorText: Colors.white,
          onTap: () {
            if (isLogin != null) {
              controller.deleteMyAccountFunction(
                isLogin['Email'] ?? '',
                isLogin['Phone'] ?? '',
                isLogin['IdentityNumber'] ?? '',
              );
            }
          },
        ),
        const SizedBox(height: 12),
        widgetButton(
          context,
          'cancel'.tr,
          colorButton: Colors.grey.withOpacity(0.2),
          colorText: themeModeValue == 'dark' ? Colors.white : darkColor,
          onTap: () {
            controller.optionTap.value = 0;
          },
        ),
      ],
    );
  }

  // --- HELPER COMPONENTS ---
  Widget _buildDataRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widgetText(context, label, color: greyColor2, fontSize: 12),
          const SizedBox(height: 4),
          widgetText(
            context,
            value?.toString() ?? '',
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: greyColor2.withOpacity(0.1)),
        ],
      ),
    );
  }

  Widget _buildGenderPicker(
    ProfileController controller,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Radio(
            value: 1,
            groupValue: controller.idGender.value,
            activeColor: greenColor,
            onChanged: (v) {},
          ),
          widgetText(context, 'male'.tr, fontSize: 14),
          const SizedBox(width: 20),
          Radio(
            value: 2,
            groupValue: controller.idGender.value,
            activeColor: greenColor,
            onChanged: (v) {},
          ),
          widgetText(context, 'female'.tr, fontSize: 14),
        ],
      ),
    );
  }

  Widget _widgetPhoneNumber(
    BuildContext context,
    ProfileController controller, {
    bool isEnabled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: themeModeValue == 'light'
              ? greyColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: controller.controllerPhoneNumber,
            readOnly: !isEnabled,
            onChanged: (number) {
              controller.phoneNumber = number;
              controller.validatePhoneNumber.value = number.isNotEmpty;
            },
            style: TextStyle(
              color: themeModeValue == 'dark' ? Colors.white : darkColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'mobileNumber'.tr,
            ),
          ),
        ),
      ),
    );
  }

  // --- DIALOGS (UI CLEANED) ---
  Future _showDialogUploadImageFromGalleryOrCameraForLogo(
    ProfileController controller,
    BuildContext context,
  ) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            widgetText(context, 'chooseAPhoto'.tr, fontWeight: FontWeight.bold),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dialogIcon(svgLogoCamera, () async {
                  XFile? file = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (file != null) {
                    controller.imageProfileBase64.value = base64.encode(
                      await file.readAsBytes(),
                    );
                    controller.updateLogo();
                  }
                  Get.back();
                }),
                _dialogIcon(svgLogoLibrary, () async {
                  XFile? file = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null) {
                    controller.imageProfileBase64.value = base64.encode(
                      await file.readAsBytes(),
                    );
                    controller.updateLogo();
                  }
                  Get.back();
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _dialogIcon(String icon, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: SvgPicture.asset(icon, height: 50));
  }

  // --- NEW HELPER METHODS FOR ENHANCED PROFILE ---

  // Interactive Gender Dropdown (replaces disabled radio buttons)
  Widget _buildGenderDropdownActive(
    ProfileController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: themeModeValue == 'light'
              ? greyColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Obx(() {
          var genders = controller.genders;

          // If no genders loaded from API, use fallback
          if (genders.isEmpty) {
            // Check if current value is valid for fallback (1 or 2)
            int? currentGenderValue = controller.idGender.value;
            bool isValidFallback =
                currentGenderValue == 1 || currentGenderValue == 2;

            return DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: isValidFallback ? currentGenderValue : null,
                hint: widgetText(context, 'selectGender'.tr, fontSize: 14),
                items: [
                  DropdownMenuItem<int>(
                    value: 1,
                    child: widgetText(context, 'male'.tr, fontSize: 14),
                  ),
                  DropdownMenuItem<int>(
                    value: 2,
                    child: widgetText(context, 'female'.tr, fontSize: 14),
                  ),
                ],
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    controller.idGender.value = newValue;
                  }
                },
              ),
            );
          }

          // Check if current value exists in loaded genders
          int? currentValue = controller.idGender.value;
          bool valueExists = genders.any((g) => g.id == currentValue);

          // Use actual gender data from API
          return DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: valueExists ? currentValue : null,
              hint: widgetText(context, 'selectGender'.tr, fontSize: 14),
              items: genders.map((gender) {
                return DropdownMenuItem<int>(
                  value: gender.id,
                  child: widgetText(context, gender.description, fontSize: 14),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  controller.idGender.value = newValue;
                  var selectedGender = genders.firstWhereOrNull(
                    (g) => g.id == newValue,
                  );
                  if (selectedGender != null) {
                    controller.selectedGender.value = selectedGender;
                  }
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // Country Dropdown
  Widget _buildCountryDropdown(
    ProfileController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: themeModeValue == 'light'
              ? greyColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Obx(() {
          var countries = controller.countries;
          var selected = controller.selectedCountry.value;

          // Safety check: ensure selected value exists in the list
          // Deduplicate items by ID
          var seenIds = <int>{};
          var uniqueItems = countries
              .where((item) => seenIds.add(item.id))
              .toList();

          int? currentId = selected?.id;
          bool valueExists =
              currentId != null && uniqueItems.any((c) => c.id == currentId);

          return DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: valueExists ? currentId : null,
              hint: widgetText(context, 'selectCountry'.tr, fontSize: 14),
              items: uniqueItems.map((country) {
                return DropdownMenuItem<int>(
                  value: country.id,
                  child: widgetText(context, country.description, fontSize: 14),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  var country = countries.firstWhereOrNull(
                    (c) => c.id == newValue,
                  );
                  if (country != null) {
                    controller.selectedCountry.value = country;
                    controller.countryID.value = country.id;
                    controller.filterCities(country.id);
                    // Reset city selection
                    controller.selectedCity.value = null;
                    controller.cityID.value = null;
                  }
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // City Dropdown (filtered by country)
  Widget _buildCityDropdown(
    ProfileController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: themeModeValue == 'light'
              ? greyColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Obx(() {
          var cities = controller.filteredCities;
          var selected = controller.selectedCity.value;

          // Safety check: ensure selected value exists in the list
          // Deduplicate items by ID
          var seenIds = <int>{};
          var uniqueItems = cities
              .where((item) => seenIds.add(item.id))
              .toList();

          int? currentId = selected?.id;
          bool valueExists =
              currentId != null && uniqueItems.any((c) => c.id == currentId);

          return DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: valueExists ? currentId : null,
              hint: widgetText(context, 'selectCity'.tr, fontSize: 14),
              items: uniqueItems.map((city) {
                return DropdownMenuItem<int>(
                  value: city.id,
                  child: widgetText(context, city.description, fontSize: 14),
                );
              }).toList(),
              onChanged: uniqueItems.isNotEmpty
                  ? (int? newValue) {
                      if (newValue != null) {
                        var city = cities.firstWhereOrNull(
                          (c) => c.id == newValue,
                        );
                        if (city != null) {
                          controller.selectedCity.value = city;
                          controller.cityID.value = city.id;
                        }
                      }
                    }
                  : null,
            ),
          );
        }),
      ),
    );
  }

  // Account Type Dropdown
  Widget _buildAccountTypeDropdown(
    ProfileController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: themeModeValue == 'light' ? Colors.white : buttonDarkColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: themeModeValue == 'light'
              ? greyColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Obx(() {
          var accountTypes = controller.listUserAccountTypes;
          var selected = controller.selectedAccountType.value;

          // Safety check: ensure selected value exists in the list
          // Deduplicate items by ID
          var seenIds = <String>{};
          var uniqueItems = accountTypes
              .where((item) => seenIds.add(item.id))
              .toList();

          String? currentId = selected?.id;
          bool valueExists =
              currentId != null && uniqueItems.any((a) => a.id == currentId);

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: valueExists ? currentId : null,
              hint: widgetText(context, 'selectAccountType'.tr, fontSize: 14),
              items: uniqueItems.map((accountType) {
                String description = language == 'ar'
                    ? accountType.descriptionAr
                    : accountType.descriptionEn;
                return DropdownMenuItem<String>(
                  value: accountType.id,
                  child: widgetText(context, description, fontSize: 14),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  var accountType = accountTypes.firstWhereOrNull(
                    (a) => a.id == newValue,
                  );
                  if (accountType != null) {
                    controller.selectedAccountType.value = accountType;
                    controller.custGroupID.value = accountType.id;
                    // Set identity type: 1 = Identity, 2 = CR
                    controller.identityType.value = accountType.needIdentity
                        ? 1
                        : 2;

                    // Clear opposite field when switching types
                    if (accountType.needIdentity) {
                      controller.controllerCRNumber.clear();
                      controller.crImageBase64.value = null;
                    } else {
                      controller.controllerIdentityNumber.clear();
                      controller.identityImageBase64.value = null;
                    }
                  }
                }
              },
            ),
          );
        }),
      ),
    );
  }

  // Dynamic Document Fields (Identity vs CR)
  Widget _buildDynamicDocumentSection(
    ProfileController controller,
    BuildContext context,
  ) {
    return Obx(() {
      int identityType = controller.identityType.value;

      if (identityType == 1) {
        // Identity Card fields
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            widgetTextForm(
              context,
              controller: controller.controllerIdentityNumber,
              hintText: 'identityNumber'.tr,
            ),
            widgetText(
              context,
              'identityImage'.tr,
              fontSize: 13,
              color: greyColor2,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: themeModeValue == 'light'
                    ? Colors.grey[100]
                    : buttonDarkColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.badge, color: greenColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: widgetText(
                      context,
                      controller.identityImageBase64.value != null &&
                              controller.identityImageBase64.value!.isNotEmpty
                          ? 'identityImageUploaded'.tr
                          : 'noIdentityImage'.tr,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else if (identityType == 2) {
        // Commercial Registration fields
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            widgetTextForm(
              context,
              controller: controller.controllerCRNumber,
              hintText: 'commercialRegistration'.tr,
            ),
            widgetText(context, 'crImage'.tr, fontSize: 13, color: greyColor2),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: themeModeValue == 'light'
                    ? Colors.grey[100]
                    : buttonDarkColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.business, color: greenColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: widgetText(
                      context,
                      controller.crImageBase64.value != null &&
                              controller.crImageBase64.value!.isNotEmpty
                          ? 'crImageUploaded'.tr
                          : 'noCRImage'.tr,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
