class NotificationClass {
  final int? id;
  final String titleEn;
  final String titleAr;
  final String bodyEn; // bool will map to INTEGER in SQLite.
  final String bodyAr; // bool will map to INTEGER in SQLite.
  final String? imageUrl;
  final String? offerType;
  final String? slugAr;
  final String? route;
  final String? slugEn;
  final String date; // bool will map to INTEGER in SQLite.

  NotificationClass({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.route,
    this.imageUrl,
    this.offerType,
    this.slugAr,
    this.slugEn,
    required this.date,
  });

  /// Creates a copy of this todo with the given fields
  /// replaced by the non-null parameter values.
  NotificationClass copyWith({
    int? id,
    String? titleEn,
    String? titleAr,
    String? bodyEn,
    String? bodyAr,
    String? imageUrl,
    String? offerType,
    String? slugAr,
    String? slugEn,
    String? route,
    String? date,
  }) => NotificationClass(
    id: id ?? this.id,
    titleEn: titleEn ?? this.titleEn,
    titleAr: titleAr ?? this.titleAr,
    bodyEn: bodyEn ?? this.bodyEn,
    bodyAr: bodyAr ?? this.bodyAr,
    route: route ?? this.route,
    imageUrl: imageUrl ?? this.imageUrl,
    offerType: offerType ?? this.offerType,
    slugAr: slugAr ?? this.slugAr,
    slugEn: slugEn ?? this.slugEn,
    date: date ?? this.date,
  );

  static List<NotificationClass> listFromJson(List data) {
    List<NotificationClass> notifications = [];
    for (var element in data) {
      if (element is NotificationClass) {
        notifications.add(element);
      } else if (element is Map<String, dynamic>) {
        notifications.add(NotificationClass.fromJson(element));
      } else if (element is Map) {
        // Handle Map<dynamic, dynamic> which is common from JSON decoding
        notifications.add(
          NotificationClass.fromJson(Map<String, dynamic>.from(element)),
        );
      }
    }
    return notifications;
  }

  factory NotificationClass.fromJson(Map<String, dynamic> map) =>
      NotificationClass(
        id: map['id'],
        titleEn: map['titleEn'],
        titleAr: map['titleAr'],
        bodyEn: map['bodyEn'],
        bodyAr: map['bodyAr'],
        route: map['route'],
        imageUrl: map['imageUrl'] ?? map['image'] ?? map['ImageUrl'],
        offerType: map['offerType'] ?? map['OfferType'],
        slugAr: map['slugAr'] ?? map['SlugAr'],
        slugEn: map['slugEn'] ?? map['SlugEn'],
        date: map['date'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titleEn': titleEn,
    'titleAr': titleAr,
    'bodyEn': bodyEn,
    'bodyAr': bodyAr,
    'route': route,
    'imageUrl': imageUrl,
    'offerType': offerType,
    'slugAr': slugAr,
    'slugEn': slugEn,
    'date': date,
  };

  /// The equality operator.
  /// The default behavior for all [Object]s is to return true if and
  /// only if this object and [other] are the same object.
  /// If a subclass overrides the equality operator, it should override
  /// the [hashCode] method as well to maintain consistency.
  @override
  bool operator ==(covariant NotificationClass other) => id == other.id;

  /// The hash code for this object.
  /// A hash code is a single integer which represents the state of the object
  /// that affects [operator ==] comparisons. Hash codes must be the same
  /// for objects that are equal to each other according to [operator ==].

  @override
  String toString() => toJson().toString();
}
