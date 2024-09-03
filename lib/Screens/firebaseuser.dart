import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';
import 'package:task_4/Screens/profile_screen.dart';
import 'package:task_4/Widget/profile_card.dart';
import 'package:task_4/provider/user-notifier-provider.dart';
import 'package:task_4/repository/userRepo.dart';

class FirebaseUsersScreen extends ConsumerWidget {
  const FirebaseUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<UserProfile> users = ref.watch(userNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: users.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemBuilder: (context, index) => ProfileCard(
                    delete: () {
                      UserRepository.deleteUser(users[index].email!, context);
                      ref
                          .read(userNotifierProvider.notifier)
                          .deleteUser(users[index].email!);
                    },
                    imagePath:
                        users[index].picture?.thumbnail ?? 'The value is Null',
                    // ignore: prefer_interpolation_to_compose_strings
                    name: (users[index].name?.title ?? 'The value is null') +
                        " " +
                        (users[index].name?.first ?? 'The value is null') +
                        " " +
                        (users[index].name?.last ?? 'The value is null'),
                    email: users[index].email ?? "The Value is null",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProfileScreen(userProfile: users[index]);
                      }));
                    },
                    onImportPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
