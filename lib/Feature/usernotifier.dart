import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:task_4/Models/User/user.dart';

class UserNotifier extends StateNotifier<List<UserProfile>> {
  UserNotifier(super._state) {
    getallUsersfromFirebase();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<UserProfile>> getallUsersfromFirebase() async {
    try {
      QuerySnapshot allFirebaseUserSnapshot =
          await firestore.collection('Users').get();

      List<UserProfile> users = allFirebaseUserSnapshot.docs.map((document) {
        return UserProfile.fromJson(document.data() as Map<String, dynamic>);
      }).toList();
      state = users;
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void deleteUser(String id) {
    state = state.where((user) => user.email != id).toList();
  }

  void addUser(UserProfile user) {
    if(!state.contains(user))
    {
state = [...state, user];
    }

    
  }

  void updateProfile(UserProfile newUser, UserProfile oldUser) {
    state = state.map((user) {
      if (user.email == oldUser.email) {
        user = newUser;
        return user;
      } else {
        return user;
      }
    }).toList();
  }
}
