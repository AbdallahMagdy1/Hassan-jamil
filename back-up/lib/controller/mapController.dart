// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hj_app/global/globalUrl.dart';

import '../global/enumMethod.dart';
import '../global/queryModel.dart';
import '../model/centersNearYou.dart';

class MapController extends GetxController {
  RxBool isProgress = false.obs;
  RxBool finishGetData = false.obs;
  List<CentersNearYou> listUserAccountTypes = <CentersNearYou>[].obs;
  RxString long = "".obs, lat = "".obs;
  // List<Marker> list = [];

  @override
  void onInit() async {
    super.onInit();
    centersNearYou();
  }

  Future<void> centersNearYou() async {
    isProgress.value = true;
    var response = await myRequest(
      url: func,
      method: HttpMethod.post,
      body: {"Name": "site_FetchBranches"},
    );
    listUserAccountTypes = CentersNearYou.fromJsonList(response);

    // for (int i = 0; i < listUserAccountTypes.length; i++) {
    //   list.add(Marker(
    //     markerId: MarkerId(listUserAccountTypes[i].cityEn),
    //     position: LatLng(double.parse(listUserAccountTypes[i].latitude),
    //         double.parse(listUserAccountTypes[i].longitude)),
    //     // infoWindow: InfoWindow(title: 'Business 1'),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    //   ));
    // }
    finishGetData.value = true;
  }
}
