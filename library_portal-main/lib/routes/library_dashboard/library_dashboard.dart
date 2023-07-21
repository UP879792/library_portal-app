import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/routes/account_management/account_management.dart';
import 'package:library_portal_app/routes/admin_panel/book_addition.dart';
import 'package:library_portal_app/routes/book_detail/book_detail.dart';
import 'package:library_portal_app/routes/library_dashboard/library_dashboard_controller.dart';
import 'package:provider/provider.dart';

class LibraryDashboard extends StatelessWidget {
  final bool isGuestUser;
  const LibraryDashboard({super.key, this.isGuestUser = false});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryDashboardController(
        isGuestUser,
        context.read(),
        context.read(),
      ),
      builder: (context, _) => _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryDashboardController>(
      builder: (context, controller, _) {
        return Scaffold(
          floatingActionButton: controller.isAdmin
              ? FloatingActionButton.extended(
                  backgroundColor: ColorConfig.primaryColor,
                  elevation: 16.w,
                  onPressed: () {
                    RouteNavigation.push(context, const BookAddition());
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text(
                    "Add Book",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : null,
          appBar: AppBar(
            title: const Text(
              "Library Dashboard",
              style: TextStyle(
                color: ColorConfig.gradientColor,
              ),
            ),
            backgroundColor: ColorConfig.primaryColor,
          ),
          drawer: controller.currentUser != null
              ? Drawer(
                  backgroundColor: ColorConfig.gradientColor,
                  width: 280.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox(height: 100.w),
                      CircleAvatar(
                        radius: 50.w,
                        child: Text(
                          (controller.currentUser!.name.split(""))[0],
                          style: const TextStyle(fontSize: 44),
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Text(
                        controller.currentUser!.name,
                        style: const TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      SizedBox(height: 50.w),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          RouteNavigation.push(context, AccountManagement(user: controller.currentUser!));
                        },
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                            color: ColorConfig.primaryColor,
                            width: 2,
                          )),
                          leading: Icon(
                            Icons.account_box,
                            size: 30.w,
                            // color: Colors.white,
                          ),
                          title: const Text("Account Management"),
                        ),
                      ),
                      SizedBox(
                        height: 30.w,
                      ),
                      InkWell(
                        onTap: () => controller.logout(context),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                            color: ColorConfig.primaryColor,
                            width: 2,
                          )),
                          leading: Icon(
                            Icons.logout,
                            size: 30.w,
                            // color: Colors.white,
                          ),
                          title: const Text("Log Out"),
                        ),
                      ),
                    ]),
                  ),
                )
              : null,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.w),
                TextField(
                  controller: controller.searchController,
                  onChanged: controller.onChanged,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Search"),
                  ),
                ),
                SizedBox(height: 10.w),
                if (controller.books.isEmpty)
                  const Center(
                    child: Text(
                      "No book found",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: ListView.builder(
                        itemCount: controller.books.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.0.w),
                            child: BookContainer(
                              book: controller.books[i],
                              isAdmin: controller.isAdmin,
                              onDelete: controller.isAdmin ? () => controller.deleteBook(context, controller.books[i]) : null,
                              onPressed: () {
                                RouteNavigation.push(context, BookDetail(book: controller.books[i]));
                              },
                            ),
                          );
                        },
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
}

class BookContainer extends StatelessWidget {
  final Function() onPressed;
  final Book book;
  final bool isAdmin;
  final VoidCallback? onDelete;
  const BookContainer({
    super.key,
    required this.onPressed,
    required this.book,
    this.onDelete,
    this.isAdmin = false,
  }) : assert(isAdmin || (!isAdmin && onDelete == null), "Either user is admin or delete function is null");

  @override
  Widget build(BuildContext context) {
    double imageHeight = 100.w;
    return InkWell(
      onTap: onPressed,
      child: Container(
        color: ColorConfig.primaryColor,
        height: imageHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70.w,
              height: imageHeight,
              child: Image.network(
                book.imageUrl, // ?? 'assets/zerotoone.jpeg',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.w),
                  Text(
                    book.title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    book.description,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      text: "~~~~~~~ by ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: book.author,
                          style: const TextStyle(fontStyle: FontStyle.italic, height: 1.8),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 4.w),
                ],
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
      ),
    );
    // Padding(
    //   padding: EdgeInsets.symmetric(vertical: 12.w),
    //   child: InkWell(
    //     onTap: onPressed,
    //     child: Container(
    //       decoration: const BoxDecoration(border: Border(), color: ColorConfig.primaryColor),
    //       child: Padding(
    //         padding: EdgeInsets.all(8.w),
    //         child: Row(children: [
    //           Image.asset(
    //             "assets/zerotoone.jpeg",
    //             width: 50.w,
    //           ),
    //           SizedBox(width: 15.w),
    //           Text("Zero to One"),
    //           SizedBox(width: 50.w),
    //           Column(
    //             children: [
    //               Text("Author:Peter thiel"),
    //             ],
    //           )
    //         ]),
    //       ),
    //     ),
    //   ),
    // );
  }
}
