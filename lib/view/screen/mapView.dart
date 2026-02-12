import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controller/mapController.dart';
import '../../global/globalUI.dart';
import '../../global/responsive.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<StatefulWidget> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final MapController controller = Get.put(MapController());
  // final Completer<GoogleMapController> _controller = Completer();
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  late Position position;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  // --- UI DECORATION TOOLKIT (Standardized with other pages) ---
  BoxDecoration _containerDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(24.0),
      border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
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
          'placesNearYou'.tr,
          fontWeight: FontWeight.bold,
          fontSize: Responsive.scaledFont(context, 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          bool isLoading =
              controller.lat.value.isEmpty ||
              controller.finishGetData.value == false;

          return Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(Get.width * .05),
            color: isDark ? Colors.black : Colors.grey[50],
            child: isLoading
                ? _buildLoadingState(isDark)
                : _buildMapPlaceholder(context, isDark),
          );
        }),
      ),
    );
  }

  // --- LOADING UI (Card Styled) ---
  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: _containerDecoration(isDark),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: greenColor,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            widgetText(
              context,
              'loading'.tr, // Or a custom "Detecting Location" key
              fontSize: 14,
              color: greyColor2,
            ),
          ],
        ),
      ),
    );
  }

  // --- MAP PLACEHOLDER UI (Card Styled) ---
  Widget _buildMapPlaceholder(BuildContext context, bool isDark) {
    // This replicates the structure where the Map would be,
    // wrapped in the standardized card look until the actual GoogleMap is uncommented.
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: _containerDecoration(isDark),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Actual Map would go here:
                  // GoogleMap(...)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_rounded,
                          size: 50,
                          color: greenColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        widgetText(
                          context,
                          'mapLoaded'.tr,
                          fontSize: Responsive.scaledFont(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 8),
                        widgetText(
                          context,
                          "${controller.lat.value}, ${controller.long.value}",
                          fontSize: 12,
                          color: greyColor2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // OPTIONAL: Bottom action card if needed
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _containerDecoration(isDark),
          child: Row(
            children: [
              Icon(Icons.location_on, color: greenColor),
              const SizedBox(width: 12),
              Expanded(
                child: widgetText(
                  context,
                  'yourCurrentLocation'.tr,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- LOGIC: GPS & LOCATION (Untouched) ---

  Future<void> checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      debugPrint("GPS Service is not enabled, turn on GPS location");
    }
    setState(() {});
  }

  Future<void> getLocation() async {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    controller.long.value = position.longitude.toString();
    controller.lat.value = position.latitude.toString();

    setState(() {});

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            controller.long.value = position.longitude.toString();
            controller.lat.value = position.latitude.toString();
            setState(() {});
          },
        );
  }
}
