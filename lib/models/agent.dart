import 'package:hive/hive.dart';

part 'agent.g.dart';

@HiveType(typeId: 1)
class Agent extends HiveObject {
  @HiveField(0)
  String name;

  Agent({required this.name});
  Map<String, dynamic> toMap() => {'name': name};

  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(name: map['name'] as String);
  }
}


