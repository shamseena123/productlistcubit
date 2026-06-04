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
  AddressCubit() : super(AddressInitial());

  static const String boxName = 'addressBox';
  final LocalStorageServices storageService = LocalStorageServices();

  String _addressKey = 'saved_addresses';
  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  bool _initialized = false;

  /// RESET WHEN USER CHANGES (IMPORTANT)
  void reset() {
    _initialized = false;
    _addresses.clear();
    emit(AddressLoaded([]));
  }

  /// INIT USER ADDRESS
  Future<void> initializeUserAddresses() async {
    if (_initialized) return;
    _initialized = true;

    print("initializeUserAddresses CALLED");

    final currentUser = await storageService.getString("currentUser");

    print("Current User: $currentUser");

    if (currentUser == null) {
      _addresses = [];
      emit(AddressLoaded([]));
      return;
    }

    _addressKey = 'saved_addresses${currentUser.trim()}';

    await loadAddresses();
  }

  /// LOAD ADDRESSES
  Future<void> loadAddresses() async {
    final box = Hive.box(boxName);

    final data = box.get(_addressKey);

    print("Address Key: $_addressKey");
    print("Loaded Data: $data");

    _addresses = [];

    if (data != null) {
      _addresses = List<AddressModel>.from(data);
    }

    emit(AddressLoaded(List.from(_addresses)));
  }

  /// SAVE ADDRESS
  Future<void> saveAddress(AddressModel address) async {
    final box = Hive.box(boxName);

    _addresses.add(address);

    await box.put(
      _addressKey,
      List<AddressModel>.from(_addresses),
    );

    emit(AddressLoaded(List.from(_addresses)));
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(int index) async {
    final box = Hive.box(boxName);

    _addresses.removeAt(index);

    await box.put(
      _addressKey,
      List<AddressModel>.from(_addresses),
    );

    emit(AddressLoaded(List.from(_addresses)));
  }

  void clearAddressState() {
    _addresses.clear();
    emit(AddressLoaded([]));
  }
}