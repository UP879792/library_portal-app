import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:library_portal_app/configs/route_config.dart';
import 'package:library_portal_app/models/book_detail.dart';
import 'package:library_portal_app/models/library_user.dart';
import 'package:library_portal_app/routes/login/login_route.dart';
import 'package:library_portal_app/services/library_service.dart';
import 'package:library_portal_app/services/user_service.dart';
import 'package:library_portal_app/utils/snackbar.dart';
import 'package:library_portal_app/utils/utils.dart';
import 'package:toast/toast.dart';

class LibraryDashboardController extends ChangeNotifier {
  final LibraryService _libraryService;
  final UserService _userService;
  final bool isGuestUser;

  LibraryDashboardController(
    this.isGuestUser,
    this._libraryService,
    this._userService,
  ) {
    init();
  }

  bool get isAdmin => _userService.user?.isAdmin ?? false;

  final searchController = TextEditingController();
  String query = '';
  bool isSearching = false;

  LibraryUser? get currentUser => _userService.user;

  bool _isLoading = false;

  bool get isLoading => _isLoading || _libraryService.isLoading && books.isEmpty;
  List<Book> get books =>
      _libraryService.books
          ?.where(
            (element) => element.title.trim().toLowerCase().contains(query.trim().toLowerCase()),
          )
          .toList() ??
      [];

  void onLibraryUpdate() {
    notifyListeners();
  }

  void onUsersUpdate() {
    notifyListeners();
  }

  Future<void> init() async {
    _libraryService.addListener(onLibraryUpdate);
    _userService.addListener(onUsersUpdate);
  }

  void onChanged(String? text) {
    query = text ?? '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _libraryService.removeListener(onLibraryUpdate);
    _userService.removeListener(onUsersUpdate);
  }

  void logout(BuildContext context) async {
    try {
      void gotoLogin() => RouteNavigation.pushReplacement(context, LoginRoute());
      await _userService.logout();
      gotoLogin();
    } catch (e) {
      Toast.show(e.toString());
    }
  }

  void deleteBook(BuildContext context, Book book) async {
    final result = await Utils.showConfirmationDialog(context);
    _isLoading = true;
    notifyListeners();

    try {
      success() => SnackbarUtils.success(context, "Book deleted successfully");
      await _libraryService.deleteBook(book);
      success();
    } catch (e) {
      SnackbarUtils.error(context, e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }
}
