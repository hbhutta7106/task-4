import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Service/database.dart';

class AllSqfliteUser extends StateNotifier<AsyncValue<List<UserProfile>>> {
  AllSqfliteUser() : super(const AsyncValue.loading()) {
    loadUserInState();
  }

  void loadUserInState() async {
    try {
      state = const AsyncValue.loading();
      DatabaseService databaseService = DatabaseService();
      final sqliteUsers = await databaseService.users();
      state = AsyncValue.data(sqliteUsers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void addUser(UserProfile user) {
    state.whenData((users) {
      state = AsyncValue.data([...users, user]);
    });
  }

  void deleteUser(String uuid) {
    state.whenData((users) {
      state = AsyncValue.data(
          users.where((user) => user.login!.uuid != uuid).toList());
    });
  }

  void updateUser(UserProfile newUser, String email) {
    state.whenData((users) {
      List<UserProfile> updatedUsers = users.map((user) {
        if (user.email == email) {
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
