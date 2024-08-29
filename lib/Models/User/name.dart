class Name {
  final String? title;
  final String? first;
  final String? last;

  Name({
     this.title,
     this.first,
     this.last,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }
  Map<String,dynamic> toMap()
  {
    return {
      'title':title,
      'first':first,
      'last':last,
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
