import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_4/Models/User/user.dart';
import 'package:task_4/Screens/edit_screen.dart';
import 'package:task_4/provider/user_notifier_provider.dart';

// ignore: must_be_immutable
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
  });
  // UserProfile userProfile;
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? text;
  String? title;
  int selectedIndex = 0;
  void onPressProfileButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 1;
      title = "My Name is";
      // ignore: prefer_interpolation_to_compose_strings
      text = (userProfile.name?.title ?? 'The value is null') +
          " " +
          (userProfile.name?.first ?? 'The value is null') +
          " " +
          (userProfile.name?.last ?? 'The value is null');
    });
  }

  @override
  void initState() {
    selectedIndex = 1;
    super.initState();

    // title = "My Name is ";
    // // ignore: prefer_interpolation_to_compose_strings
    // text = (widget.userProfile.name?.title ?? 'The value is null') +
    //     " " +
    //     (widget.userProfile.name?.first ?? 'The value is null') +
    //     " " +
    //     (widget.userProfile.name?.last ?? 'The value is null');
  }

  void onPressEmailButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 6;
      title = "My Email is ";
      text = userProfile.email!;
    });
  }

  void onPressBirthdayButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 2;
      title = "My Birthday is";
      DateTime formatedDate = DateTime.parse(userProfile.dob!.date!);
      text = DateFormat('yyyy/MM/dd').format(formatedDate);
    });
  }

  void onPressLocationButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 3;
      title = "Location points are";
      // ignore: prefer_interpolation_to_compose_strings
      text = userProfile.location!.coordinates!.latitude!.toString() +
          " " +
          userProfile.location!.coordinates!.longitude!.toString();
    });
  }

  void onPressPhoneButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 4;
      title = "My phone Number is ";
      text = userProfile.phone!;
    });
  }

  void onPressLockButton(UserProfile userProfile) {
    setState(() {
      selectedIndex = 5;
      title = 'My Password is';
      text = userProfile.login!.password!;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = ref.watch(userModelNotifierProvider);

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
                            userProfile: userProfile,
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
                              userProfile.picture!.thumbnail!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            width: 250,
                            child: Column(children: [
                              Text(
                                selectedIndex == 1 ? "My Name is" : title!,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(39, 39, 39, 0.5)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                selectedIndex == 1
                                    // ignore: prefer_interpolation_to_compose_strings
                                    ? (userProfile.name?.title ??
                                            'The value is null') +
                                        " " +
                                        (userProfile.name?.first ??
                                            'The value is null') +
                                        " " +
                                        (userProfile.name?.last ??
                                            'The value is null')
                                    : text!,
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromRGBO(39, 39, 39, 1)),
                              ),
                            ]),
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
                                  onPressed: () =>
                                      onPressProfileButton(userProfile),
                                  icon: const Icon(
                                    Icons.person_2_outlined,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      onPressEmailButton(userProfile),
                                  icon: const Icon(
                                    Icons.mail,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      onPressBirthdayButton(userProfile),
                                  icon: const Icon(
                                    Icons.list_alt,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      onPressLocationButton(userProfile),
                                  icon: const Icon(
                                    Icons.location_on,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      onPressPhoneButton(userProfile),
                                  icon: const Icon(
                                    Icons.phone,
                                    size: 40,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      onPressLockButton(userProfile),
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
