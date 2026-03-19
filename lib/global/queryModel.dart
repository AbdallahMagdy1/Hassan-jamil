import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart'
    hide Response; // hide Get's Response to use Dio's Response
import 'package:hj_app/global/enumMethod.dart';
import 'globalUI.dart';
import 'globalUrl.dart';

// Create a globally persistent Dio instance with appropriate limits.
final Dio _dio =
    Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 180),
          receiveTimeout: const Duration(seconds: 180),
          validateStatus: (status) =>
              true, // Allows 400 and 401 without throwing Exceptions
        ),
      )
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) {
            if (kDebugMode) {
              print(obj);
            }
          },
        ),
      );

Future myRequest({
  var method,
  var url,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
  returnStatusCode = false,
  errorLogin = false,
  var otherBaseUrl,
  bool returnHeader = false,
}) async {
  try {
    var requestUri = (otherBaseUrl ?? baseUrl) + url;
    var isLogin = readGetStorage(loginKey);
    var passWord = readGetStorage(passWordKey);

    var requestHeader = {
      'Content-Type': 'application/json',
      'user-authentication': '${isLogin != null ? isLogin['userName'] : ""}',
      'password-authentication': '${isLogin != null ? passWord : ""}',
    };

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.other)) {
      Options options = Options(headers: headers ?? requestHeader);
      Response result;

      // Helper function to simulate the old jsonDecode(result.body.replaceAll('+966',''))
      dynamic decodeBodyAndCleanPhone(Response response) {
        if (response.data == null) return null;

        dynamic data;
        if (response.data is String) {
          String dataStr = response.data.toString().replaceAll('+966', '');
          // ONLY jsonDecode if it looks like a JSON Object or Array.
          // Otherwise, it might be a naked phone number string like "530005261"
          // which jsonDecode would incorrectly convert to an 'int'.
          String trimmed = dataStr.trim();
          if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
            try {
              data = jsonDecode(trimmed);
            } catch (_) {
              data = trimmed;
            }
          } else {
            data = trimmed;
          }
        } else {
          // If already a Map/List (Dio auto-parsed), serialize and clean Phone
          String dataStr = jsonEncode(response.data);
          dataStr = dataStr.replaceAll('+966', '');
          data = jsonDecode(dataStr);
        }
        return data;
      }

      // Helper for general decoding like old jsonDecode(result.body)
      dynamic safeDecodeGeneral(Response response) {
        if (response.data == null) return null;
        if (response.data is String) {
          try {
            return jsonDecode(response.data);
          } catch (_) {
            return response.data;
          }
        }
        return response.data;
      }

      // Helper to serialize Headers
      Map<String, String> convertHeaders(Headers dioHeaders) {
        Map<String, String> convertedData = {};
        dioHeaders.forEach((name, values) {
          convertedData[name] = values.join(',');
        });
        return convertedData;
      }

      if (method == HttpMethod.post) {
        result = await _dio.post(requestUri, data: body, options: options);
        var convertedData = convertHeaders(result.headers);

        if (result.statusCode == 200) {
          if (returnHeader) {
            return [true, convertedData['set-cookie']];
          }

          var data = decodeBodyAndCleanPhone(result);
          return data;
        } else if (result.statusCode == 401) {
          var data = safeDecodeGeneral(result);
          if (returnStatusCode) {
            return result.statusCode;
          } else if (errorLogin) {
            errorDialog(
              title: "Error",
              body: data != null ? data['enDescription'] : '',
              isFindLoading: true,
            );
          } else {
            errorDialog(
              title: "Error",
              body: data != null ? data['EnDescription'] : '',
            );
          }
        } else if (result.statusCode == 400) {
          var data = safeDecodeGeneral(result);
          if (returnHeader) {
            return [false, data];
          }
          return data;
        } else if (result.statusCode == 201) {
          return result.statusCode;
        }
      } else if (method == HttpMethod.put) {
        result = await _dio.put(requestUri, data: body, options: options);
        var convertedData = convertHeaders(result.headers);

        if (result.statusCode == 200) {
          if (returnHeader) {
            return [true, convertedData['set-cookie']];
          }
          if (url == update) {
            return {'MessageNo': '202100000000008'};
          }
          var data = safeDecodeGeneral(result);
          return data;
        } else if (result.statusCode == 401) {
          var data = safeDecodeGeneral(result);
          if (returnStatusCode) {
            return result.statusCode;
          } else if (errorLogin) {
            errorDialog(
              title: "Error",
              body: data != null ? data['enDescription'] : '',
              isFindLoading: true,
            );
          } else {
            errorDialog(
              title: "Error",
              body: data != null ? data['EnDescription'] : '',
            );
          }
        } else if (result.statusCode == 400) {
          var data = safeDecodeGeneral(result);
          if (returnHeader) {
            return [false, data];
          }
          return data;
        } else if (result.statusCode == 201) {
          return result.statusCode;
        }
      } else if (method == HttpMethod.get) {
        result = await _dio.get(requestUri, options: options);
        var convertedData = convertHeaders(result.headers);

        if (result.statusCode == 200) {
          if (returnHeader) {
            return [true, convertedData['set-cookie']];
          }
          var data = safeDecodeGeneral(result);
          return data;
        } else if (result.statusCode == 401) {
          var data = safeDecodeGeneral(result);
          if (returnStatusCode) {
            return result.statusCode;
          } else if (errorLogin) {
            errorDialog(
              title: "Error",
              body: data != null ? data['enDescription'] : '',
              isFindLoading: true,
            );
          } else {
            errorDialog(
              title: "Error",
              body: data != null ? data['EnDescription'] : '',
            );
          }
        } else if (result.statusCode == 400) {
          var data = safeDecodeGeneral(result);
          if (returnHeader) {
            return [false, data];
          }
          return data;
        } else if (result.statusCode == 201) {
          return result.statusCode;
        }
      }
    } else {
      errorDialog(title: 'NO_INTERNET'.tr, body: 'CHECK_INTERNET'.tr);
    }
  } catch (e) {
    if (kDebugMode) {
      print("❌ myRequest error: $e");
    }
    return false;
  }

  return false;
}
