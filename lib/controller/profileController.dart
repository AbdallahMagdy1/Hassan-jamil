import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hj_app/controller/verificationController.dart';
import 'package:hj_app/global/enumMethod.dart';
import 'package:hj_app/global/globalUI.dart';
import 'package:hj_app/global/globalUrl.dart';
import 'package:hj_app/global/queryModel.dart';
import 'package:hj_app/model/getUserAccountTypes.dart';
import 'package:hj_app/model/settings.dart';
import 'package:hj_app/view/screen/globalWebView.dart';
import 'package:hj_app/view/screen/profileDetails.dart';
import 'package:hj_app/view/screen/splash.dart';

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

  // Load settings (countries, cities, genders) from API. Calls
  // GET {lang}/api/User/GetSettings — the helper auto-prepends lang + backend.
  Future<void> getSettings() async {
    try {
      // 1. Try cache first (instant UI; cache may be per-language since the
      //    response interpolates Description<lang> from the server).
      final cacheKey = 'settingsCache_$language';
      var cachedSettings = readGetStorage(cacheKey);
      if (cachedSettings != null) {
        debugPrint("Loaded settings from cache ($cacheKey)");
        _parseAndApplySettings(Map<String, dynamic>.from(cachedSettings));
      }

      // 2. Fetch fresh data from API
      var data = await myRequest(
        url: 'api/User/GetSettings',
        method: HttpMethod.get,
        body: {},
      );

      // 3. Update cache and apply if successful
      if (data is Map) {
        debugPrint("Fetched fresh settings from API");
        Map<String, dynamic> settingsData = {
          'countries': data['countries'] ?? [],
          'cities': data['cities'] ?? [],
          'genders': data['genders'] ?? [],
        };
        await writeGetStorage(cacheKey, settingsData);
        _parseAndApplySettings(settingsData);
      } else {
        debugPrint(
          "Failed to fetch fresh settings: data=$data, "
          "networkFailed=$lastRequestNetworkFailed",
        );
      }
    } catch (e, st) {
      debugPrint("Error loading settings: $e\n$st");
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

  // Filter cities based on selected country. The backend's GetSettings
  // returns city.code = countryId (see UserProcessor.GetAllCities), and
  // country.code is empty since the SQL doesn't select it. Compare against
  // the country id directly.
  void filterCities(int selectedCountryId) {
    if (cities.isEmpty) {
      filteredCities.clear();
      return;
    }
    final target = selectedCountryId.toString();
    filteredCities.value = cities.where((city) => city.code == target).toList();
  }

  // Validation: Check if phone number exists
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      var data = await myRequest(
        url: 'api/Pages/$SiteNewPhoneNumberExisting',
        method: HttpMethod.post,
        body: {"phoneNumber": phoneNumber},
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
        url: 'api/Pages/$SiteNewEmailExisting',
        method: HttpMethod.post,
        body: {"email": email.trim()},
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
        url: 'api/Pages/$SiteNewIdentityExisting',
        method: HttpMethod.post,
        body: {"identity": identity, "guid": isLogin['GUID'] ?? ""},
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
        url: 'api/Pages/$SiteNewCRExisting',
        method: HttpMethod.post,
        body: {"identity": crNumber, "guid": isLogin['GUID'] ?? ""},
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
      final cleanLogo = _stripBase64Header(imageProfileBase64.value);
      final cleanIdentityImage = _stripBase64Header(identityImage?.toString());

      Map<String, dynamic> values = {
        "IdentityNumber": '$identificationNumber',
        "Email": '$email',
        "Address": address,
      };
      if (cleanLogo != null && cleanLogo.isNotEmpty) {
        values["Logo"] = cleanLogo;
      }
      if (cleanIdentityImage != null && cleanIdentityImage.isNotEmpty) {
        values["IdentityImage"] = cleanIdentityImage;
      }
      if (language == "ar") {
        values["FirstNameAr"] = '$firstName';
        values["MiddleNameAr"] = '$middleName';
        values["GrandFatherNameAr"] = '$grandFatherName';
        values["LastNameAr"] = '$lastName';
      } else {
        values["FirstNameEn"] = '$firstName';
        values["MiddleNameEn"] = '$middleName';
        values["GrandFatherNameEn"] = '$grandFatherName';
        values["LastNameEn"] = '$lastName';
      }

      final data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": values,
        },
      );

      if (_isUpdateSuccess(data)) {
        await refreshUserData();
        Fluttertoast.showToast(msg: 'profileUpdated'.tr);
        Get.to(const profileDetails());
      } else {
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : 'failedToUpdateProfile'.tr,
        );
      }
    } catch (e, st) {
      debugPrint("Error in updateProfile: $e\n$st");
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
    } finally {
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

  // Called by the profileDetails view on build. Handles the case where
  // ProfileController was constructed before the user logged in (so
  // `onInit` early-returned with `isLogin == null` and never called
  // `getSettings`). Re-reads the storage, fetches settings if missing,
  // then refreshes form fields from the latest user record. Cheap to call
  // repeatedly because getSettings has its own cache.
  Future<void> ensureLoaded() async {
    isLogin = readGetStorage(loginKey);
    if (isLogin == null) return;
    if (listUserAccountTypes.isEmpty &&
        readGetStorage(listUserAccountTypesKey) != null) {
      listUserAccountTypes = GetUserAccountTypes.fromJsonList(
        readGetStorage(listUserAccountTypesKey),
      );
    }
    if (settings.value == null) {
      await getSettings();
    }
    reloadFormData();
  }

  // Helper to refresh user data from API and update local storage. Silent
  // by design — callers decide whether to surface a failure to the user.
  Future<void> refreshUserData() async {
    try {
      if (isLogin == null) return;
      final data = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final rows = (data is Map) ? data['ApiObjectData'] : null;
      if (rows is List && rows.isNotEmpty) {
        await writeGetStorage(loginKey, rows[0]);
        isLogin = readGetStorage(loginKey);
        reloadFormData();
        debugPrint("User data refreshed successfully");
      } else {
        debugPrint(
          "Failed to refresh user data: data=$data, "
          "networkFailed=$lastRequestNetworkFailed",
        );
      }
    } catch (e, st) {
      debugPrint("Error refreshing user data: $e\n$st");
    }
  }

  // Mirrors the React app's split-update pattern (see WebSiteFrontEnd
  // profile.jsx handleChangePersonalData + handleDocumentChange):
  //   1) Main personal payload — names, gender, address, logo, country, city
  //   2) Optional second call for identity/CR + CustGroupID
  // VisualBase rejects payloads containing keys for non-existent columns or
  // values of the wrong type (we previously hit
  // MessageNo 202100000000019 "Error in converting the json value" because we
  // bundled CustGroupID/IdentityNumber/grandFatherName + Logo:null +
  // countryID:0 all into one body).
  Future<void> updateProfilePersonally() async {
    debugPrint("=== updateProfilePersonally STARTED ===");
    final guid = isLogin?['GUID']?.toString();
    if (guid == null || guid.isEmpty) {
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
      debugPrint("updateProfilePersonally: missing GUID in isLogin=$isLogin");
      return;
    }
    isProgress.value = true;
    try {
      // ───────── 1. Personal data payload (matches React profile.jsx:572) ─
      // Only include fields with actual values; nulls become NULL in SQL.
      final values = <String, dynamic>{
        if (controllerFistName.text.trim().isNotEmpty)
          "firstNameAr": controllerFistName.text.trim(),
        if (controllerMiddleName.text.trim().isNotEmpty)
          "middleNameAr": controllerMiddleName.text.trim(),
        if (controllerLastName.text.trim().isNotEmpty)
          "lastNameAr": controllerLastName.text.trim(),
        if (controllerFirstNameEn.text.trim().isNotEmpty)
          "firstNameEn": controllerFirstNameEn.text.trim(),
        if (controllerMiddleNameEn.text.trim().isNotEmpty)
          "middleNameEn": controllerMiddleNameEn.text.trim(),
        if (controllerLastNameEn.text.trim().isNotEmpty)
          "lastNameEn": controllerLastNameEn.text.trim(),
        if (controllerAddress.text.trim().isNotEmpty)
          "Address": controllerAddress.text.trim(),
        // GenderID must be sent as a number, not a string.
        if (idGender.value > 0) "GenderID": idGender.value,
        // 0 means "not selected" in our UI; React sends null in this case.
        "countryID": (countryID.value != null && countryID.value! > 0)
            ? countryID.value
            : null,
        "cityID": (cityID.value != null && cityID.value! > 0)
            ? cityID.value
            : null,
      };
      final cleanLogo = _stripBase64Header(imageProfileBase64.value);
      if (cleanLogo != null && cleanLogo.isNotEmpty) {
        values["Logo"] = cleanLogo;
      }

      debugPrint("Personal payload: $values");

      final data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {"Filters": "where GUID = '$guid'", "Values": values},
      );

      debugPrint("Personal update response: $data");

      if (!_isUpdateSuccess(data)) {
        debugPrint(
          "Personal update failed. data=$data, "
          "networkFailed=$lastRequestNetworkFailed",
        );
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : _extractError(data, 'failedToUpdateProfile'),
        );
        return;
      }

      // ───────── 2. Identity / CR payload (matches React profile.jsx:776) ─
      // Only fire if the user actually filled the identity/CR section AND
      // the value has changed. CustGroupID + IdentityNumber/TradeNo are
      // grouped because a CustGroupID change typically implies switching
      // identity types.
      final docPayload = _buildIdentityDocumentPayload();
      if (docPayload.isNotEmpty) {
        debugPrint("Identity/CR payload: $docPayload");
        final docData = await myRequest(
          url: 'api/Pages/Updateweb_users',
          method: HttpMethod.post,
          body: {"Filters": "where GUID = '$guid'", "Values": docPayload},
        );
        debugPrint("Identity/CR update response: $docData");
        if (!_isUpdateSuccess(docData)) {
          debugPrint(
            "Identity/CR update failed. data=$docData, "
            "networkFailed=$lastRequestNetworkFailed",
          );
          // Personal info already saved; surface the partial failure but
          // still refresh + leave the screen.
          Fluttertoast.showToast(
            msg: lastRequestNetworkFailed
                ? 'CHECK_INTERNET'.tr
                : _extractError(docData, 'failedToUpdateProfile'),
          );
        }
      }

      await refreshUserData();
      optionTap.value = 0;
      Fluttertoast.showToast(msg: 'profileUpdated'.tr);
    } catch (e, stackTrace) {
      debugPrint("=== EXCEPTION in updateProfilePersonally ===");
      debugPrint("Error: $e");
      debugPrint("StackTrace: $stackTrace");
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
    } finally {
      isProgress.value = false;
      debugPrint("=== updateProfilePersonally COMPLETED ===");
    }
  }

  // Constructs the Identity/CR portion of the profile update, returning
  // an empty map if the user hasn't provided document data (so the caller
  // skips the second API call entirely).
  Map<String, dynamic> _buildIdentityDocumentPayload() {
    final payload = <String, dynamic>{};
    if (custGroupID.value != null && custGroupID.value!.isNotEmpty) {
      payload["CustGroupID"] = custGroupID.value;
    }
    if (identityType.value == 1) {
      final identity = controllerIdentityNumber.text.trim();
      if (identity.isNotEmpty) {
        payload["IdentityNumber"] = identity;
      }
      final cleanIdentityImage = _stripBase64Header(identityImageBase64.value);
      if (cleanIdentityImage != null && cleanIdentityImage.isNotEmpty) {
        payload["IdentityImage"] = cleanIdentityImage;
      }
    } else if (identityType.value == 2) {
      final cr = controllerCRNumber.text.trim();
      if (cr.isNotEmpty) {
        payload["TradeNo"] = cr;
      }
      final cleanCRImage = _stripBase64Header(crImageBase64.value);
      if (cleanCRImage != null && cleanCRImage.isNotEmpty) {
        payload["TradeNoImage"] = cleanCRImage;
      }
    }
    // If CustGroupID is the only key, there's nothing meaningful to update;
    // skip the call entirely.
    if (payload.length == 1 && payload.containsKey("CustGroupID")) {
      payload.clear();
    }
    return payload;
  }

  // Picks a localized error string out of a VisualBase error body, falling
  // back to the supplied translation key if the response doesn't include
  // one. VisualBase errors look like
  //   { "MessageNo": "...", "ArDescription": "...", "EnDescription": "..." }
  String _extractError(dynamic data, String fallbackKey) {
    if (data is Map) {
      final key = language == 'ar' ? 'ArDescription' : 'EnDescription';
      final msg = data[key];
      if (msg is String && msg.trim().isNotEmpty) return msg.trim();
    }
    return fallbackKey.tr;
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
    // Client-side validation first — fail fast before any network call.
    final current = controllerCurrentPassword.text;
    final next = controllerNewPassword.text;
    final confirm = controllerReNewPassword.text;
    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      Fluttertoast.showToast(msg: 'pleaseFillAllFields'.tr);
      return;
    }
    if (next != confirm) {
      Fluttertoast.showToast(msg: 'passwordsDoNotMatch'.tr);
      return;
    }
    if (next.length < 6) {
      Fluttertoast.showToast(msg: 'passwordTooShort'.tr);
      return;
    }
    if (next == current) {
      Fluttertoast.showToast(msg: 'newPasswordSameAsOld'.tr);
      return;
    }

    isProgress.value = true;
    try {
      // Verify the current password by looking the user up with it. This
      // prevents a session hijacker from rotating the password without
      // knowing the existing one.
      final currentMd5 = textToMd5(current);
      final verify = await myRequest(
        url: 'api/Pages/Detailsweb_users',
        method: HttpMethod.post,
        body: {
          "Option": "column",
          "Fields": "Web_UserID",
          "Filters":
              "where Web_UserID = '${isLogin['Web_UserID']}' and Password = '$currentMd5'",
          "ObjectSettings": {"MetaData": false},
        },
      );
      final verifyRows = (verify is Map) ? verify['ApiObjectData'] : null;
      if (verifyRows is! List || verifyRows.isEmpty) {
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : 'currentPasswordIncorrect'.tr,
        );
        return;
      }

      final nextMd5 = textToMd5(next);
      final data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {"Password": nextMd5},
        },
      );
      if (_isUpdateSuccess(data)) {
        await refreshUserData();
        optionTap.value = 2;
        Fluttertoast.showToast(msg: 'passwordUpdated'.tr);
      } else {
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : 'failedToUpdatePassword'.tr,
        );
      }
    } catch (e, st) {
      debugPrint("Error in updatePassword: $e\n$st");
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
    } finally {
      isProgress.value = false;
      controllerCurrentPassword.clear();
      controllerNewPassword.clear();
      controllerReNewPassword.clear();
    }
  }

  Future<void> updatePasswordContactInformation() async {
    isProgress.value = true;
    try {
      // Read phone & email straight from the TextFields — the previous
      // `phoneNumber` field only updated on TextField.onChanged so it could
      // be stale (e.g. when the user pastes a number without firing the
      // change callback).
      final phoneText = controllerPhoneNumber.text.trim();
      final emailText = controllerEmail.text.trim();
      final fallbackPhone = '${isLogin['Phone'] ?? ''}';
      final phoneToSend = phoneText.isNotEmpty ? phoneText : fallbackPhone;

      if (emailText.isEmpty) {
        Fluttertoast.showToast(msg: 'pleaseEnterValidEmail'.tr);
        return;
      }

      final data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {"Phone": phoneToSend, "Email": emailText},
        },
      );

      if (_isUpdateSuccess(data)) {
        await refreshUserData();
        optionTap.value = 1;
        Fluttertoast.showToast(msg: 'contactInformationUpdated'.tr);
      } else {
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : 'failedToUpdateContactInformation'.tr,
        );
      }
    } catch (e, st) {
      debugPrint("Error in updatePasswordContactInformation: $e\n$st");
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
    } finally {
      isProgress.value = false;
    }
  }

  Future<void> updateLogo() async {
    try {
      isProgressImage.value = true;
      final cleanLogo = _stripBase64Header(imageProfileBase64.value);
      if (cleanLogo == null || cleanLogo.isEmpty) {
        Fluttertoast.showToast(msg: 'noImageSelected'.tr);
        return;
      }
      var data = await myRequest(
        url: 'api/Pages/Updateweb_users',
        method: HttpMethod.post,
        body: {
          "Filters": "where Web_UserID = '${isLogin['Web_UserID']}'",
          "Values": {"Logo": cleanLogo},
        },
      );
      if (_isUpdateSuccess(data)) {
        await refreshUserData();
        Fluttertoast.showToast(msg: 'profileImageUpdated'.tr);
      } else {
        Fluttertoast.showToast(
          msg: lastRequestNetworkFailed
              ? 'CHECK_INTERNET'.tr
              : 'failedToUpdateProfileImage'.tr,
        );
      }
    } catch (e, st) {
      debugPrint("Error in updateLogo: $e\n$st");
      Fluttertoast.showToast(msg: 'anUnexpectedErrorOccurred'.tr);
    } finally {
      isProgressImage.value = false;
    }
  }

  // Treats the standard VisualBase success MessageNo as ok, accepting
  // both string and numeric representations (the JSON serializer can
  // return either depending on the column type).
  bool _isUpdateSuccess(dynamic data) {
    if (data is! Map) return false;
    final msg = data['MessageNo'];
    return msg == '202100000000008' || msg == 202100000000008;
  }

  Future<bool> userFound({
    required String access,
    required String accessType,
  }) async {
    isProgress.value = true;
    try {
      if (accessType == 'phonenumber') {
        access = '+966${access.trim().replaceFirst('+966', '')}';
      }
      var data = await myRequest(
        otherBaseUrl: administrationUrl,
        url: UserFound,
        method: HttpMethod.post,
        body: {"Access": access, "AccessType": accessType},
      );
      return data != false;
    } catch (e, st) {
      debugPrint("Error in userFound: $e\n$st");
      return false;
    } finally {
      isProgress.value = false;
    }
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
