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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: themeModeValue == 'dark' ? Colors.white : darkColor,
          ),
        ),
        title: widgetText(
          context,
          'placesNearYou'.tr,
          color: themeModeValue == 'dark' ? Colors.white : darkColor,
          fontWeight: FontWeight.bold,
          fontSize: Responsive.scaledFont(context, 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () =>
              controller.lat.value.isEmpty ||
                  controller.finishGetData.value == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Responsive.wp(context, 0.12),
                          height: Responsive.wp(context, 0.12),
                          child: const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                )
              : Container(
                  width: double.infinity,
                  height:
                      Responsive.height(context) -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.vertical,
                  color: themeModeValue == 'dark'
                      ? Colors.black
                      : Colors.grey[100],
                  child: Center(
                    child: Text(
                      'mapLoaded'.tr,
                      style: TextStyle(
                        fontSize: Responsive.scaledFont(context, 16),
                        color: themeModeValue == 'dark'
                            ? Colors.white
                            : darkColor,
                      ),
                    ),
                  ),
                ),
          // GoogleMap(
          //     initialCameraPosition: CameraPosition(
          //       target: LatLng(
          //           /*lat.isNotEmpty ?*/
          //           double.parse(controller.lat.value) /*: 24.774265*/,
          //           /*long.isNotEmpty ?*/
          //           double.parse(controller.long.value) /*: 46.738586*/),
          //       zoom: 15.4746,
          //     ),
          //     onMapCreated: (GoogleMapController controller) {
          //       _controller.complete(controller);
          //     },
          //     myLocationEnabled: true,
          //     compassEnabled: true,
          //     markers: Set<Marker>.of(controller.list),
          //   )
        ),
      ),
    );
  }

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
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    controller.long.value = position.longitude.toString();
    controller.lat.value = position.latitude.toString();

    setState(() {});

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position position,
    ) {
      controller.long.value = position.longitude.toString();
      controller.lat.value = position.latitude.toString();

      setState(() {});
    });
  }
}
