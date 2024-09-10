class Name {
  final String? title;
  final String? first;
  final String? last;

  Name({
    this.title,
    this.first,
    this.last,
  });

  factory Name.fromSqlite(Map<String, dynamic> map) {
    return Name(
      title: map['name_title'],
      first: map['name_first_name'],
      last: map['name_last_name'],
    );
  }

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'first': first,
      'last': last,
    };
  }

  Name copyWith({
    String? title,
    String? first,
    String? last,
  }) {
    return Name(
      title: title ?? this.title,
      first: first ?? this.first,
      last: last ?? this.last,
    );
  }
}
