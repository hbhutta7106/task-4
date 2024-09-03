import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Feature/user_notifier-api.dart';
import 'package:task_4/Feature/usernotifier.dart';
import 'package:task_4/Models/User/user.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, List<UserProfile>>((ref) {
  List<UserProfile> users = [];
  return UserNotifier(users);
});

final apiNotifierProvider =
    StateNotifierProvider<ApiUserNotifier, List<UserProfile>>((ref) {
  List<UserProfile> users = [];
  return ApiUserNotifier(users);
});
