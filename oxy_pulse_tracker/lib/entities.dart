import 'package:objectbox/objectbox.dart';

enum TemperatureUnit {
  fahrenheit,
  celsius,
}

@Entity()
class MemberLog {
  @Id()
  int id;
  late DateTime timestamp;
  double? oxygenSaturation;
  double? pulse;
  double? temp;
  TemperatureUnit? tempUnit;

  final member = ToOne<Member>();

  MemberLog({
    this.id = 0,
    this.oxygenSaturation,
    this.pulse,
    this.temp,
    this.tempUnit = TemperatureUnit.fahrenheit,
  }) {
    timestamp = DateTime.now();
  }
}

@Entity()
class Member {
  @Id()
  int id;
  String name;
  String relation;
  int? age;
  String avatar;
  bool isAvatarImage;

  @Backlink()
  final logs = ToMany<MemberLog>();

  Member({
    this.id = 0,
    required this.name,
    required this.relation,
    this.age,
    required this.avatar,
    required this.isAvatarImage,
  });
}

@Entity()
class Settings {
  @Id()
  int id;
  TemperatureUnit? preferredTemperatureUnit;
  List<String>? customRelations;

  Settings({
    this.id = 0,
    this.preferredTemperatureUnit,
    this.customRelations,
  });
}
