// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentTransactionAdapter extends TypeAdapter<AgentTransaction> {
  @override
  final int typeId = 2;

  @override
  AgentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentTransaction(
      agentKey: fields[0] as int,
      description: fields[1] as String,
      amount: fields[2] as double,
      isPayment: fields[3] as bool,
      date: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AgentTransaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.agentKey)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.isPayment)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
