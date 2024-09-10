import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';
import 'package:task_4/Screens/profile_screen.dart';
import 'package:task_4/Service/database.dart';
import 'package:task_4/Widget/profile_card.dart';
import 'package:task_4/provider/user_notifier_provider.dart';

class SqfliteScreen extends ConsumerWidget {
  const SqfliteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<UserProfile>> listofUsers =
        ref.watch(stateOFListOfUsersofSqlite);
    return Scaffold(
      body: SafeArea(
          child: listofUsers.when(
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              error: (error, stackTrace) => Center(
                    child: Text('Error: $error'),
                  ),
              data: (users) {
                if (users.isEmpty) {
                  const Center(
                    child: Text("No User Found"),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => ProfileCard(
                      delete: () async {
                        DatabaseService databaseService = DatabaseService();
                        int done =
                            await databaseService.deleteUserFromSqliteDatabase(
                                users[index].login!.uuid!);
                        if (done == 1) {
                          ref
                              .read(stateOFListOfUsersofSqlite.notifier)
                              .deleteUser(users[index].login!.uuid!);
                        }
                      },
                      imagePath: users[index].picture?.thumbnail ??
                          'The value is Null',
                      // ignore: prefer_interpolation_to_compose_strings
                      name: (users[index].name?.title ?? 'The value is null') +
                          " " +
                          (users[index].name?.first ?? 'The value is null') +
                          " " +
                          (users[index].name?.last ?? 'The value is null'),
                      email: users[index].email ?? "The Value is null",
                      onTap: () async {
                        ref
                            .read(userModelNotifierProvider.notifier)
                            .loadUser(users[index]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ProfileScreen(
                            number: 0,
                          );
                        }));
                      },
                      onImportPress: () {
                        ref
                            .read(userModelNotifierProvider.notifier)
                            .loadUser(users[index]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const EditScreen(number: 0);
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
                );
              })),
    );
  }
}
