import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/routes/account_management/account_management_controller.dart';
import 'package:library_portal_app/routes/account_management/borrowed_books.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:provider/provider.dart';

class AccountManagement extends StatelessWidget {
  final LibraryUser user;
  const AccountManagement({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountManagementController(context.read(), context.read()),
      builder: (context, child) => _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountManagementController>(builder: (context, controller, _) {
      return Scaffold(
        appBar: const LibraryAppBar(
          title: "Account Management",
        ),
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text(controller.user.email),
             
            ),
            SizedBox(height: 15.w),
            
            controller.user.isAdmin?
            Column(
              children: [
                
              ],
            )
            :
            InkWell(
              onTap: () {
                RouteNavigation.push(context, BorrowedBookScreen(controller: controller));
              },
              child: ListTile(
                leading: Icon(Icons.book),
                title: Text("Borrowed Books"),
              ),
            ),
          ]),
        ),
      );
    });
  }
}
