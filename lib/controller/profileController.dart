import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/verificationController.dart';
import 'package:hj_app/global/globalUI.dart';
import 'package:hj_app/global/globalUrl.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:hj_app/model/getUserAccountTypes.dart';
import 'package:hj_app/model/settings.dart';
import 'package:hj_app/view/screen/globalWebView.dart';
import 'package:hj_app/view/screen/profileDetails.dart';
import 'package:hj_app/view/screen/splash.dart';
import 'package:http/http.dart' as HttpMethod;

class ProfileController extends GetxController {
  RxInt idGender = 1.obs;
  RxBool isProgress = false.obs;
  RxBool isProgressImage = false.obs;
  RxBool isProgressChangeProfileDetails = false.obs;
  RxInt optionTap = 0.obs;

  // Arabic name controllers
  TextEditingController controllerFistName = TextEditingController();
  TextEditingController controllerMiddleName = TextEditingController();
  TextEditingController controllerGrandFatherName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();

  // English name controllers
  TextEditingController controllerFirstNameEn = TextEditingController();
  TextEditingController controllerMiddleNameEn = TextEditingController();
  TextEditingController controllerGrandFatherNameEn = TextEditingController();
  TextEditingController controllerLastNameEn = TextEditingController();

  // Other controllers
  TextEditingController controllerIdentityNumber = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();

  // Commercial Registration controller
  TextEditingController controllerCRNumber = TextEditingController();

  TextEditingController controllerCurrentPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerReNewPassword = TextEditingController();

  // Account types
  List<GetUserAccountTypes> listUserAccountTypes = <GetUserAccountTypes>[].obs;
  List<GetUserAccountTypes> userAccountTypesTheChosen =
      <GetUserAccountTypes>[].obs;

  // Settings (countries, cities, genders)
  Rxn<Settings> settings = Rxn<Settings>();
  RxList<Country> countries = <Country>[].obs;
  RxList<City> cities = <City>[].obs;
  RxList<City> filteredCities = <City>[].obs;
  RxList<Gender> genders = <Gender>[].obs;

  // Selected values
  Rxn<Country> selectedCountry = Rxn<Country>();
  Rxn<City> selectedCity = Rxn<City>();
  Rxn<Gender> selectedGender = Rxn<Gender>();
  Rxn<GetUserAccountTypes> selectedAccountType = Rxn<GetUserAccountTypes>();

  // IDs
  RxnInt countryID = RxnInt();
  RxnInt cityID = RxnInt();
  RxnString custGroupID = RxnString();

  // Identity type: 1 = Identity Card, 2 = Commercial Registration
  RxInt identityType = 0.obs;

  // Images
  RxnString imageProfileBase64 = RxnString();
  RxnString identityImageBase64 = RxnString();
  RxnString crImageBase64 = RxnString();
  var imageidentityBase64; // Keep for backward compatibility

  // Validation states
  RxBool validateFirstName = false.obs;
  RxBool validateMiddleName = false.obs;
  RxBool validateGrandFatherName = false.obs;
  RxBool validateIDNumber = false.obs;
  RxBool validateEmail = false.obs;
  RxBool validateTheAddress = false.obs;
  RxBool validateLastName = false.obs;
  RxBool validateChangePassword = false.obs;
  RxBool validatePhoneNumber = true.obs;
  RxBool validateCountry = false.obs;
  RxBool validateCity = false.obs;
  RxBool validateAccountType = false.obs;
  RxBool validateCRNumber = false.obs;

  var phoneNumber;
  var isLogin = readGetStorage(loginKey);

