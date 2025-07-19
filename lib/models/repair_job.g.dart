// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepairJobAdapter extends TypeAdapter<RepairJob> {
  @override
  final int typeId = 0;

  @override
  RepairJob read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepairJob(
      customerName: fields[0] as String?,
      mobile: fields[1] as String?,
      tvModel: fields[2] as String?,
      tvIssue: fields[3] as String?,
      dropoffDate: fields[4] as DateTime,
      pickupDate: fields[5] as DateTime?,
      totalCharge: fields[6] as double?,
      isPaid: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RepairJob obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.mobile)
      ..writeByte(2)
      ..write(obj.tvModel)
      ..writeByte(3)
      ..write(obj.tvIssue)
      ..writeByte(4)
      ..write(obj.dropoffDate)
      ..writeByte(5)
      ..write(obj.pickupDate)
      ..writeByte(6)
      ..write(obj.totalCharge)
      ..writeByte(7)
      ..write(obj.isPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairJobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
