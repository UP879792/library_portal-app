import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/services/user_service.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:provider/provider.dart';

class LendToUser extends StatefulWidget {
  @override
  State<LendToUser> createState() => _LendToUserState();
}

class _LendToUserState extends State<LendToUser> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final users = userService.allUsers
                ?.where(
                  (element) =>
                      element.name.toLowerCase().contains(
                            query.toLowerCase(),
                          ) &&
                      !element.isAdmin,
                )
                .toList() ??
            [];
        return Scaffold(
          appBar: const LibraryAppBar(title: "Select User"),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                TextField(
                  onChanged: (text) {
                    query = text;
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Search"),
                  ),
                ),
                SizedBox(height: 20.w),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        users.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.0.w),
                            child: _buildUser(users[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUser(LibraryUser user) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(user);
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        color: ColorConfig.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
