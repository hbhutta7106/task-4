import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.email,
      required this.onTap,
      required this.onImportPress,
      required this.delete,
      required this.requireImportButton});
  final String imagePath;
  final String name;
  final String email;
  final VoidCallback onTap;
  final VoidCallback onImportPress;
  final VoidCallback delete;
  final bool requireImportButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(39, 39, 39, 0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.network(
                    imagePath,
                    height: 65,
                    width: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                            color: Color.fromRGBO(39, 39, 39, 0.5),
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onImportPress,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                  child: requireImportButton == true
                      ? const Text(
                          "Import",
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                ),
              ],
            ),
            if (requireImportButton == false)
              Container(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  onPressed: delete,
                  icon: const Icon(
                    CupertinoIcons.delete,
                    size: 25,
                  ),
                  color: Colors.grey[500],
                ),
              )
          ],
        ),
      ),
    );
  }
}
