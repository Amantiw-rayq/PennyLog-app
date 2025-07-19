// lib/utils/backup.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/repair_job.dart';
import '../models/agent.dart';
import '../models/agent_transaction.dart';


Future<bool> _askStoragePermission() async {
  final status = await Permission.manageExternalStorage.request();
  return status.isGranted;
}

Future<String> exportAllData() async {
  bool granted = await _askStoragePermission();
  if (!granted) throw 'Storage permission denied';

  final dir = await getExternalStorageDirectory();
  final extRoot = Directory('${dir!.path.split("Android")[0]}ExternalBackup')
    ..createSync(recursive: true);

  final rb = Hive.box<RepairJob>('repairs');
  final ab = Hive.box<Agent>('agents');
  final tb = Hive.box<AgentTransaction>('transactions');

  final repairData = rb.values.map((j) => j.toMap()).toList();
  final agentData = ab.values.map((a) => a.toMap()).toList();
  final txData = tb.values.map((t) => t.toMap()).toList();

  final rFile = File('${extRoot.path}/repairs.json');
  final aFile = File('${extRoot.path}/agents.json');
  final tFile = File('${extRoot.path}/transactions.json');

  await rFile.writeAsString(jsonEncode(repairData));
  await aFile.writeAsString(jsonEncode(agentData));
  await tFile.writeAsString(jsonEncode(txData));

  return extRoot.path;
}

// Import back into boxes
Future<void> importAllData({bool clearFirst = false}) async {
  bool granted = await _askStoragePermission();
  if (!granted) throw 'Storage permission denied';
  final dir = await getExternalStorageDirectory();
  final extRoot = Directory('${dir!.path.split("Android")[0]}ExternalBackup');

  final rFile = File('${extRoot.path}/repairs.json');
  if (!rFile.existsSync()) return;

  final rb = Hive.box<RepairJob>('repairs');
  final ab = Hive.box<Agent>('agents');
  final tb = Hive.box<AgentTransaction>('transactions');

  if (clearFirst) {
    await rb.clear();
    await ab.clear();
    await tb.clear();
  }

  final rList = jsonDecode(await rFile.readAsString()) as List;
  final aList = jsonDecode(await File('${extRoot.path}/agents.json').readAsString()) as List;
  final tList = jsonDecode(await File('${extRoot.path}/transactions.json').readAsString()) as List;

  for (var m in rList) rb.add(RepairJob.fromMap(m));
  for (var m in aList) ab.add(Agent.fromMap(m));
  for (var m in tList) tb.add(AgentTransaction.fromMap(m));
}
