import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/map_screen.dart';
import 'package:task_4/Service/database.dart';
import 'package:task_4/provider/user_notifier_provider.dart';
import 'package:task_4/repository/user_repo.dart';

// ignore: must_be_immutable
class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key, required this.number});
  final int number;

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  pickImageFromGallery(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No image is Selected")));
      }
    }
  }

  File? imageFile;
  String? uploadedImageUrl;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNocontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController latitueController = TextEditingController();
  TextEditingController longitudeCOntroller = TextEditingController();
  TextEditingController latLngController = TextEditingController();

  @override
  void initState() {
    UserProfile userProfile = ref.read(userModelNotifierProvider);
    super.initState();
    controllersText(userProfile);
  }

  void controllersText(UserProfile userProfile) {
    firstNameController.text = userProfile.name!.first!;
    lastNameController.text = userProfile.name!.last!;
    emailController.text = userProfile.email!;
    phoneNocontroller.text = userProfile.phone!;
    passwordController.text = userProfile.login!.password!;
    latitueController.text =
        userProfile.location!.coordinates!.latitude.toString();
    longitudeCOntroller.text =
        userProfile.location!.coordinates!.longitude.toString();
    latLngController.text =
        "${latitueController.text},${longitudeCOntroller.text}";
  }

  uploadImageInFireBase() async {
    try {
      if (imageFile != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        var strageRef =
            FirebaseStorage.instance.ref().child('User Image/$fileName');
        var uploadedImage = await strageRef.putFile(imageFile!);
        String downloadImageUrl = await uploadedImage.ref.getDownloadURL();
        setState(() {
          uploadedImageUrl = downloadImageUrl;
        });
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              " Error in Image Upload $error",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool checkNetworkImage(String imageUrl) {
    return imageUrl.startsWith('http');
  }

  bool checkImageIsBase64Encode(String imageUrl) {
    if (imageUrl.startsWith('/')) {
      return true;
    }
    return false;
  }

  void getLatLngFromTextField(String line) {
    if (line.contains(',')) {
      List<String> values = line.split(',');
      if (values.length == 2) {
        setState(() {
          latitudeValue = values[0];
          longitudeValue = values[1];
          latitueController.text = values[0];
          longitudeCOntroller.text = values[1];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Input, More then one Comma Found"),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("invalid Values"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  String? latitudeValue;
  String? longitudeValue;
  bool isHide = true;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = ref.watch(userModelNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                imageFile != null
                    ? Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: FileImage(
                                imageFile!,
                              ),
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipOval(
                          child: checkNetworkImage(
                                  userProfile.picture!.thumbnail!)
                              ? Image.network(
                                  userProfile.picture!.thumbnail!,
                                  fit: BoxFit.cover,
                                )
                              : checkImageIsBase64Encode(
                                      userProfile.picture!.thumbnail!)
                                  ? Image.memory(
                                      base64Decode(
                                          userProfile.picture!.thumbnail!),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(userProfile.picture!.thumbnail!)),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                  onPressed: () {
                    pickImageFromGallery(context);
                  },
                  child: const Text("Edit Image"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: firstNameController,
                          onSaved: (newValue) =>
                              firstNameController.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter First Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("First Name"),
                              hintText: "Enter First Name",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: lastNameController,
                          onSaved: (newValue) =>
                              lastNameController.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Last Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Last Name"),
                              hintText: "Enter Last Name",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          onSaved: (newValue) =>
                              emailController.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Your Email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Email"),
                              hintText: "Enter Your Email",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.email)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: phoneNocontroller,
                          onSaved: (newValue) =>
                              phoneNocontroller.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Edit Phone Number";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Phone Number"),
                              hintText: "Edit Phone Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Icon(Icons.phone)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: isHide,
                          onSaved: (newValue) =>
                              passwordController.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {}
                            return;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please your Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text("Password"),
                              hintText: "Enter Your Password",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isHide = !isHide;
                                    });
                                  },
                                  icon: Icon(isHide == true
                                      ? CupertinoIcons.lock_fill
                                      : Icons.lock_open))),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          initialValue:
                              "${userProfile.location!.coordinates!.latitude},${userProfile.location!.coordinates!.longitude}",
                          onSaved: (newValue) =>
                              latLngController.text = newValue!,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              ref
                                  .read(userModelNotifierProvider.notifier)
                                  .updateLocationPoints(value);
                            }
                            return;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Choose Location";
                            } else {
                              latLngController.text = value;
                              ref
                                  .read(userModelNotifierProvider.notifier)
                                  .updateLocationPoints(value);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text("Location"),
                              hintText: "Choose Locataion from Map",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const MapScreeen();
                                    }));
                                  },
                                  icon: const Icon(Icons.location_on))),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.amber)),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              if (widget.number == 0) {
                                DatabaseService databaseService =
                                    DatabaseService();
                                int done = await databaseService
                                    .updateDataInSqliteDatabase(
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        phoneNocontroller.text,
                                        passwordController.text,
                                        latitueController.text,
                                        longitudeCOntroller.text,
                                        userProfile.login!.uuid!);

                                if (imageFile != null) {
                                  String sqlLiteImageUrl = await databaseService
                                      .convertImageIntoBase64String(imageFile!);
                                  databaseService.updateImageInSqliteDatabase(
                                      sqlLiteImageUrl,
                                      userProfile.login!.uuid!);
                                }
                                if (done == 1) {
                                  final user = await databaseService
                                      .findUserByUuid(userProfile.login!.uuid!);
                                  if (user != null) {
                                    ref
                                        .read(
                                            userModelNotifierProvider.notifier)
                                        .updateUser(user);
                                    ref
                                        .read(
                                            stateOFListOfUsersofSqlite.notifier)
                                        .updateUser(user, userProfile.email!);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        " User Profile Updated Successfully",
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } else {
                                await uploadImageInFireBase();
                                UserProfile? user =
                                    await UserRepository.updateUserInfo(
                                        userProfile,
                                        userProfile.email!,
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        phoneNocontroller.text.toString(),
                                        passwordController.text.toString(),
                                        uploadedImageUrl,
                                        ref,
                                        latitueController.text.toString(),
                                        longitudeCOntroller.text.toString(),
                                        context);
                                ref
                                    .read(userModelNotifierProvider.notifier)
                                    .updateUser(user!);
                              }

                              setState(() {
                                isLoading = false;
                              });

                              Future.delayed(const Duration(seconds: 1), () {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              });

                              imageFile = null;
                              imageUrl = null;
                            },
                            child: isLoading == true
                                ? const CircularProgressIndicator()
                                : widget.number == 1
                                    ? const Text("Update Profile to Firebase")
                                    : const Text("Update Profile to Sqlite"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
