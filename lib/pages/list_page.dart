// Copyright (c) 2025 Aman Tiwari. All rights reserved.
// Unauthorized copying or distribution of this file is prohibited.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/repair_job.dart';
import 'details_page.dart';
import 'inventory_page.dart';
import 'report_page.dart';
import '../utils/backup.dart';
import '../utils/pdf_utils.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final Box<RepairJob> box = Hive.box<RepairJob>('repairs');
  String _searchQuery = '';
  DateTime? _filterStart;
  DateTime? _filterEnd;

  List<RepairJob> get _filteredJobs {
    var jobs = box.values.toList();
    jobs.sort((a, b) => (b.key as int).compareTo(a.key as int));

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      jobs = jobs.where((job) {
        final mobile = job.mobile?.toLowerCase() ?? '';
        final name = job.customerName?.toLowerCase() ?? '';
        return mobile.contains(q) || name.contains(q);
      }).toList();
    }
    if (_filterStart != null) {
      jobs = jobs.where((job) => job.dropoffDate.isAfter(_filterStart!)).toList();
    }
    if (_filterEnd != null) {
      jobs = jobs.where((job) => job.dropoffDate.isBefore(_filterEnd!)).toList();
    }
    return jobs;
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _filterStart = null;
      _filterEnd = null;
    });
  }

  Future<void> _navigateToNewEntry() async {
    final result = await Navigator.pushNamed(context, '/new');
    if (result == true) setState(() {});
  }

  Future<void> _navigateToDetails(RepairJob job) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailsPage(job: job)),
    );
    if (result == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;
    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF7B5546),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _clearFilters,
          tooltip: 'Clear Filters',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf, color: Colors.white),
            tooltip: 'Export & Share PDF',
            onPressed: () {
              final jobs = box.values.toList();
              exportJobsToPdfAndShare(jobs);
            },
          ),

          IconButton(
            icon: Icon(Icons.cloud_upload, color: Colors.white),
            tooltip: 'Backup Data',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirm Backup'),
                  content: Text('Do you want to backup all data to external storage?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Backup')),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  final path = await exportAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Backup saved to \$path')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Backup failed: \$e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.cloud_download, color: Colors.white),
            tooltip: 'Restore Data',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirm Restore'),
                  content: Text('This will overwrite local data with backup. Continue?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Restore')),
                  ],
                ),
              );
              if (confirm == true) {
                try {
                  await importAllData(clearFirst: true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data restored from backup')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Restore failed: \$e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final controller = TextEditingController(text: _searchQuery);
              final result = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Search by Name or Mobile'),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Enter name or mobile'),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, null), child: Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Search')),
                  ],
                ),
              );
              if (result != null) setState(() => _searchQuery = result);
            },
          ),
          IconButton(
            icon: Icon(Icons.receipt_long, color: Colors.white),
            tooltip: 'Manage Agents / Inventory',
            onPressed: () => Navigator.pushNamed(context, '/inventory'),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _navigateToNewEntry,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF7B5546),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              'XYZ Electronics',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Poppins', letterSpacing: 1.8, shadows: [ Shadow( blurRadius: 2.0,color: Colors.black26, offset: Offset(2, 2))]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<RepairJob> _, __) {
                if (jobs.isEmpty) return Center(child: Text('No entries found.', style: TextStyle(color: Colors.grey[400])));
                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    final color = job.isPaid ? Colors.green[400] : Color(0xFFEFD2AA);
                    return Container(
                    height: 100,
                      child:  Card(
                      color: color,
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.asset(
                            'lib/assets/customer_icon.jpg',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              job.customerName?.isNotEmpty == true ? job.customerName! : 'Unknown Customer',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              job.mobile ?? '',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'Drop-off: ${job.dropoffDate.toLocal().toString().split(' ')[0]}    ₹${job.totalCharge ?? 0}',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        trailing: Checkbox(
                          value: job.isPaid,
                          activeColor: Colors.tealAccent,
                          onChanged: (val) {
                            setState(() {
                              job.isPaid = val!;
                              job.save();
                            });
                          },
                        ),
                        onTap: () => _navigateToDetails(job),
                      ),
                    ));
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            color: Colors.grey[900],
            child: Text(
              '© All rights reserved by developer Aman Tiwari IITP. Do not alter.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.bar_chart),
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportPage()),
        ),
      ),
    );
  }
}
