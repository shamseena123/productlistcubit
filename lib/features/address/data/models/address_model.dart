import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 2)
class AddressModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String street;

  @HiveField(3)
  final String city;

  @HiveField(4)
  final String pincode;

  AddressModel({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.pincode,
  });
}
