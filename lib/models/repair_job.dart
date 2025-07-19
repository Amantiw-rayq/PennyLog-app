// lib/models/repair_job.dart
import 'package:hive/hive.dart';

part 'repair_job.g.dart';

@HiveType(typeId: 0)
class RepairJob extends HiveObject {
  @HiveField(0)
  String? customerName;

  @HiveField(1)
  String? mobile;

  @HiveField(2)
  String? tvModel;

  @HiveField(3)
  String? tvIssue;

  @HiveField(4)
  DateTime dropoffDate;

  @HiveField(5)
  DateTime? pickupDate;

  @HiveField(6)
  double? totalCharge;

  @HiveField(7)
  bool isPaid;

  RepairJob({
    this.customerName,
    this.mobile,
    this.tvModel,
    this.tvIssue,
    required this.dropoffDate,
    this.pickupDate,
    this.totalCharge,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() => {
    'customerName': customerName,
    'mobile': mobile,
    'tvModel': tvModel,
    'tvIssue': tvIssue,
    'dropoffDate': dropoffDate.toIso8601String(),
    'pickupDate': pickupDate?.toIso8601String(),
    'totalCharge': totalCharge,
    'isPaid': isPaid,
  };

  factory RepairJob.fromMap(Map<String, dynamic> map) {
    return RepairJob(
      customerName: map['customerName'] as String?,
      mobile: map['mobile'] as String?,
      tvModel: map['tvModel'] as String?,
      tvIssue: map['tvIssue'] as String?,
      dropoffDate: DateTime.parse(map['dropoffDate'] as String),
      pickupDate: map['pickupDate'] != null
          ? DateTime.parse(map['pickupDate'] as String)
          : null,
      totalCharge: map['totalCharge'] != null
          ? (map['totalCharge'] as num).toDouble()
          : null,
      isPaid: map['isPaid'] as bool,
    );
  }
}
