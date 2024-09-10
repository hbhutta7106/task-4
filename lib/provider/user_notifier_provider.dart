import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Feature/Firebase/user_model_notifier.dart';
import 'package:task_4/Feature/Api/user_notifier_api.dart';
import 'package:task_4/Feature/Firebase/usernotifier.dart';
import 'package:task_4/Feature/Sqflite/allsqflite_users_notifier.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Service/database.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<UserProfile>>>((ref) {
  return UserNotifier();
});

final apiNotifierProvider =
    StateNotifierProvider<ApiUserNotifier, List<UserProfile>>((ref) {
  List<UserProfile> users = [];
  return ApiUserNotifier(users);
});

final userModelNotifierProvider =
    StateNotifierProvider<UserModelNotifier, UserProfile>((ref) {
  return UserModelNotifier(UserProfile());
});

final sqliteUserFutureProvider = FutureProvider((ref) {
  DatabaseService databaseService = DatabaseService();
  return databaseService.users();
});
final stateOFListOfUsersofSqlite =
    StateNotifierProvider<AllSqfliteUser, AsyncValue<List<UserProfile>>>((ref) {
  return AllSqfliteUser();
});


// final getUserFromTheSqlite =
//     FutureProvider.family<Map<String, dynamic>?, String>(
//   (ref, email) async {
//     return await DatabaseService.findUserByUuid(email);
//   },
// );
