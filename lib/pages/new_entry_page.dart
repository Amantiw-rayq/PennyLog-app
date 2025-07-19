// lib/pages/new_entry_page.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/repair_job.dart';

class NewEntryPage extends StatefulWidget {
  final RepairJob? editJob;
  NewEntryPage({Key? key, this.editJob}) : super(key: key);

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _mobileCtrl, _modelCtrl, _issueCtrl;
  DateTime _dropoffDate = DateTime.now();
  double _totalCharge = 0;

  @override
  void initState() {
    super.initState();
    final e = widget.editJob;
    _nameCtrl  = TextEditingController(text: e?.customerName);
    _mobileCtrl= TextEditingController(text: e?.mobile);
    _modelCtrl = TextEditingController(text: e?.tvModel);
    _issueCtrl = TextEditingController(text: e?.tvIssue);
    if (e != null) {
      _dropoffDate  = e.dropoffDate;
      _totalCharge  = e.totalCharge ?? 0;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _modelCtrl.dispose();
    _issueCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDropoffDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dropoffDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dropoffDate = picked);
  }

  void _saveEntry() async {
    final box = Hive.box<RepairJob>('repairs');
    if (widget.editJob == null) {
      // CREATE
      await box.add(RepairJob(
        customerName: _nameCtrl.text.isEmpty ? null : _nameCtrl.text,
        mobile:      _mobileCtrl.text.isEmpty ? null : _mobileCtrl.text,
        tvModel:     _modelCtrl.text.isEmpty ? null : _modelCtrl.text,
        tvIssue:     _issueCtrl.text.isEmpty ? null : _issueCtrl.text,
        dropoffDate: _dropoffDate,
        totalCharge: _totalCharge,
      ));
    } else {
      // UPDATE
      final job = widget.editJob!..customerName = _nameCtrl.text.isEmpty ? null : _nameCtrl.text
        ..mobile      = _mobileCtrl.text.isEmpty ? null : _mobileCtrl.text
        ..tvModel     = _modelCtrl.text.isEmpty ? null : _modelCtrl.text
        ..tvIssue     = _issueCtrl.text.isEmpty ? null : _issueCtrl.text
        ..dropoffDate = _dropoffDate
        ..totalCharge = _totalCharge;
      await job.save();
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editJob != null;
    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
        title: Text(isEdit ? 'Edit Repair' : 'New Repair',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'Customer Name (Optional)'),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _mobileCtrl,
              decoration: InputDecoration(labelText: 'Mobile (Optional)'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _modelCtrl,
              decoration: InputDecoration(labelText: 'TV Model (Optional)'),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _issueCtrl,
              decoration: InputDecoration(labelText: 'Issue (Optional)'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Drop-off Date: ${_dropoffDate.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDropoffDate,
            ),
            SizedBox(height: 12),
            TextFormField(
              initialValue: _totalCharge == 0 ? '' : _totalCharge.toString(),
              decoration: InputDecoration(labelText: 'Total Charge (Optional)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => _totalCharge = double.tryParse(v) ?? 0),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7B5546),
                  foregroundColor: Colors.white),
              onPressed: _saveEntry,
              child: Text(isEdit ? 'Update' : 'Save'),
            ),
          ]),
        ),
      ),
    );
  }
}
