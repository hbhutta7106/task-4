

class Login {
  final String? uuid;
  final String? username;
  final String? password;
  final String? salt;
  final String? md5;
  final String?sha1;
  final String? sha256;

  Login({
     this.uuid,
     this.username,
     this.password,
     this.salt,
     this.md5,
     this.sha1,
     this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      uuid: json['uuid'],
      username: json['username'],
      password: json['password'],
      salt: json['salt'],
      md5: json['md5'],
      sha1: json['sha1'],
      sha256: json['sha256'],
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(uuid != null){
      result.addAll({'uuid': uuid});
    }
    if(username != null){
      result.addAll({'username': username});
    }
    if(password != null){
      result.addAll({'password': password});
    }
    if(salt != null){
      result.addAll({'salt': salt});
    }
    if(md5 != null){
      result.addAll({'md5': md5});
    }
    if(sha256 != null){
      result.addAll({'sha256': sha256});
    }
  
    return result;
  }

 

  Login copyWith({
    String? uuid,
    String? username,
    String? password,
    String? salt,
    String? md5,
    String? sha256,
  }) {
    return Login(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      password: password ?? this.password,
      salt: salt ?? this.salt,
      md5: md5 ?? this.md5,
      sha256: sha256 ?? this.sha256,
    );
  }
}
