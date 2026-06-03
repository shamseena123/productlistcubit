import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/address_model.dart';

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
    loadAddresses();
  }

  static const String boxName = 'addressBox';
  static const String key = 'saved_addresses';

  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  /// LOAD ALL ADDRESSES
  Future<void> loadAddresses() async {
    final box = Hive.box(boxName);

    final data = box.get(key);

    if (data != null) {
      _addresses = List<AddressModel>.from(data);
    }

    emit(AddressLoaded(_addresses));
  }

  /// ADD ADDRESS
  Future<void> saveAddress(AddressModel address) async {
    final box = Hive.box(boxName);

    _addresses.add(address);

    await box.put(key, _addresses);

    emit(AddressLoaded(_addresses));
  }

  /// DELETE ADDRESS
  Future<void> deleteAddress(int index) async {
    final box = Hive.box(boxName);

    _addresses.removeAt(index);

    await box.put(key, _addresses);

    emit(AddressLoaded(_addresses));
  }

  void clearAddressState() {
    _addresses.clear();
    emit(AddressLoaded([]));
  }
}
