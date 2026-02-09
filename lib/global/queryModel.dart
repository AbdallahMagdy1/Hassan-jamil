import 'dart:convert';
import 'package:hj_app/global/enumMethod.dart';
import 'package:http/http.dart' as http;
import 'globalUI.dart';
import 'globalUrl.dart';

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
  var requestUri = Uri.parse((otherBaseUrl ?? baseUrl) + url);
  var isLogin = readGetStorage(loginKey);
  var passWord = readGetStorage(passWordKey);
  var requestBody = jsonEncode(body);

  var requestHeader = {
    'Content-Type': 'application/json',
    'user-authentication': '${isLogin != null ? isLogin['userName'] : ""}',
    'password-authentication': '${isLogin != null ? passWord : ""}',
  };

  if (method == HttpMethod.post) {
    var result = await http.post(
      requestUri,
      body: requestBody,
      headers: headers ?? requestHeader,
    );
    var convertedData = jsonDecode(jsonEncode(result.headers));

    if (result.statusCode == 200) {
      if (returnHeader) {
        return [true, convertedData['set-cookie']];
      }

      var data = jsonDecode(result.body.toString().replaceAll('+966', ''));
      return data;
    } else if (result.statusCode == 401) {
      var data = jsonDecode(result.body);
      if (returnStatusCode) {
        return result.statusCode;
      } else if (errorLogin) {
        errorDialog(
          title: "Error",
          body: data['enDescription'],
          isFindLoading: true,
        );
      } else {
        errorDialog(title: "Error", body: data['EnDescription']);
      }
    } else if (result.statusCode == 400) {
      if (returnHeader) {
        return [false, jsonDecode(result.body)];
      }
      var data = jsonDecode(result.body);
      return data;
    } else if (result.statusCode == 201) {
      return result.statusCode;
    }
  } else if (method == HttpMethod.put) {
    var result = await http.put(
      requestUri,
      body: requestBody,
      headers: headers ?? requestHeader,
    );
    var convertedData = jsonDecode(jsonEncode(result.headers));
    if (result.statusCode == 200) {
      if (returnHeader) {
        return [true, convertedData['set-cookie']];
      }
      if (url == update) {
        return {'MessageNo': '202100000000008'};
      }
      var data = jsonDecode(result.body);
      return data;
    } else if (result.statusCode == 401) {
      var data = jsonDecode(result.body);
      if (returnStatusCode) {
        return result.statusCode;
      } else if (errorLogin) {
        errorDialog(
          title: "Error",
          body: data['enDescription'],
          isFindLoading: true,
        );
      } else {
        errorDialog(title: "Error", body: data['EnDescription']);
      }
    } else if (result.statusCode == 400) {
      if (returnHeader) {
        return [false, jsonDecode(result.body)];
      }
      var data = jsonDecode(result.body);
      return data;
    } else if (result.statusCode == 201) {
      return result.statusCode;
    }
  } else if (method == HttpMethod.get) {
    var result = await http.get(requestUri, headers: headers ?? requestHeader);
    var convertedData = jsonDecode(jsonEncode(result.headers));

    if (result.statusCode == 200) {
      if (returnHeader) {
        return [true, convertedData['set-cookie']];
      }
      var data = jsonDecode(result.body);
      return data;
    } else if (result.statusCode == 401) {
      var data = jsonDecode(result.body);
      if (returnStatusCode) {
        return result.statusCode;
      } else if (errorLogin) {
        errorDialog(
          title: "Error",
          body: data['enDescription'],
          isFindLoading: true,
        );
      } else {
        errorDialog(title: "Error", body: data['EnDescription']);
      }
    } else if (result.statusCode == 400) {
      if (returnHeader) {
        return [false, jsonDecode(result.body)];
      }
      var data = jsonDecode(result.body);
      return data;
    } else if (result.statusCode == 201) {
      return result.statusCode;
    }
  }

  return false;
}
