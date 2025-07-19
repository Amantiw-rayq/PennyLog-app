import 'package:hive/hive.dart';
part 'agent_transaction.g.dart';

@HiveType(typeId: 2)
class AgentTransaction extends HiveObject {
  @HiveField(0) int agentKey;
  @HiveField(1) String description;
  @HiveField(2) double amount;
  @HiveField(3) bool isPayment;
  @HiveField(4) DateTime? date;

  AgentTransaction({
    required this.agentKey,
    required this.description,
    required this.amount,
    required this.isPayment,
    this.date,
  });
  Map<String, dynamic> toMap() => {
    'agentKey': agentKey,
    'description': description,
    'amount': amount,
    'isPayment': isPayment,
    'date': date?.toIso8601String(),
  };

  factory AgentTransaction.fromMap(Map<String, dynamic> map) {
    return AgentTransaction(
      agentKey: map['agentKey'] as int,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      isPayment: map['isPayment'] as bool,
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : null,
    );
  }
}

