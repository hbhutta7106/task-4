
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_4/Models/User/user.dart';

class UserRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static addUserToFirebase(UserProfile user, BuildContext context) async {
    try {
      await firestore.collection('Users').add(user.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User inserted successfully :"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
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

  static updateUserInfo(
      UserProfile user,
      String email,
      String? firstName,
      String? lastName,
      String? updatedEmail,
      String? updatedPhoneNo,
      String? passWord,
      String? imageUrl,
      BuildContext context) async {
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
        UserProfile newUser = firebaseWalaUser.copyWith(
            name: updatedName,
            login: updatedPassword,
            email: updatedEmail,
            phone: updatedPhoneNo,
            picture: updatedProfile);
        await firestore
            .collection('Users')
            .doc(userToUpdate.id)
            .update(newUser.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              " User has been Updated Successfully",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        var updatedName = user.name?.copyWith(first: firstName, last: lastName);
        var updatedPassword = user.login?.copyWith(password: passWord);
        UserProfile updatedUser = user.copyWith(
            name: updatedName,
            email: updatedEmail,
            phone: updatedPhoneNo,
            login: updatedPassword);
        await firestore.collection('Users').add(updatedUser.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              " User has been Stored with updated Values",
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            " Error $error",
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static deleteUser(String email, BuildContext context) async {
    QuerySnapshot<Map<String, dynamic>> userToDelete = await firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
    if (userToDelete.docs.isNotEmpty) {
      await userToDelete.docs.first.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            " User Deleted Succesfully",
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
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
