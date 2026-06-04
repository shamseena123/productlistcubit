import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/address_model.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';

/// STATES
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;

  AddressLoaded(this.addresses);
}

/// CUBIT
class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial()) {
    initializeUserAddresses();
  }

  static const String boxName = 'addressBox';
  final LocalStorageServices storageService = LocalStorageServices();

  String _addressKey = 'saved_addresses';

  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  Future<void> initializeUserAddresses() async {
    print("initializeUserAddresses CALLED");

    final currentUser = await storageService.getString("currentUser");

    print("Current User: $currentUser");

    if (currentUser == null) {
      _addresses.clear();
      emit(AddressLoaded([]));
      return;
    }

    _addressKey = 'saved_addresses_$currentUser';

    await loadAddresses();
  }

  /// LOAD ALL ADDRESSES
  Future<void> loadAddresses() async {
    final box = Hive.box(boxName);
    print("ALL KEYS = ${box.keys.toList()}");

    final data = box.get(_addressKey);

    print("Address Key: $_addressKey");
    print("Loaded Data: $data");
    print("Loaded data type:${data.runtimeType}");

    _addresses.clear();

    if (data != null) {
      _addresses.addAll(List<AddressModel>.from(data));
    }

    emit(AddressLoaded(List.from(_addresses)));
  }

  /// ADD ADDRESS
  Future<void> saveAddress(AddressModel address) async {
    print("SAVE ADDRESS CALLED");
    final box = Hive.box(boxName);

    _addresses.add(address);

    print("SAVING TO KEY: $_addressKey");
    print("ADDRESS COUNT: ${_addresses.length}");
    print("ADDRESS LIST:$_addresses");

    await box.put(_addressKey, _addresses);

    print("AFTER SAVE =${box.get(_addressKey)}");

    emit(AddressLoaded(_addresses));
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(int index) async {
    final box = Hive.box(boxName);

    _addresses.removeAt(index);

    await box.put(_addressKey, _addresses);

    emit(AddressLoaded(_addresses));
  }

  void clearAddressState() {
    print("CLEAR ADDRESS STATE CALLED");
    _addresses.clear();
    emit(AddressLoaded([]));
  }
}
