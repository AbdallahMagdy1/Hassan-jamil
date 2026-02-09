import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profileController.dart';
import '../../global/globalUI.dart';
import '../../model/settings.dart';
import '../../model/getUserAccountTypes.dart';

/// Dropdown for Gender selection
Widget buildGenderDropdown(
  ProfileController controller,
  BuildContext context, {
  bool enabled = true,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Obx(() {
        List<Gender> genders = controller.genders;
        Gender? selected = controller.selectedGender.value;

        return DropdownButtonHideUnderline(
          child: DropdownButton<Gender>(
            isExpanded: true,
            value: selected,
            hint: widgetText(context, 'gender'.tr, fontSize: 14),
            items: genders.map((Gender gender) {
              return DropdownMenuItem<Gender>(
                value: gender,
                child: widgetText(context, gender.description, fontSize: 14),
              );
            }).toList(),
            onChanged: enabled
                ? (Gender? newValue) {
                    if (newValue != null) {
                      controller.selectedGender.value = newValue;
                      controller.idGender.value = newValue.id;
                    }
                  }
                : null,
          ),
        );
      }),
    ),
  );
}

/// Dropdown for Country selection
Widget buildCountryDropdown(
  ProfileController controller,
  BuildContext context, {
  bool enabled = true,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Obx(() {
        List<Country> countries = controller.countries;
        Country? selected = controller.selectedCountry.value;

        return DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isExpanded: true,
            value: selected,
            hint: widgetText(context, 'country'.tr, fontSize: 14),
            items: countries.map((Country country) {
              return DropdownMenuItem<Country>(
                value: country,
                child: widgetText(context, country.description, fontSize: 14),
              );
            }).toList(),
            onChanged: enabled
                ? (Country? newValue) {
                    if (newValue != null) {
                      controller.selectedCountry.value = newValue;
                      controller.countryID.value = newValue.id;
                      controller.filterCities(newValue.id);
                      // Reset city selection when country changes
                      controller.selectedCity.value = null;
                      controller.cityID.value = null;
                    }
                  }
                : null,
          ),
        );
      }),
    ),
  );
}

/// Dropdown for City selection (filtered by country)
Widget buildCityDropdown(
  ProfileController controller,
  BuildContext context, {
  bool enabled = true,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Obx(() {
        List<City> cities = controller.filteredCities;
        City? selected = controller.selectedCity.value;

        return DropdownButtonHideUnderline(
          child: DropdownButton<City>(
            isExpanded: true,
            value: selected,
            hint: widgetText(context, 'city'.tr, fontSize: 14),
            items: cities.map((City city) {
              return DropdownMenuItem<City>(
                value: city,
                child: widgetText(context, city.description, fontSize: 14),
              );
            }).toList(),
            onChanged: enabled && cities.isNotEmpty
                ? (City? newValue) {
                    if (newValue != null) {
                      controller.selectedCity.value = newValue;
                      controller.cityID.value = newValue.id;
                    }
                  }
                : null,
          ),
        );
      }),
    ),
  );
}

/// Dropdown for Account Type selection
Widget buildAccountTypeDropdown(
  ProfileController controller,
  BuildContext context, {
  bool enabled = true,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Obx(() {
        List<GetUserAccountTypes> accountTypes =
            controller.listUserAccountTypes;
        GetUserAccountTypes? selected = controller.selectedAccountType.value;

        return DropdownButtonHideUnderline(
          child: DropdownButton<GetUserAccountTypes>(
            isExpanded: true,
            value: selected,
            hint: widgetText(context, 'clientType'.tr, fontSize: 14),
            items: accountTypes.map((GetUserAccountTypes accountType) {
              String description = language == 'ar'
                  ? accountType.descriptionAr
                  : accountType.descriptionEn;
              return DropdownMenuItem<GetUserAccountTypes>(
                value: accountType,
                child: widgetText(context, description, fontSize: 14),
              );
            }).toList(),
            onChanged: enabled
                ? (GetUserAccountTypes? newValue) {
                    if (newValue != null) {
                      controller.selectedAccountType.value = newValue;
                      controller.custGroupID.value = newValue.id;
                      // Set identity type: 1 = Identity, 2 = CR
                      controller.identityType.value = newValue.needIdentity
                          ? 1
                          : 2;

                      // Clear opposite field when switching types
                      if (newValue.needIdentity) {
                        controller.controllerCRNumber.clear();
                        controller.crImageBase64.value = null;
                      } else {
                        controller.controllerIdentityNumber.clear();
                        controller.identityImageBase64.value = null;
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

/// Dynamic fields based on Account Type (Identity vs CR)
Widget buildDynamicDocumentFields(
  ProfileController controller,
  BuildContext context, {
  bool enabled = true,
}) {
  return Obx(() {
    int identityType = controller.identityType.value;

    if (identityType == 1) {
      // Identity Card fields
      return Column(
        children: [
          widgetTextForm(
            context,
            controller: controller.controllerIdentityNumber,
            hintText: 'identificationNumber'.tr,
          ),
          const SizedBox(height: 8),
          widgetText(
            context,
            'identityImage'.tr,
            fontSize: 13,
            color: greyColor2,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeModeValue == 'light'
                  ? Colors.grey[100]
                  : buttonDarkColor,
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
                        ? 'imageUploaded'.tr
                        : 'noImageUploaded'.tr,
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
        children: [
          widgetTextForm(
            context,
            controller: controller.controllerCRNumber,
            hintText: 'commercialRegistration'.tr,
          ),
          const SizedBox(height: 8),
          widgetText(context, 'crImage'.tr, fontSize: 13, color: greyColor2),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeModeValue == 'light'
                  ? Colors.grey[100]
                  : buttonDarkColor,
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
                        ? 'imageUploaded'.tr
                        : 'noImageUploaded'.tr,
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