  @override
  void onInit() {
    // Load user account types
    if (readGetStorage(listUserAccountTypesKey) != null) {
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(
        readGetStorage(listUserAccountTypesKey),
      );
    } else {
      if (isLogin != null) {
        VerificationControl verificationControl = VerificationControl();
        verificationControl.getUserAccountTypes2(Get.context, isLogin['Phone']);
      }
    }

    if (isLogin == null) {
      return;
    }

    // Load settings (countries, cities, genders)
    getSettings();

    // Initialize Arabic name fields
    controllerFistName.text = isLogin['FirstNameAr']?.toString() ?? '';
    controllerMiddleName.text = isLogin['MiddleNameAr']?.toString() ?? '';
    controllerGrandFatherName.text =
        isLogin['GrandFatherNameAr']?.toString() ?? '';
    controllerLastName.text = isLogin['LastNameAr']?.toString() ?? '';

    // Initialize English name fields
    controllerFirstNameEn.text = isLogin['FirstNameEn']?.toString() ?? '';
    controllerMiddleNameEn.text = isLogin['MiddleNameEn']?.toString() ?? '';
    controllerGrandFatherNameEn.text =
        isLogin['GrandFatherNameEn']?.toString() ?? '';
    controllerLastNameEn.text = isLogin['LastNameEn']?.toString() ?? '';

    // Initialize other fields
    controllerIdentityNumber.text = isLogin['IdentityNumber']?.toString() ?? '';
    controllerCRNumber.text = isLogin['TradeNo']?.toString() ?? '';
    controllerEmail.text = isLogin['Email']?.toString() ?? '';
    controllerAddress.text = isLogin['Address']?.toString() ?? '';
    controllerPhoneNumber.text = isLogin['Phone']?.toString() ?? '';

    // Initialize images
    imageProfileBase64.value = isLogin['Logo']?.toString();
    identityImageBase64.value = isLogin['IdentityImage']?.toString() ?? '';
    crImageBase64.value = isLogin['TradeNoImage']?.toString() ?? '';
    imageidentityBase64 =
        isLogin['IdentityImage']?.toString() ?? ''; // Backward compatibility

    // Initialize IDs
    var cID = isLogin['countryID'];
    countryID.value = cID != null ? int.tryParse(cID.toString()) : null;

    var ctID = isLogin['cityID'];
    cityID.value = ctID != null ? int.tryParse(ctID.toString()) : null;

    var cgID = isLogin['CustGroupID'];
    custGroupID.value = cgID?.toString();

    var gID = isLogin['GenderID'];
    idGender.value = gID != null ? int.tryParse(gID.toString()) ?? 1 : 1;

    // Determine identity type based on account type
    if (custGroupID.value != null && listUserAccountTypes.isNotEmpty) {
      var accountType = listUserAccountTypes.firstWhereOrNull(
        (e) => e.id == custGroupID.value,
      );
      if (accountType != null) {
        identityType.value = accountType.needIdentity ? 1 : 2;
        selectedAccountType.value = accountType;
      }
    }

    super.onInit();
  }

