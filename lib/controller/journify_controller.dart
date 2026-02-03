import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:journify_analytics_plugin_advertising_id/plugin_advertising_id.dart'
    show PluginAdvertisingId;
import 'package:journify_analytics_plugin_idfa/plugin_idfa.dart'
    show PluginIdfa;
import 'package:journify_flutter/client.dart' show createClient;
import 'package:journify_flutter/event.dart' show Company, UserTraits, Address;
import 'package:journify_flutter/journify.dart';
import 'package:journify_flutter/state.dart' show Configuration;

class JournifyBridgeController extends GetxController {
  late final Journify journify;

  // Optional: allowlist to avoid random pages calling your handler.
  final Set<String> allowedHosts;

  JournifyBridgeController({
    required String writeKey,
    this.allowedHosts = const {},
  }) {
    journify = createClient(Configuration(writeKey));
  }

  /// Call this once during app startup.
  void addPlugins() {
    journify.addPlugin(PluginIdfa());
    journify.addPlugin(PluginAdvertisingId());
  }

  Future<Map<String, dynamic>> handleFromWeb({
    required Map<String, dynamic> message,
    required Uri? currentUrl,
  }) async {
    // 1) Basic origin check (strongly recommended)
    if (allowedHosts.isNotEmpty) {
      final host = currentUrl?.host;
      if (host == null || !allowedHosts.contains(host)) {
        return {"ok": false, "error": "blocked_origin", "host": host};
      }
    }

    // 2) Validate envelope
    final type = message["type"];
    final payload = message["payload"];

    if (type is! String) {
      return {"ok": false, "error": "missing_type"};
    }
    if (payload != null && payload is! Map) {
      return {"ok": false, "error": "payload_not_object"};
    }
    final p = (payload as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    try {
      switch (type) {
        case "track":
          final event = p["event"];
          final props = p["properties"];
          if (event is! String)
            return {"ok": false, "error": "track_missing_event"};
          await journify.track(event, properties: _asMap(props));
          return {"ok": true};

        case "screen":
          final name = p["name"];
          final props = p["properties"];
          if (name is! String)
            return {"ok": false, "error": "screen_missing_name"};
          await journify.screen(name, properties: _asMap(props));
          return {"ok": true};

        case "identify":
          final userId = p["userId"];
          final traits = p["traits"];
          if (userId != null && userId is! String) {
            return {"ok": false, "error": "identify_userId_not_string"};
          }
          final userTraits = _toUserTraits(traits);
          await journify.identify(
            userId: userId as String?,
            userTraits: userTraits,
          );
          return {"ok": true};

        case "reset":
          journify.reset();
          return {"ok": true};

        case "flush":
          await journify.flush();
          return {"ok": true};

        default:
          return {"ok": false, "error": "unknown_type", "type": type};
      }
    } catch (e, st) {
      debugPrint("Journify bridge error: $e\n$st");
      return {"ok": false, "error": "exception", "message": e.toString()};
    }
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value == null) return null;
    if (value is Map) return value.cast<String, dynamic>();
    return null;
  }

  UserTraits? _toUserTraits(dynamic traits) {
    if (traits == null) return null;
    if (traits is! Map) return null;
    final t = traits.cast<String, dynamic>();

    // Map raw data from React to Journify traits
    return UserTraits(
      id: t["Web_UserID"]?.toString() ?? t["userId"]?.toString(),
      email: t["Email"] ?? t["email"],
      phone: t["Phone"] ?? t["phone"] ?? t["mobile"],
      // Create Address if available
      address: t["Address"] != null
          ? Address(street: t["Address"])
          : (t["address"] is Map ? Address.fromJson(t["address"]) : null),
      firstName: t["FirstNameEn"] ?? t["firstname"] ?? t["userNameEn"],
      lastName: t["LastNameEn"] ?? t["lastname"] ?? t["lastNameEn"],
      title: t["title"],
      gender: (t["GenderID"] == 1 || t["GenderID"] == "1")
          ? "male"
          : ((t["GenderID"] == 2 || t["GenderID"] == "2")
                ? "female"
                : t["gender"]),
      birthday: t["birthday"],
      company: t["company"] is Map ? Company.fromJson(t["company"]) : null,
      custom: t["custom"] is Map
          ? (t["custom"] as Map).cast<String, dynamic>()
          : null,
    );
  }
}
