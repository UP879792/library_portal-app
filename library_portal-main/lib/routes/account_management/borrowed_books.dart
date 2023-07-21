import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/account_management/account_management_controller.dart';
import 'package:library_portal_app/routes/library_dashboard/library_dashboard.dart';
import 'package:library_portal_app/widgets/appbar.dart';

class BorrowedBookScreen extends StatelessWidget {
  final AccountManagementController controller;
  const BorrowedBookScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LibraryAppBar(title: "Borrowed Books"),
      body: (controller.borrowedBooks.isEmpty)
          ? const Center(
              child: Text("No Book Found"),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < controller.borrowedBooks.length; i++)
                      Padding(
                        padding:  EdgeInsets.only(top: 20.0.w),
                        child: BookContainer(
                          onPressed: () {},
                          book: controller.borrowedBooks[i],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
