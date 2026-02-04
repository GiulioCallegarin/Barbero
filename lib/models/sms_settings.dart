import 'package:hive_ce_flutter/hive_flutter.dart';

part 'sms_settings.g.dart';

@HiveType(typeId: 5)
class SMSSettings {
  @HiveField(0)
  String gatewayUrl; // es: http://192.168.1.100:9090/send

  @HiveField(1)
  bool enabled;

  @HiveField(2)
  String senderNumber; // es: +39 327 068 7817

  SMSSettings({
    this.gatewayUrl = '',
    this.enabled = false,
    this.senderNumber = '',
  });
}
