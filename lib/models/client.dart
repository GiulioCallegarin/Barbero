import 'package:hive_ce_flutter/hive_flutter.dart';

part 'client.g.dart'; // Make sure this is generated

@HiveType(typeId: 0)
class Client extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String firstName;

  @HiveField(2)
  late String lastName;

  @HiveField(3)
  late String phoneNumber;

  @HiveField(4)
  late String address;

  @HiveField(5)
  late String gender;

  Client({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.gender,
  });

  static Future<int> getNextId() async {
    var idsBox = Hive.box('ids');
    int id = idsBox.get('client', defaultValue: 0);
    idsBox.put('client', id + 1);
    return id;
  }
}
