import 'dart:convert';

class Settings {
  Settings({
    required this.countries,
    required this.cities,
    required this.genders,
  });

  List<Country> countries;
  List<City> cities;
  List<Gender> genders;

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      countries: json['countries'] != null
          ? List<Country>.from(
              json['countries'].map((x) => Country.fromJson(x)),
            )
          : [],
      cities: json['cities'] != null
          ? List<City>.from(json['cities'].map((x) => City.fromJson(x)))
          : [],
      genders: json['genders'] != null
          ? List<Gender>.from(json['genders'].map((x) => Gender.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'countries': countries.map((x) => x.toJson()).toList(),
    'cities': cities.map((x) => x.toJson()).toList(),
    'genders': genders.map((x) => x.toJson()).toList(),
  };
}

class Country {
  Country({required this.id, required this.code, required this.description});

  int id;
  String code;
  String description;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['Code'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'Code': code,
    'description': description,
  };
}

class City {
  City({required this.id, required this.code, required this.description});

  int id;
  String code; // This is the country code/ID
  String description;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'description': description,
  };
}

class Gender {
  Gender({required this.id, required this.description});

  int id;
  String description;

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'description': description};
}
