import 'dart:convert';

GetUserAccountTypes getUserAccountTypesFromJson(str) =>
    GetUserAccountTypes.fromJson(str);

String getUserAccountTypesToJson(GetUserAccountTypes data) =>
    json.encode(data.toJson());

class GetUserAccountTypes {
  GetUserAccountTypes({
    required this.id,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.needIdentity,
  });

  String id;
  String descriptionAr;
  String descriptionEn;
  bool needIdentity;

  factory GetUserAccountTypes.fromJson(json) {
    return GetUserAccountTypes(
      id: json["ID"],
      descriptionAr: json["DescriptionAr"],
      descriptionEn: json["DescriptionEn"],
      needIdentity: json["NeedIdentity"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ID": id,
    "DescriptionAr": descriptionAr,
    "DescriptionEn": descriptionEn,
    "NeedIdentity": needIdentity,
  };

  static List<GetUserAccountTypes> fromJsonList(List<dynamic> json) {
    List<GetUserAccountTypes> list = [];

    for (var element in json) {
      if (['G3', 'G4'].contains(element['ID'])) {
        if (list.where((e) => e.id.contains("${element['ID']}")).isEmpty) {
          list.add(getUserAccountTypesFromJson(element));
        }
      }
    }

    return list;
  }
}
