import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Service/database.dart';
import 'package:task_4/Widget/profile_card.dart';
import 'package:task_4/provider/user_notifier_provider.dart';
import 'package:task_4/repository/user_repo.dart';

class AllUserScreen extends ConsumerWidget {
  const AllUserScreen({super.key});

  void onImportClick(UserProfile user, BuildContext context, WidgetRef ref) {
    DatabaseService databaseService = DatabaseService();
    databaseService.insertUserIntoDatabase(user, context);
    ref.read(stateOFListOfUsersofSqlite.notifier).addUser(user);
    // UserRepository.addUserToFirebase(user, context);
    // ref.read(userNotifierProvider.notifier).addUser(user);
  }

  void deleteUser(String email, BuildContext context) {
    UserRepository.deleteUser(email, context);
  }

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(apiNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: users.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => ProfileCard(
                    delete: () {
                      deleteUser(users[index].email!, context);
                    },
                    imagePath:
                        users[index].picture?.medium ?? 'The value is Null',
                    // ignore: prefer_interpolation_to_compose_strings
                    name: (users[index].name?.title ?? 'The value is null') +
                        " " +
                        (users[index].name?.first ?? 'The value is null') +
                        " " +
                        (users[index].name?.last ?? 'The value is null'),
                    email: users[index].email ?? "The Value is null",
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return ProfileScreen(userProfile: users[index]);
                      // }));
                    },
                    onImportPress: () {
                      onImportClick(users[index], context, ref);
                    },
                    requireImportButton: true,
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: users.length,
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
