import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';

class AuthCubit extends Cubit<bool> {
  final LocalStorageServices storageService;
  AuthCubit(this.storageService) : super(false);

  //LOGIN
  Future<void> login() async {
    await storageService.saveBool("isLoggedIn", true);
     
    emit(true);
  }

  Future<void> logout() async {
    await storageService.removeData("isLoggedIn");
    emit(false);
  }

  //CHECK SAVED SECTION

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await storageService.getBool("isLoggedIn");

    emit(isLoggedIn ?? false);
  }
}
