import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/provider/user_notifier_provider.dart';

class UserRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static addUserToFirebase(UserProfile user, BuildContext context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> allUsers = await firestore
          .collection("Users")
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();
      final List<DocumentSnapshot> userDocuments = allUsers.docs;
      if (userDocuments.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User already exists!'),
          ));
        }
      } else {
        await firestore.collection('Users').add(user.toMap());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User inserted successfully :"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              " Error, $error",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  static Future<UserProfile?> updateUserInfo(
      UserProfile user,
      String email,
      String? firstName,
      String? lastName,
      String? updatedEmail,
      String? updatedPhoneNo,
      String? passWord,
      String? imageUrl,
      WidgetRef ref,
      BuildContext context) async {
    UserProfile? newUser;
    try {
      QuerySnapshot<Map<String, dynamic>> allUsers = await firestore
          .collection("Users")
          .where('email', isEqualTo: user.email)
          .get();
      if (allUsers.docs.isNotEmpty) {
        var userToUpdate = allUsers.docs.first;
        UserProfile firebaseWalaUser =
            UserProfile.fromJson(userToUpdate.data());
        var updatedName =
            firebaseWalaUser.name?.copyWith(first: firstName, last: lastName);
        var updatedPassword =
            firebaseWalaUser.login?.copyWith(password: passWord);
        var updatedProfile =
            firebaseWalaUser.picture?.copyWith(thumbnail: imageUrl);
        newUser = firebaseWalaUser.copyWith(
            name: updatedName,
            login: updatedPassword,
            email: updatedEmail,
            phone: updatedPhoneNo,
            picture: updatedProfile);
        await firestore
            .collection('Users')
            .doc(userToUpdate.id)
            .update(newUser.toMap());
        ref
            .read(userNotifierProvider.notifier)
            .updateProfile(newUser, firebaseWalaUser);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                " User has been Updated Successfully",
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return newUser;
      } else {
        return null;
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              " Error $error",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return null;
    }
  }

  static deleteUser(String email, BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> userToDelete = await firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    if (userToDelete.docs.isNotEmpty) {
      await userToDelete.docs.first.reference.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              " User Deleted Succesfully",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              " User cannot Found Please Import first",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
