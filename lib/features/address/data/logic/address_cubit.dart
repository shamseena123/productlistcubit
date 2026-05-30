import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/address_model.dart';

/// STATES
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoaded extends AddressState {
  final AddressModel? address;

  AddressLoaded(this.address);
}

/// CUBIT
class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial()) {
    loadAddress();
  }

  static const String boxName = 'addressBox';
  static const String key = 'saved_address';

  AddressModel? _address;

  AddressModel? get address => _address;

  /// LOAD ADDRESS
  Future<void> loadAddress() async {
    final box = Hive.box(boxName);

    final data = box.get(key);

    if (data != null && data is AddressModel) {
      _address = data;
    }

    emit(AddressLoaded(_address));
  }

  /// SAVE ADDRESS
  Future<void> saveAddress(AddressModel address) async {
    final box = Hive.box(boxName);

    await box.put(key, address);

    _address = address;

    emit(AddressLoaded(_address));
  }

  /// CLEAR ADDRESS
  Future<void> clearAddress() async {
    final box = Hive.box(boxName);

    await box.delete(key);

    _address = null;

    emit(AddressLoaded(null));
  }
}
