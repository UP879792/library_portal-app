import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BorrowedByUsers extends StatefulWidget {
  final Book book;
  const BorrowedByUsers({super.key, required this.book});

  @override
  State<BorrowedByUsers> createState() => _BorrowedByUsersState();
}

class _BorrowedByUsersState extends State<BorrowedByUsers> {
  String query = '';
  late Book book;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryService>(
      builder: (context, libraryService, _) {
        final users = libraryService
            .getBookBorrowers(book)
            .where(
              (element) => element.name.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: const LibraryAppBar(title: "Currently Reading"),
            body: users.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const Text(
                        "No one is currently reading this book.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.w),
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
                                    child: _buildUser(
                                      users[index],
                                      onDelete: () async {
                                        isLoading = true;
                                        setState(() {});
                                        await libraryService.returnBook(book, users[index]);
                                        isLoading = false;
                                        setState(() {});
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildUser(LibraryUser user, {required VoidCallback onDelete}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(user);
      },
      child: Stack(
        children: [
          Container(
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
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: ColorConfig.gradientColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    20.w,
                  ),
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.remove,
                  size: 30,
                  color: Colors.red,
                ),
                onPressed: onDelete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