  // Load settings (countries, cities, genders) from API
  Future<void> getSettings() async {
    try {
      // 1. Try cache first
      var cachedSettings = readGetStorage('settingsCache');
      if (cachedSettings != null) {
        debugPrint("Loaded settings from cache");
        _parseAndApplySettings(cachedSettings);
      }

      // 2. Fetch fresh data from API
      var data = await myRequest(
        url: 'api/user/getSettings',
        otherBaseUrl: baseUrlWeb,
        method: HttpMethod.get,
        body: {},
      );

      // 3. Update cache and apply if successful
      if (data != null) {
        debugPrint("Fetched fresh settings from API");

        // Ensure data structure matches expected format
        Map<String, dynamic> settingsData = {
          'countries': data['countries'] ?? [],
          'cities': data['cities'] ?? [],
          'genders': data['genders'] ?? [],
        };

        // Save to cache
        await writeGetStorage('settingsCache', settingsData);

        // Apply
        _parseAndApplySettings(settingsData);
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
    }
  }

  void _parseAndApplySettings(Map<String, dynamic> data) {
    try {
      settings.value = Settings.fromJson(data);
      countries.value = settings.value!.countries;
      cities.value = settings.value!.cities;
      genders.value = settings.value!.genders;

      // Re-apply selections based on current IDs
      if (countryID.value != null) {
        selectedCountry.value = countries.firstWhereOrNull(
          (c) => c.id == countryID.value,
        );
        // Handle case where Country ID exists but not in list
        if (selectedCountry.value == null && countryID.value != null) {
          debugPrint(
            "Warning: Country ID ${countryID.value} not found in list.",
          );
          // Optional: Add a placeholder or clear
        } else if (selectedCountry.value != null) {
          filterCities(countryID.value!);
        }
      }

      if (cityID.value != null) {
        if (filteredCities.isNotEmpty) {
          selectedCity.value = filteredCities.firstWhereOrNull(
            (c) => c.id == cityID.value,
          );
        }
        // If city not found in filtered list
        if (selectedCity.value == null && cityID.value != null) {
          debugPrint(
            "Warning: City ID ${cityID.value} not found in filtered list.",
          );
        }
      }

      if (idGender.value != null) {
        var existingGender = genders.firstWhereOrNull(
          (g) => g.id == idGender.value,
        );

        if (existingGender != null) {
          selectedGender.value = existingGender;
        } else {
          debugPrint(
            "Warning: Gender ID ${idGender.value} not found in list. Adding temporary.",
          );
          // Valid fix: Add the missing gender to the list so dropdown doesn't crash/show empty
          var tempGender = Gender(
            id: idGender.value!,
            description: "Unknown (${idGender.value})",
          );
          genders.add(tempGender);
          selectedGender.value = tempGender;
        }
      }
    } catch (e) {
      debugPrint("Error parsing settings: $e");
    }
  }

  // Filter cities based on selected country
  void filterCities(int selectedCountryId) {
    if (cities.isEmpty) return;

    var country = countries.firstWhereOrNull((c) => c.id == selectedCountryId);
    if (country != null) {
      filteredCities.value = cities.where((city) {
        return city.code == country.code;
      }).toList();
    } else {
      filteredCities.clear();
    }
  }

  // Validation: Check if phone number exists
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      var data = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": SiteNewPhoneNumberExisting,
          "Values": {"phoneNumber": phoneNumber},
        },
      );
      return data == true;
    } catch (e) {
      debugPrint("Error checking phone number: $e");
      return false;
    }
  }

  // Validation: Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      var data = await myRequest(
        url: func,
        otherBaseUrl: baseUrlWeb,
        method: HttpMethod.post,
        body: {
          "Name": SiteNewEmailExisting,
          "Values": {"email": email.trim()},
        },
      );
      return data == true;
    } catch (e) {
      debugPrint("Error checking email: $e");
      return false;
    }
  }

  // Validation: Check if identity number exists
  Future<bool> checkIdentityExists(String identity) async {
    try {
      var data = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": SiteNewIdentityExisting,
          "Values": {"identity": identity, "guid": isLogin['GUID'] ?? ""},
        },
      );
      return data == true;
    } catch (e) {
      debugPrint("Error checking identity: $e");
      return false;
    }
  }

  // Validation: Check if CR number exists
  Future<bool> checkCRExists(String crNumber) async {
    try {
      var data = await myRequest(
        url: func,
        method: HttpMethod.post,
        body: {
          "Name": SiteNewCRExisting,
          "Values": {"identity": crNumber, "guid": isLogin['GUID'] ?? ""},
        },
      );
      return data == true;
    } catch (e) {
      debugPrint("Error checking CR: $e");
      return false;
    }
  }

  Future<void> updateProfile({
    firstName,
    middleName,
    grandFatherName,
    lastName,
    email,
    identificationNumber,
    identityImage,
    logo,
    address,
  }) async {
    isProgress.value = true;
    try {
      var data;
      if (language == "ar") {
        data = await myRequest(
          url: update,
          otherBaseUrl: baseUrlVisualbase,
          method: HttpMethod.put,
          body: {
            "Object": "web_users",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "Values": {
              "FirstNameAr": '$firstName',
              "MiddleNameAr": '$middleName',
              "GrandFatherNameAr": '$grandFatherName',
              "LastNameAr": '$lastName',
              "IdentityNumber": '$identificationNumber',
              "Email": '$email',
              "logo": imageProfileBase64,
              "Address": address,
              "IdentityImage": identityImage,
            },
            "ObjectSettings": {"MetaData": false},
          },
        );
      } else {
        data = await myRequest(
          url: update,
          otherBaseUrl: baseUrlVisualbase,
          method: HttpMethod.put,
          body: {
            "Object": "web_users",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "Values": {
              "FirstNameEn": '$firstName',
              "MiddleNameEn": '$middleName',
              "GrandFatherNameEN": '$grandFatherName',
              "LastNameEn": '$lastName',
              "IdentityNumber": '$identificationNumber',
              "Email": '$email',
              "logo": imageProfileBase64,
              "Address": address,
              "IdentityImage": identityImage,
            },
            "ObjectSettings": {"MetaData": false},
          },
        );
      }

      if (data != null && data['MessageNo'] == '202100000000008') {
        var data2 = await myRequest(
          url: details,
          otherBaseUrl: baseUrlVisualbase,
          method: HttpMethod.post,
          body: {
            "object": "web_users",
            "option": "column",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "objectsettings": {"metadata": false},
          },
        );
        if (data2 != null &&
            data2['ApiObjectData'] != null &&
            data2['ApiObjectData'].isNotEmpty) {
          writeGetStorage(loginKey, data2['ApiObjectData'][0]);
          isLogin = readGetStorage(loginKey);

          Future.delayed(const Duration(seconds: 2), () {
            isProgress.value = false;
            Get.to(const profileDetails());
          });
        } else {
          isProgress.value = false;
        }
      } else {
        isProgress.value = false;
      }
    } catch (e) {
      debugPrint("Error in updateProfile: $e");
      isProgress.value = false;
    }
  }

  // Helper to strip data:image/...;base64, header
  String? _stripBase64Header(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    if (base64String.contains(',')) {
      return base64String.split(',').last;
    }
    return base64String;
  }

  // Helper to refresh user data from API and update local storage
  Future<void> refreshUserData() async {
    try {
      debugPrint("Refreshing user data...");

      // MATCH WEB APP: Use Web API URL for details to ensure correct Arabic data
      // 'appmb' endpoint returns English names in Arabic fields sometimes.
      const webBaseUrl = "https://appw.hassanjameelapp.com/Visualbase/api/";

      var data = await myRequest(
        url: details,
        method: HttpMethod.post,
        otherBaseUrl: baseUrlVisualbase,

        body: {
          "object": "web_users",

          "option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "objectsettings": {"metadata": false},
        },
      );

      if (data != null &&
          data['ApiObjectData'] != null &&
          data['ApiObjectData'].isNotEmpty) {
        // Update local storage
        await writeGetStorage(loginKey, data['ApiObjectData'][0]);
        // Update in-memory variable
        isLogin = readGetStorage(loginKey);

        // Reload form fields with new data
        reloadFormData();

        debugPrint("User data refreshed successfully");
      } else {
        debugPrint("Failed to refresh user data: Empty response");
      }
    } catch (e) {
      debugPrint("Error refreshing user data: $e");
    }
  }

  Future<void> updateProfilePersonally() async {
    debugPrint("=== updateProfilePersonally STARTED ===");
    try {
      isProgress.value = true;

      // Prepare values - Clean headers from images
      String? cleanProfileImage = _stripBase64Header(imageProfileBase64.value);
      String? cleanIdentityImage = _stripBase64Header(
        identityImageBase64.value,
      );
      String? cleanCRImage = _stripBase64Header(crImageBase64.value);

      // MATCHING REACT KEYS EXACTLY
      var updateValues = {
        // camelCase names (matches React)
        "firstNameAr": controllerFistName.text,
        "middleNameAr": controllerMiddleName.text,
        "grandFatherNameAr":
            controllerGrandFatherName.text, // Guessing camelCase logic
        "lastNameAr": controllerLastName.text,

        // English names
        "firstNameEn": controllerFirstNameEn.text,
        "middleNameEn": controllerMiddleNameEn.text,
        "grandFatherNameEn": controllerGrandFatherNameEn.text,
        "lastNameEn": controllerLastNameEn.text,

        // Other fields - React uses PascalCase for these:
        "Address": controllerAddress.text,
        "GenderID": idGender.value,
        "Logo": cleanProfileImage,

        // React uses camelCase for these:
        "countryID": countryID.value,
        "cityID": cityID.value,

        "CustGroupID": custGroupID.value ?? isLogin['CustGroupID'],
        // Identity/CR logic below
      };

      // Add identity or CR fields based on account type
      if (identityType.value == 1) {
        // Identity card
        updateValues["IdentityNumber"] = controllerIdentityNumber.text;
        if (cleanIdentityImage != null && cleanIdentityImage.isNotEmpty) {
          updateValues["IdentityImage"] = cleanIdentityImage;
        }
      } else if (identityType.value == 2) {
        // Commercial Registration
        updateValues["TradeNo"] = controllerCRNumber.text;
        if (cleanCRImage != null && cleanCRImage.isNotEmpty) {
          updateValues["TradeNoImage"] = cleanCRImage;
        }
      }

      debugPrint("Sending Update Payload: $updateValues");

      var data = await myRequest(
        url: update,
        otherBaseUrl: baseUrlVisualbase,
        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where GUID = '${isLogin['GUID']}'",
          "Values": updateValues,
        },
      );

      debugPrint("Update Response: ${data?.toString()}");

      if (data != null &&
          (data['MessageNo'] == '202100000000008' ||
              data['MessageNo'] == 202100000000008)) {
        debugPrint("Update successful, refreshing data...");

        await refreshUserData();

        // Switch back to view mode
        optionTap.value = 0;
        Fluttertoast.showToast(msg: 'Profile updated successfully');
      } else {
        debugPrint("Update failed. MessageNo: ${data?['MessageNo']}");
        Fluttertoast.showToast(msg: 'Failed to update profile');
      }
    } catch (e, stackTrace) {
      debugPrint("=== EXCEPTION in updateProfilePersonally ===");
      debugPrint("Error: $e");
      debugPrint("StackTrace: $stackTrace");
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    } finally {
      isProgress.value = false;
      controllerCurrentPassword.clear();
      controllerNewPassword.clear();
      controllerReNewPassword.clear();
      debugPrint("=== updateProfilePersonally COMPLETED ===");
    }
  }

  // Reload all form fields with fresh data from storage (MATCHING WEB INITIAL_USER_DATA)
  void reloadFormData() {
    debugPrint("Reloading form data from storage (Web Parity Mode)...");
    var freshData = readGetStorage(loginKey);

    if (freshData != null) {
      debugPrint("Raw Storage Data: $freshData");

      // Helper to safely get string from map
      String getStr(List<String> keys) {
        for (var key in keys) {
          if (freshData[key] != null) return freshData[key].toString();
        }
        return '';
      }

      // 1. Arabic Names
      controllerFistName.text = getStr(['FirstNameAr', 'firstNameAr']);
      controllerMiddleName.text = getStr(['MiddleNameAr', 'middleNameAr']);
      controllerGrandFatherName.text = getStr([
        'GrandFatherNameAr',
        'grandFatherNameAr',
      ]);
      controllerLastName.text = getStr(['LastNameAr', 'lastNameAr']);

      // 2. English Names
      controllerFirstNameEn.text = getStr(['FirstNameEn', 'firstNameEn']);
      controllerMiddleNameEn.text = getStr(['MiddleNameEn', 'middleNameEn']);
      controllerGrandFatherNameEn.text = getStr([
        'GrandFatherNameEn',
        'grandFatherNameEn',
      ]);
      controllerLastNameEn.text = getStr(['LastNameEn', 'lastNameEn']);

      // 3. Contact & Address
      controllerEmail.text = getStr(['Email', 'email']);
      controllerAddress.text = getStr(['Address', 'address']);
      controllerPhoneNumber.text = getStr(['Phone', 'phone']);

      // 4. Identity & CR
      controllerIdentityNumber.text = getStr(['IdentityNumber', 'identity']);
      controllerCRNumber.text = getStr(['TradeNo', 'tradeNo', 'CR']);

      // 5. Images (Clean headers)
      imageProfileBase64.value = _stripBase64Header(getStr(['Logo', 'logo']));
      identityImageBase64.value = _stripBase64Header(
        getStr(['IdentityImage', 'identityImage']),
      );
      crImageBase64.value = _stripBase64Header(
        getStr(['TradeNoImage', 'tradeNoImage', 'CRImage']),
      );

      // 6. Dropdown IDs (Handle both string and int formats from API)
      // Country
      String cIDStr = getStr(['CountryID', 'countryID', 'countryId']);
      countryID.value = int.tryParse(cIDStr);

      // City
      String ctIDStr = getStr(['CityID', 'cityID', 'cityId']);
      cityID.value = int.tryParse(ctIDStr);

      // Gender
      String gIDStr = getStr(['GenderID', 'genderID', 'genderId']);
      idGender.value = int.tryParse(gIDStr) ?? 1;

      // CustGroup
      custGroupID.value = getStr(['CustGroupID', 'custGroupID', 'custGroupId']);

      debugPrint(
        "Parsed IDs -> Country: ${countryID.value}, City: ${cityID.value}, Gender: ${idGender.value}",
      );

      // 7. Trigger Logic (Match Web's setTimeout logic)
      if (countries.isNotEmpty && countryID.value != null) {
        selectedCountry.value = countries.firstWhereOrNull(
          (c) => c.id == countryID.value,
        );
        if (selectedCountry.value != null) {
          filterCities(countryID.value!);
          // Now set City if exists in filtered list
          if (cityID.value != null) {
            selectedCity.value = filteredCities.firstWhereOrNull(
              (c) => c.id == cityID.value,
            );
          }
        }
      }

      if (genders.isNotEmpty && idGender.value != null) {
        selectedGender.value = genders.firstWhereOrNull(
          (g) => g.id == idGender.value,
        );
      }

      debugPrint("Form data reloaded successfully (Web Parity)");
    } else {
      debugPrint("Error: No data found in storage key '$loginKey'");
    }
  }

  Future<void> updatePassword() async {
    try {
      isProgress.value = true;
      var passwordAfterMd5 = textToMd5(controllerNewPassword.text);
      var data = await myRequest(
        url: update,
        otherBaseUrl: baseUrlVisualbase,

        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {"Password": passwordAfterMd5},
          "ObjectSettings": {"MetaData": false},
        },
      );
      if (data != null && data['MessageNo'] == '202100000000008') {
        // Refresh user data
        var data2 = await myRequest(
          url: details,
          otherBaseUrl: baseUrlVisualbase,

          method: HttpMethod.post,
          body: {
            "object": "web_users",
            "option": "column",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "objectsettings": {"metadata": false},
          },
        );
        if (data2 != null &&
            data2['ApiObjectData'] != null &&
            data2['ApiObjectData'].isNotEmpty) {
          writeGetStorage(loginKey, data2['ApiObjectData'][0]);
          isLogin = readGetStorage(loginKey);

          // Reload form fields with fresh data
          reloadFormData();

          // Switch back to view mode
          optionTap.value = 2;
          Fluttertoast.showToast(msg: 'Password updated successfully');
        } else {
          debugPrint("Error: Empty response when refreshing user data");
          Fluttertoast.showToast(
            msg: 'Password updated but failed to refresh data',
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to update password');
      }
    } catch (e) {
      debugPrint("Error in updatePassword: $e");
      Fluttertoast.showToast(msg: 'An error occurred');
    } finally {
      isProgress.value = false;
      controllerCurrentPassword.clear();
      controllerNewPassword.clear();
      controllerReNewPassword.clear();
    }
  }

  Future<void> updatePasswordContactInformation() async {
    try {
      isProgress.value = true;
      var data = await myRequest(
        url: update,
        otherBaseUrl: baseUrlVisualbase,

        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {
            "Phone": phoneNumber != null
                ? '$phoneNumber'
                : '${isLogin['Phone']}',
            "Email": controllerEmail.text,
          },
          "ObjectSettings": {"MetaData": false},
        },
      );
      if (data != null && data['MessageNo'] == '202100000000008') {
        // Refresh user data
        var data2 = await myRequest(
          url: details,
          otherBaseUrl: baseUrlVisualbase,

          method: HttpMethod.post,
          body: {
            "object": "web_users",
            "option": "column",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "objectsettings": {"metadata": false},
          },
        );
        if (data2 != null &&
            data2['ApiObjectData'] != null &&
            data2['ApiObjectData'].isNotEmpty) {
          writeGetStorage(loginKey, data2['ApiObjectData'][0]);
          isLogin = readGetStorage(loginKey);

          // Reload form fields with fresh data
          reloadFormData();

          // Switch back to view mode
          optionTap.value = 1;
          Fluttertoast.showToast(
            msg: 'Contact information updated successfully',
          );
        } else {
          debugPrint("Error: Empty response when refreshing user data");
          Fluttertoast.showToast(
            msg: 'Update successful but failed to refresh data',
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to update contact information');
      }
    } catch (e) {
      debugPrint("Error in updatePasswordContactInformation: $e");
      Fluttertoast.showToast(msg: 'An error occurred');
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> updateLogo() async {
    try {
      isProgressImage.value = true;
      var data = await myRequest(
        url: update,
        otherBaseUrl: baseUrlVisualbase,

        method: HttpMethod.put,
        body: {
          "Object": "web_users",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {"logo": imageProfileBase64},
          "ObjectSettings": {"MetaData": false},
        },
      );
      if (data != null && data['MessageNo'] == '202100000000008') {
        // Refresh user data
        var data2 = await myRequest(
          url: details,
          otherBaseUrl: baseUrlVisualbase,

          method: HttpMethod.post,
          body: {
            "object": "web_users",
            "option": "column",
            "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
            "objectsettings": {"metadata": false},
          },
        );
        if (data2 != null &&
            data2['ApiObjectData'] != null &&
            data2['ApiObjectData'].isNotEmpty) {
          writeGetStorage(loginKey, data2['ApiObjectData'][0]);
          isLogin = readGetStorage(loginKey);
          Fluttertoast.showToast(msg: 'Profile image updated successfully');
        } else {
          debugPrint("Error: Empty response when refreshing user data");
          Fluttertoast.showToast(
            msg: 'Image uploaded but failed to refresh data',
          );
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to update profile image');
      }
    } catch (e) {
      debugPrint("Error in updateLogo: $e");
      Fluttertoast.showToast(msg: 'An error occurred');
    } finally {
      isProgressImage.value = false;
    }
  }

  Future<bool> userFound({
    required String access,
    required String accessType,
  }) async {
    isProgress.value = true;
    if (accessType == 'phonenumber') {
      access = '+966${access.trim().replaceFirst('+966', '')}';
    }
    var data = await myRequest(
      otherBaseUrl: administrationUrl,
      url: UserFound,
      method: HttpMethod.post,
      body: {"Access": access, "AccessType": accessType},
    );

    if (data != false) {
      return true;
    }

    return false;
  }

  void deleteMyAccountFunction(
    String email,
    String phone,
    String identity, {
    bool isRedirect = true,
    bool justChecking = false,
  }) async {
    if (!justChecking) {
      await Get.to(GlobalWebView('$webUrl$language/delete-account'));
    }
    bool isFound = false;
    if (email.isNotEmpty) {
      isFound = isFound || await userFound(access: email, accessType: 'email');
    }
    if (phone.isNotEmpty) {
      isFound =
          isFound || await userFound(access: phone, accessType: 'phonenumber');
    }
    if (identity.isNotEmpty) {
      isFound =
          isFound ||
          await userFound(access: identity, accessType: 'IdentityNo');
    }

    if (!isFound) {
      Fluttertoast.showToast(msg: 'accountDeleted'.tr);
      removeGetStorage(loginKey);
      if (isRedirect) {
        Get.offAll(() => Splash(version: '1.0.0'));
      }
    }
  }
}
