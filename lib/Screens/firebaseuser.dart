import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';
import 'package:task_4/Screens/profile_screen.dart';
import 'package:task_4/Widget/profile_card.dart';
import 'package:task_4/provider/user_notifier_provider.dart';
import 'package:task_4/repository/userRepo.dart';

class FirebaseUsersScreen extends ConsumerStatefulWidget {
  const FirebaseUsersScreen({super.key});
  @override
  ConsumerState<FirebaseUsersScreen> createState() =>
      _FirebaseUsersScreenState();
}

class _FirebaseUsersScreenState extends ConsumerState<FirebaseUsersScreen> {
  bool areUsersEmpty = false;
  void checkUserExist() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        areUsersEmpty = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserExist();
  }

  @override
  Widget build(BuildContext context) {
    List<UserProfile> users = ref.watch(userNotifierProvider);
    if (areUsersEmpty && users.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No User Found"),
        ),
      );
    }
    if (users.isEmpty && !areUsersEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) => ProfileCard(
            delete: () {
              UserRepository.deleteUser(users[index].email!, context);
              ref
                  .read(userNotifierProvider.notifier)
                  .deleteUser(users[index].email!);
            },
            imagePath: users[index].picture?.thumbnail ?? 'The value is Null',
            // ignore: prefer_interpolation_to_compose_strings
            name: (users[index].name?.title ?? 'The value is null') +
                " " +
                (users[index].name?.first ?? 'The value is null') +
                " " +
                (users[index].name?.last ?? 'The value is null'),
            email: users[index].email ?? "The Value is null",
            onTap: () {
              ref
                  .read(userModelNotifierProvider.notifier)
                  .loadUser(users[index]);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfileScreen();
              }));
            },
            onImportPress: () {
              ref
                  .read(userModelNotifierProvider.notifier)
                  .loadUser(users[index]);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditScreen(userProfile: users[index]);
              }));
            },
            requireImportButton: false,
          ),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: users.length,
        ),
      )),
    );
  }
}
