import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:http/http.dart' as http;

class ApiUserNotifier extends StateNotifier<List<UserProfile>> {
  ApiUserNotifier(super._state) {
    getallUsers();
  }

  Future<List<UserProfile>?> getallUsers() async {
    List<UserProfile>? users = [];
    try {
      final url = Uri.https('randomuser.me', '/api/', {'results': '100'});
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedObject = jsonDecode(response.body);
        var results = decodedObject['results'] as List<dynamic>;
        users = results.map((value) {
          return UserProfile.fromJson(value);
        }).toList();
        state = users;
        return users;
      } else {
        users = null;
        return users;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
