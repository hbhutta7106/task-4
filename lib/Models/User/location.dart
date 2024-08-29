class Location {
  final Street? street;
  final String? city;
  final String? state;
  final String? country;
  final dynamic postcode;
  final Coordinates? coordinates;
  final TimeZone? timezone;

  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.coordinates,
    this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      street: json['street'] != null ? Street.fromJson(json['street']) : null,
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      timezone:
          json['timezone'] != null ? TimeZone.fromJson(json['timezone']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (street != null) {
      result.addAll({'street': street!.toMap()});
    }
    if (city != null) {
      result.addAll({'city': city});
    }
    if (state != null) {
      result.addAll({'state': state});
    }
    if (country != null) {
      result.addAll({'country': country});
    }
    result.addAll({'postcode': postcode});
    if (coordinates != null) {
      result.addAll({'coordinates': coordinates!.toMap()});
    }
    
    result.addAll({'timezone': timezone!.toMap()});

    return result;
  }

  Location copyWith({
    Street? street,
    String? city,
    String? state,
    String? country,
    dynamic postcode,
    Coordinates? coordinates,
    TimeZone? timezone,
  }) {
    return Location(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postcode: postcode ?? this.postcode,
      coordinates: coordinates ?? this.coordinates,
      timezone: timezone ?? this.timezone,
    );
  }
}

class Street {
  final dynamic number;
  final String? name;

  Street({
    this.number,
    this.name,
  });

  factory Street.fromJson(Map<String, dynamic> json) {
    return Street(
      number: json['number'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if (number != null) {
      result.addAll({'number': number});
    }
    if (name != null) {
      result.addAll({'name': name});
    }

    return result;
  }

  Street copyWith({
    dynamic number,
    String? name,
  }) {
    return Street(
      number: number ?? this.number,
      name: name ?? this.name,
    );
  }
}

class Coordinates {
  final dynamic latitude;
  final dynamic longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'latitude': latitude});

    result.addAll({'longitude': longitude});

    return result;
  }

  Coordinates copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Coordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class TimeZone {
  final String? offset;
  final String? description;

  TimeZone({
    this.offset,
    this.description,
  });

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone(
      offset: json['offset'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (offset != null) {
      result.addAll({'offset': offset});
    }
    if (description != null) {
      result.addAll({'description': description});
    }

    return result;
  }

  TimeZone copyWith({
    String? offset,
    String? description,
  }) {
    return TimeZone(
      offset: offset ?? this.offset,
      description: description ?? this.description,
    );
  }
}
