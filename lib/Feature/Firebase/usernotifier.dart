import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:task_4/Models/User/user.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<UserProfile>>> {
  UserNotifier() : super(const AsyncValue.loading()) {
    getallUsersfromFirebase();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getallUsersfromFirebase() async {
    try {
      state = const AsyncValue.loading();
      QuerySnapshot allFirebaseUserSnapshot =
          await firestore.collection('Users').get();
      List<UserProfile> users = allFirebaseUserSnapshot.docs.map((document) {
        return UserProfile.fromJson(document.data() as Map<String, dynamic>);
      }).toList();
      state = AsyncValue.data(users);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void deleteUser(String id) {
    state.whenData((users) {
      state = AsyncValue.data(users.where((user) => user.email != id).toList());
    });
  }

  void addUser(UserProfile user) {
    state.whenData((users) {
      state = AsyncValue.data([...users, user]);
    });
  }

  void updateProfile(UserProfile newUser, UserProfile oldUser) {
    state.whenData((users) {
      List<UserProfile> updatedUsers = users.map((user) {
        if (user.email == oldUser.email) {
          user = newUser;
          return user;
        } else {
          return user;
        }
      }).toList();

      
      state = AsyncValue.data(updatedUsers);
    });
  }
}
