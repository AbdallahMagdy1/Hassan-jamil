class NotificationClass {
  final int? id;
  final String titleEn;
  final String titleAr;
  final String bodyEn; // bool will map to INTEGER in SQLite.
  final String bodyAr; // bool will map to INTEGER in SQLite.
  final String route;
  final String date; // bool will map to INTEGER in SQLite.

  NotificationClass({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.route,
    required this.date,
  });

  /// Creates a copy of this todo with the given fields
  /// replaced by the non-null parameter values.
  NotificationClass copyWith({
    int? id,
    String? title,
    String? body,
    String? date,
  }) => NotificationClass(
    id: id ?? this.id,
    titleEn: title ?? titleEn,
    titleAr: title ?? titleAr,
    bodyEn: title ?? bodyEn,
    bodyAr: title ?? bodyAr,
    route: title ?? route,
    date: title ?? this.date,
  );

  static List<NotificationClass> listFromJson(List data) {
    List<NotificationClass> notifications = [];
    for (var element in data) {
      notifications.add(NotificationClass.fromJson(element));
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
        date: map['date'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titleEn': titleEn,
    'titleAr': titleAr,
    'bodyEn': bodyEn,
    'bodyAr': bodyAr,
    'route': route,
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
