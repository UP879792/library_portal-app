import 'package:flutter/material.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/routes/book_detail/book_detail_controller.dart';
import 'package:library_portal_app/routes/book_detail/lend_to_user.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BookDetail extends StatelessWidget {
  final Book book;
  const BookDetail({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookDetailController(
        context.read(),
        context.read(),
        book,
      ),
      builder: (context, _) => const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();
  @override
  Widget build(BuildContext context) {
    return Consumer<BookDetailController>(
      builder: (context, controller, _) {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading,
          child: Scaffold(
            backgroundColor: ColorConfig.gradientColor,
            appBar: LibraryAppBar(
              title: "Book Detail",
              action: controller.isAdmin
                  ? IconButton(
                      onPressed: () {
                        controller.deleteBook(context);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  : null,
            ),
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        controller.bookData.imageUrl,
                        width: 108,
                        height: 192,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Author",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.bookData.author,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 10.w),
                          const Text(
                            "Publisher",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(controller.bookData.publisher ?? "Anonymous"),
                          SizedBox(height: 10.w),
                          const Text(
                            "Book Status",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(controller.bookData.quantity > 0 ? "Available" : "Unavailable"),
                          SizedBox(height: 10.w),
                          if (controller.isAdmin)
                            ElevatedButton(
                              onPressed: () => controller.lendToUser(context),
                              child: const Text("Lend to User"),
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w),
                  if (controller.isAdmin)
                    InkWell(
                      onTap: () => controller.checkBookUser(context),
                      child: const Text(
                        "Check who's reading this book?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 153, 255),
                        ),
                      ),
                    ),
                  SizedBox(height: 15.w),
                  Text(
                    controller.bookData.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 15.w),
                  Text(
                    controller.bookData.description,
                    style: const TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 15.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BookDetailRow extends StatelessWidget {
  final String title;
  final String description;
  const BookDetailRow({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )),
        ),
        SizedBox(width: 60.w),
        Text(description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ))
      ],
    );
  }
}
