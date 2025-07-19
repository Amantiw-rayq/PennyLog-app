// lib/pages/report_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/repair_job.dart';

class ReportPage extends StatelessWidget {
  final Box<RepairJob> box = Hive.box<RepairJob>('repairs');

  ReportPage({Key? key}) : super(key: key);

  Map<String, double> _calculateMonthlyTotals(List<RepairJob> jobs) {
    final Map<String, double> totals = {};
    for (var job in jobs) {
      final date = job.dropoffDate;
      final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      final charge = job.totalCharge ?? 0;
      totals.update(key, (value) => value + charge, ifAbsent: () => charge);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final jobs = box.values.toList();
    jobs.sort((a, b) => b.dropoffDate.compareTo(a.dropoffDate));
    final monthlyTotals = _calculateMonthlyTotals(jobs);

    final sortedKeys = monthlyTotals.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        title: const Text('Monthly Report', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
      ),
      body: monthlyTotals.isEmpty
          ? Center(
        child: Text(
          'No data to report.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        itemCount: sortedKeys.length,
        itemBuilder: (context, index) {
          final key = sortedKeys[index];
          final amount = monthlyTotals[key]!;
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                key,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '₹${amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
