import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userProfile});
  final UserProfile userProfile;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? text;
  String? title;
  int selectedIndex = 0;
  void onPressProfileButton() {
    setState(() {
      selectedIndex = 0;
      title = "My Name is";
      // ignore: prefer_interpolation_to_compose_strings
      text = (widget.userProfile.name?.title ?? 'The value is null') +
          " " +
          (widget.userProfile.name?.first ?? 'The value is null') +
          " " +
          (widget.userProfile.name?.last ?? 'The value is null');
    });
  }

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
    title = "My Name is ";
    // ignore: prefer_interpolation_to_compose_strings
    text = (widget.userProfile.name?.title ?? 'The value is null') +
        " " +
        (widget.userProfile.name?.first ?? 'The value is null') +
        " " +
        (widget.userProfile.name?.last ?? 'The value is null');
  }

  void onPressEmailButton() {
    setState(() {
      selectedIndex = 1;
      title = "My Email is ";
      text = widget.userProfile.email!;
    });
  }

  void onPressBirthdayButton() {
    setState(() {
      selectedIndex = 2;
      title = "My Birthday is";
      DateTime formatedDate = DateTime.parse(widget.userProfile.dob!.date!);
      text = DateFormat('yyyy/MM/dd').format(formatedDate);
    });
  }

  void onPressLocationButton() {
    setState(() {
      selectedIndex = 3;
      title = "Location points are";
      // ignore: prefer_interpolation_to_compose_strings
      text = widget.userProfile.location!.coordinates!.latitude!.toString() +
          " " +
          widget.userProfile.location!.coordinates!.longitude!.toString();
    });
  }

  void onPressPhoneButton() {
    setState(() {
      selectedIndex = 4;
      title = "My phone Number is ";
      text = widget.userProfile.phone!;
    });
  }

  void onPressLockButton() {
    setState(() {
      selectedIndex = 5;
      title = 'My Password is';
      text = widget.userProfile.login!.password!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile Screen"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.black87,
                  height: MediaQuery.of(context).size.height / 2,
                ),
                Container(
                  color: Colors.white70,
                  height: 200,
                )
              ],
            ),
            Positioned(
              top: 80,
              left: 10,
              right: 10,
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        color: Colors.grey[200],
                      ),
                      Container(
                        height: 2,
                        color: Colors.grey[600],
                      ),
                      Container(
                        height: 300,
                        color: Colors.cyanAccent[100],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditScreen(
                            userProfile: widget.userProfile,
                          );
                        }));
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ),
                Positioned(
                  top: 85,
                  child: Container(
                    width: 380,
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              widget.userProfile.picture!.thumbnail!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            title!,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(39, 39, 39, 0.5)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            text!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color.fromRGBO(39, 39, 39, 1)),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 20),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: onPressProfileButton,
                                  icon: const Icon(
                                    Icons.person_2_outlined,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onPressEmailButton,
                                  icon: const Icon(
                                    Icons.mail,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onPressBirthdayButton,
                                  icon: const Icon(
                                    Icons.list_alt,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onPressLocationButton,
                                  icon: const Icon(
                                    Icons.location_on,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onPressPhoneButton,
                                  icon: const Icon(
                                    Icons.phone,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: onPressLockButton,
                                  icon: const Icon(
                                    Icons.lock,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
