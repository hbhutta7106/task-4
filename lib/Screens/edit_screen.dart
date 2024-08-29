import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/repository/userRepo.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.userProfile});
  final UserProfile userProfile;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  pickImageFromGallery(BuildContext context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image is Selected")));
    }
  }

  File? imageFile;
  String? uploadedImageUrl;
  final _formkey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNocontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.userProfile.name!.first!;
    lastNameController.text = widget.userProfile.name!.last!;
    emailController.text = widget.userProfile.email!;
    phoneNocontroller.text = widget.userProfile.phone!;
    passwordController.text = widget.userProfile.login!.password!;
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

  bool isHide = true;
  String? imageUrl;
  @override
  Widget build(BuildContext context) {
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
                          child: Image.network(
                            widget.userProfile.picture!.thumbnail!,
                            fit: BoxFit.cover,
                          ),
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
                  autovalidateMode: AutovalidateMode.always,
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
                              lastNameController.text = newValue!,
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
                              lastNameController.text = newValue!,
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
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.amber)),
                            onPressed: () {
                              uploadImageInFireBase();
                              UserRepository.updateUserInfo(
                                  widget.userProfile,
                                  widget.userProfile.email!,
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  phoneNocontroller.text.toString(),
                                  passwordController.text.toString(),
                                  uploadedImageUrl,
                                  context);
                            },
                            child: const Text("Update Profile"),
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
