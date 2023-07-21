import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/admin_panel/book_addition_controller.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BookAddition extends StatelessWidget {
  const BookAddition({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookAdditionController(context.read()),
      builder: (context, _) => _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookAdditionController>(
      builder: (context, controller, _) {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading,
          child: Form(
            key: controller.formKey,
            child: Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: ColorConfig.gradientColor,
              appBar: LibraryAppBar(
                title: "Add a Book",
                action: TextButton(
                  onPressed: controller.uploadBook,

                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DottedBorder(
                            dashPattern: const [20, 30],
                            child: Stack(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: controller.pickImage,
                                  child: Container(
                                    height: 192.w,
                                    width: 115.w,
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera,
                                          size: 28.w,
                                        ),
                                        SizedBox(height: 4.w),
                                        const Text("Add Image"),
                                      ],
                                    ),
                                  ),
                                ),
                                if (controller.selectedImage != null)
                                  Center(
                                    child: Image.memory(
                                      controller.selectedImage!,
                                      height: 192.w,
                                      width: 115.w,
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                if (controller.selectedImage != null)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 40.w,
                                      decoration: BoxDecoration(
                                        color: ColorConfig.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20.w),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: controller.removeImage,
                                            icon: const Icon(
                                              Icons.delete,
                                              color: ColorConfig.errorColor,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: controller.pickImage,
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Column(
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
                                TextFormField(
                                  controller: controller.authorController,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "Author",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
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
                                TextFormField(
                                  controller: controller.publisherController,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "Publisher",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                const Text(
                                  "Quantity",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextFormField(
                                  controller: controller.quantityController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter.singleLineFormatter,
                                  ],
                                  buildCounter: (
                                    context, {
                                    currentLength = 2,
                                    isFocused = false,
                                    maxLength = 23,
                                  }) {
                                    return const SizedBox();
                                  },
                                  decoration: const InputDecoration.collapsed(
                                    hintText: "Quantity",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.w),
                      const Text(
                        "Title",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      TextFormField(
                        controller: controller.titleController,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        maxLines: 3,
                        minLines: 1,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Book Title",
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(height: 15.w),
                      SizedBox(
                        height: 200.w,
                        child: TextFormField(
                          controller: controller.descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(hintText: "Book Description", border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(height: 15.w),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
