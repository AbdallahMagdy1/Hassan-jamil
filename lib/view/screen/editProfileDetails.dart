import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/profileController.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/globalUI.dart';

class EditProfileDetails extends StatefulWidget {
  const EditProfileDetails({super.key});

  @override
  State<StatefulWidget> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
  var controller = Get.put(ProfileController());

  // --- UI DECORATION TOOLKIT (Matching Settings Page) ---
  BoxDecoration _containerDecoration(bool isDark) {
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

  @override
  Widget build(BuildContext context) {
    bool isDark = themeModeValue == 'dark';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? darkColor : Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
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
          'editProfile'.tr,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * .05,
            vertical: 20,
          ),
          child: Column(
            children: [
              // SECTION: PROFILE IMAGE CARD
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                width: double.infinity,
                decoration: _containerDecoration(isDark),
                child: Column(
                  children: [
                    _buildAvatarStack(isDark),
                    const SizedBox(height: 12),
                    widgetText(
                      context,
                      'chooseAPhoto'.tr,
                      fontSize: 13,
                      color: greyColor2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SECTION: FORM FIELDS CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _containerDecoration(isDark),
                child: Column(
                  children: [
                    // First & Middle Name Row
                    Row(
                      children: [
                        Expanded(
                          child: widgetTextForm(
                            context,
                            controller: controller.controllerFistName,
                            errorText: controller.validateFirstName.value
                                ? 'pleaseEnterFirstName'.tr
                                : null,
                            onChanged: (v) {
                              controller.validateFirstName.value = v.isEmpty;
                              setState(() {});
                            },
                            hintText: 'firstName'.tr,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: widgetTextForm(
                            context,
                            controller: controller.controllerMiddleName,
                            errorText: controller.validateMiddleName.value
                                ? 'pleaseEnterMiddleName'.tr
                                : null,
                            onChanged: (v) {
                              controller.validateMiddleName.value = v.isEmpty;
                              setState(() {});
                            },
                            hintText: 'middleName'.tr,
                          ),
                        ),
                      ],
                    ),

                    // Grandfather & Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: widgetTextForm(
                            context,
                            controller: controller.controllerGrandFatherName,
                            errorText: controller.validateGrandFatherName.value
                                ? 'pleaseEnterGrandfatherName'.tr
                                : null,
                            onChanged: (v) {
                              controller.validateGrandFatherName.value =
                                  v.isEmpty;
                              setState(() {});
                            },
                            hintText: 'grandfatherName'.tr,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: widgetTextForm(
                            context,
                            controller: controller.controllerLastName,
                            errorText: controller.validateLastName.value
                                ? 'pleaseEnterLastName'.tr
                                : null,
                            onChanged: (v) {
                              controller.validateLastName.value = v.isEmpty;
                              setState(() {});
                            },
                            hintText: 'lastName'.tr,
                          ),
                        ),
                      ],
                    ),

                    widgetPhoneNumber(context),

                    // Identity Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: widgetTextForm(
                            context,
                            controller: controller.controllerIdentityNumber,
                            textInputType: TextInputType.number,
                            errorText: controller.validateIDNumber.value
                                ? 'pleaseEnterTheIDNumber'.tr
                                : null,
                            onChanged: (v) {
                              controller.validateIDNumber.value = v.length < 10;
                              setState(() {});
                            },
                            textDirection: TextDirection.ltr,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            hintText: 'identificationNumber'.tr,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _buildIdentityImageButton(isDark),
                        ),
                      ],
                    ),

                    widgetTextForm(
                      context,
                      controller: controller.controllerEmail,
                      errorText: controller.validateEmail.value
                          ? 'pleaseEnterTheEmail'.tr
                          : null,
                      onChanged: (v) {
                        controller.validateEmail.value = !v.isEmail;
                        setState(() {});
                      },
                      textDirection: TextDirection.ltr,
                      hintText: 'email'.tr,
                    ),

                    widgetTextForm(
                      context,
                      controller: controller.controllerAddress,
                      errorText: controller.validateTheAddress.value
                          ? 'pleaseEnterTheAddress'.tr
                          : null,
                      onChanged: (v) {
                        controller.validateTheAddress.value = v.isEmpty;
                        setState(() {});
                      },
                      hintText: 'theAddress'.tr,
                    ),

                    const SizedBox(height: 20),

                    // Save Button
                    Obx(
                      () => widgetButton(
                        context,
                        'save'.tr,
                        colorText: _isFormInvalid() ? darkColor : Colors.white,
                        colorButton: _isFormInvalid()
                            ? greyDarkColor
                            : greenColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        width: double.infinity,
                        isProgress: controller.isProgress.value,
                        onTap: () {
                          if (_isFormInvalid()) {
                            _triggerValidations();
                          } else {
                            controller.isProgress.value = true;
                            controller.updateProfile(
                              firstName: controller.controllerFistName.text,
                              middleName: controller.controllerMiddleName.text,
                              grandFatherName:
                                  controller.controllerGrandFatherName.text,
                              lastName: controller.controllerLastName.text,
                              logo: controller.imageProfileBase64.value,
                              email: controller.controllerEmail.text,
                              identificationNumber:
                                  controller.controllerIdentityNumber.text,
                              identityImage: controller.imageidentityBase64,
                              address: controller.controllerAddress.text,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI HELPER: AVATAR STACK ---
  Widget _buildAvatarStack(bool isDark) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: greenColor.withOpacity(0.2), width: 3),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: controller.imageProfileBase64.value == null
                  ? AssetImage(pngCharacter) as ImageProvider
                  : MemoryImage(
                      base64.decode(controller.imageProfileBase64.value!),
                    ),
            ),
          ),
        ),
        InkWell(
          onTap: () => showDialogUploadImageFromGalleryOrCamera(),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: greenColor,
            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // --- UI HELPER: IDENTITY BUTTON ---
  Widget _buildIdentityImageButton(bool isDark) {
    return InkWell(
      onTap: () =>
          showDialogUploadImageFromGalleryOrCameraForIdentificationNumber(),
      child: Container(
        height: 52, // Standard height to match text fields
        decoration: BoxDecoration(
          color: isDark ? buttonDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: greyColor.withOpacity(0.3)),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.badge_outlined, size: 18, color: greenColor),
            const SizedBox(width: 4),
            widgetText(
              context,
              controller.imageidentityBase64 == null
                  ? 'insertPhotoID'.tr
                  : 'editPhotoID'.tr,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  // --- FORM LOGIC (Keeping your original logic intact) ---
  bool _isFormInvalid() {
    return controller.controllerFistName.text.isEmpty ||
        controller.controllerMiddleName.text.isEmpty ||
        controller.controllerGrandFatherName.text.isEmpty ||
        controller.controllerLastName.text.isEmpty ||
        controller.controllerIdentityNumber.text.length < 10 ||
        controller.controllerAddress.text.isEmpty;
  }

  void _triggerValidations() {
    controller.validateFirstName.value =
        controller.controllerFistName.text.isEmpty;
    controller.validateMiddleName.value =
        controller.controllerMiddleName.text.isEmpty;
    controller.validateGrandFatherName.value =
        controller.controllerGrandFatherName.text.isEmpty;
    controller.validateLastName.value =
        controller.controllerLastName.text.isEmpty;
    controller.validateIDNumber.value =
        controller.controllerIdentityNumber.text.length < 10;
    controller.validateTheAddress.value =
        controller.controllerAddress.text.isEmpty;
    setState(() {});
  }

  Widget widgetPhoneNumber(context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 5),
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
            keyboardType: TextInputType.phone,
            controller: controller.controllerPhoneNumber,
            readOnly: true,
            style: TextStyle(
              color: themeModeValue == 'dark' ? Colors.white : darkColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  // --- DIALOGS (Styled to match the new UI) ---
  Future showDialogUploadImageFromGalleryOrCamera() {
    return Get.dialog(
      _buildStyledImageDialog('chooseAPhoto'.tr, (base64Str) {
        controller.imageProfileBase64.value = base64Str;
        setState(() {});
      }),
    );
  }

  Future showDialogUploadImageFromGalleryOrCameraForIdentificationNumber() {
    return Get.dialog(
      _buildStyledImageDialog(
        controller.imageidentityBase64 == null
            ? 'insertPhotoID'.tr
            : 'editPhotoID'.tr,
        (base64Str) {
          controller.imageidentityBase64 = base64Str;
          setState(() {});
        },
        previewImage: controller.imageidentityBase64,
      ),
    );
  }

  Widget _buildStyledImageDialog(
    String title,
    Function(String) onImageSelected, {
    String? previewImage,
  }) {
    return AlertDialog(
      backgroundColor: themeModeValue == 'light' ? Colors.white : darkColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          widgetText(context, title, fontWeight: FontWeight.bold),
          if (previewImage != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64.decode(previewImage),
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dialogOption(
                svgLogoCamera,
                () => _pickImage(ImageSource.camera, onImageSelected),
              ),
              _dialogOption(
                svgLogoLibrary,
                () => _pickImage(ImageSource.gallery, onImageSelected),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _dialogOption(String asset, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: SvgPicture.asset(asset, height: 50));
  }

  Future<void> _pickImage(
    ImageSource source,
    Function(String) onSelected,
  ) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      Uint8List bytes = await file.readAsBytes();
      onSelected(base64.encode(bytes));
      Get.back();
    }
  }
}
