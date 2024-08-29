import 'package:task_4/Models/User/location.dart';
import 'package:task_4/Models/User/login.dart';
import 'package:task_4/Models/User/name.dart';

class UserProfile {
  final String? gender;
  final Name? name;
  final Location? location;
  final String? email;
  final Login? login;
  final DOB? dob;
  final Registered? registered;
  final String? phone;
  final String? cell;
  final Id? id;
  final Picture? picture;
  final String? nat;

  UserProfile({
    this.gender,
    this.name,
    this.location,
    this.email,
    this.login,
    this.dob,
    this.registered,
    this.phone,
    this.cell,
    this.id,
    this.picture,
    this.nat,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      cell: json['cell'],
      nat: json['nat'],
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      login: json['login'] != null ? Login.fromJson(json['login']) : null,
      dob: json['dob'] != null ? DOB.fromJson(json['dob']) : null,
      registered: json['registered'] != null
          ? Registered.fromJson(json['registered'])
          : null,
      id: json['id'] != null ? Id.fromJson(json['id']) : null,
      picture:
          json['picture'] != null ? Picture.fromJson(json['picture']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(gender != null){
      result.addAll({'gender': gender});
    }
    if(name != null){
      result.addAll({'name': name!.toMap()});
    }
    if(location != null){
      result.addAll({'location': location!.toMap()});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(login != null){
      result.addAll({'login': login!.toMap()});
    }
    if(dob != null){
      result.addAll({'dob': dob!.dobToMap()});
    }
    if(registered != null){
      result.addAll({'registered': registered!.registerToMap()});
    }
    if(phone != null){
      result.addAll({'phone': phone});
    }
    if(cell != null){
      result.addAll({'cell': cell});
    }
    if(id != null){
      result.addAll({'id': id!.idToMap()});
    }
    if(picture != null){
      result.addAll({'picture': picture!.pictureToMap()});
    }
    if(nat != null){
      result.addAll({'nat': nat});
    }
  
    return result;
  }


 

  UserProfile copyWith({
    String? gender,
    Name? name,
    Location? location,
    String? email,
    Login? login,
    DOB? dob,
    Registered? registered,
    String? phone,
    String? cell,
    Id? id,
    Picture? picture,
    String? nat,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      name: name?? this.name,
      location: location ?? this.location,
      email: email ?? this.email,
      login: login?? this.login,
      dob: dob?? this.dob,
      registered: registered?? this.registered,
      phone: phone ?? this.phone,
      cell: cell ?? this.cell,
      id: id?? this.id,
      picture: picture ?? this.picture,
      nat: nat ?? this.nat,
    );
  }
}

class Id {
  final String? name;
  final String? value;

  Id({
    this.name,
    this.value,
  });

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> idToMap() {
    return {'name': name, 'value': value};
  }

  Id copyWith({
    String? name,
    String? value,
  }) {
    return Id(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}

class Picture {
  final String? large;
  final String? medium;
  final String? thumbnail;

  Picture({
    this.large,
    this.medium,
    this.thumbnail,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      large: json['large'],
      medium: json['medium'],
      thumbnail: json['thumbnail'],
    );
  }
  Map<String, dynamic> pictureToMap() {
    return {'large': large, 'medium': medium, 'thumbnail': thumbnail};
  }

  Picture copyWith({
    String? large,
    String? medium,
    String? thumbnail,
  }) {
    return Picture(
      large: large ?? this.large,
      medium: medium ?? this.medium,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}

class DOB {
  final String? date;
  final dynamic age;

  DOB({
    this.date,
    this.age,
  });
  factory DOB.fromJson(Map<String, dynamic> json) {
    return DOB(
      date: json['date'],
      age: json['age'],
    );
  }
  Map<String, dynamic> dobToMap() {
    return {'date': date, 'age': age};
  }

  DOB copyWith({
    String? date,
    dynamic age,
  }) {
    return DOB(
      date: date ?? this.date,
      age: age ?? this.age,
    );
  }
}

class Registered {
  final String? date;
  final dynamic age;

  Registered({
    this.date,
    this.age,
  });

  factory Registered.fromJson(Map<String, dynamic> json) {
    return Registered(
      date: json['date'],
      age: json['age'],
    );
  }
  Map<String, dynamic> registerToMap() {
    return {'date': date, 'age': age};
  }

  Registered copyWith({
    String? date,
    dynamic age,
  }) {
    return Registered(
      date: date ?? this.date,
      age: age ?? this.age,
    );
  }
}
