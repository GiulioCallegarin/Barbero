import 'package:isar/isar.dart';

part 'client.g.dart';

@collection
class Client {
  final Id id = Isar.autoIncrement;
  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String address;
  late String gender;
}
