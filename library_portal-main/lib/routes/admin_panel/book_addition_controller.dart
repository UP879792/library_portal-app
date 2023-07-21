import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_portal_app/configs/color_config.dart';
import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/utils/snackbar.dart';

class BookAdditionController extends ChangeNotifier {
  final LibraryService _libraryService;

  BookAdditionController(this._libraryService);

  final authorController = TextEditingController();
  final publisherController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  Uint8List? selectedImage;

  bool isLoading = false;

  void pickImage() async {
    final imageSource = await showImageSource();
    if (imageSource != null) {
      final file = await _picker.pickImage(source: imageSource);
      if (file != null) {
        selectedImage = await file.readAsBytes();
        notifyListeners();
      }
    }
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  Future<ImageSource?> showImageSource() async {
    return showModalBottomSheet<ImageSource>(
      context: scaffoldKey.currentContext!,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 100.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 8.w,
                ),
                const Text(
                  "  Select from",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorConfig.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(ImageSource.gallery);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 20.w),
                              const Icon(Icons.image,size: 28,color: ColorConfig.errorColor,),
                              SizedBox(width: 10.w),
                              const Text("Gallery", style: TextStyle(
                                  fontSize: 18,
                                  
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 2.w,
                          height: 30.w,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(ImageSource.camera);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt,size: 28,),
                              SizedBox(width: 10.w),
                              const Text(
                                "Camera",
                                style: TextStyle(
                                  fontSize: 18,
                                  
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      enableDrag: false,
    );
  }

  void uploadBook() async {
    if (selectedImage == null) {
      SnackbarUtils.error(scaffoldKey.currentContext!, "Please select an image");
    } else if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      try {
        Book book = Book(
          author: authorController.text,
          publisher: publisherController.text,
          title: titleController.text,
          description: descriptionController.text,
          imageUrl: "",
          id: "${DateTime.now().millisecondsSinceEpoch}${titleController.text}",
          quantity: int.parse(quantityController.text),
          lentToUsers: [],
        );
        await _libraryService.updateOrCreateBook(book, selectedImage!);
        SnackbarUtils.success(scaffoldKey.currentContext!, "Book added successfully");
        Navigator.of(scaffoldKey.currentContext!).pop();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        SnackbarUtils.error(scaffoldKey.currentContext!, e.toString());
      }

      isLoading = false;
      notifyListeners();
    }
  }
}
