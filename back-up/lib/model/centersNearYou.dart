import 'dart:convert';

List<CentersNearYou> centersNearYouFromJson(String str) =>
    List<CentersNearYou>.from(
      json.decode(str).map((x) => CentersNearYou.fromJson(x)),
    );

String centersNearYouToJson(List<CentersNearYou> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CentersNearYou {
  String cityAr;
  String cityEn;
  String siteId;
  String city;
  dynamic workingHoursFormat;
  String descriptionAr;
  String descriptionEn;
  String invStatusId;
  String? address;
  dynamic note;
  String guid;
  dynamic telephone;
  dynamic fax;
  bool? salesOffice;
  int? salesTarget;
  String latitude;
  String longitude;
  int id;
  int storeWebAppId;
  String storeId;
  bool enable;

  CentersNearYou({
    required this.cityAr,
    required this.cityEn,
    required this.siteId,
    required this.city,
    this.workingHoursFormat,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.invStatusId,
    this.address,
    this.note,
    required this.guid,
    this.telephone,
    this.fax,
    this.salesOffice,
    this.salesTarget,
    required this.latitude,
    required this.longitude,
    required this.id,
    required this.storeWebAppId,
    required this.storeId,
    required this.enable,
  });

  factory CentersNearYou.fromJson(Map<String, dynamic> json) => CentersNearYou(
    cityAr: json["CityAr"] ?? '',
    cityEn: json["CityEn"] ?? '',
    siteId: json["SiteID"] ?? '',
    city: json["city"] ?? '',
    workingHoursFormat: json["WorkingHoursFormat"] ?? '',
    descriptionAr: json["DescriptionAr"] ?? '',
    descriptionEn: json["DescriptionEn"] ?? '',
    invStatusId: json["InvStatusID"] ?? '',
    address: json["Address"] ?? '',
    note: json["Note"] ?? '',
    guid: json["GUID"] ?? '',
    telephone: json["Telephone"] ?? '',
    fax: json["Fax"] ?? '',
    salesOffice: json["SalesOffice"] ?? false,
    salesTarget: json["SalesTarget"] ?? 0,
    latitude: json["Latitude"] ?? '',
    longitude: json["Longitude"] ?? '',
    id: json["ID"] ?? 0,
    storeWebAppId: json["StoreWebAppID"] ?? 0,
    storeId: json["StoreID"] ?? '',
    enable: json["Enable"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "CityAr": cityAr,
    "CityEn": cityEn,
    "SiteID": siteId,
    "city": city,
    "WorkingHoursFormat": workingHoursFormat,
    "DescriptionAr": descriptionAr,
    "DescriptionEn": descriptionEn,
    "InvStatusID": invStatusId,
    "Address": address,
    "Note": note,
    "GUID": guid,
    "Telephone": telephone,
    "Fax": fax,
    "SalesOffice": salesOffice,
    "SalesTarget": salesTarget,
    "Latitude": latitude,
    "Longitude": longitude,
    "ID": id,
    "StoreWebAppID": storeWebAppId,
    "StoreID": storeId,
    "Enable": enable,
  };

  static List<CentersNearYou> fromJsonList(List<dynamic> json) {
    List<CentersNearYou> list = [];
    for (var element in json) {
      list.add(CentersNearYou.fromJson(element));
    }

    return list;
  }
}
