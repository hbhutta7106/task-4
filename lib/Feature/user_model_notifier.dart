import 'package:riverpod/riverpod.dart';
import '../Models/User/user.dart';

class UserModelNotifier extends StateNotifier<UserProfile> {
  UserModelNotifier(super._state);

  void loadUser(UserProfile newUser) {
    state = newUser;
  }

  void updateUser(UserProfile user) {
    state = user;
  }
}
