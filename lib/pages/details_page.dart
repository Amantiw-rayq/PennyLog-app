

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import '../models/repair_job.dart';

class DetailsPage extends StatefulWidget {
  final RepairJob job;
  const DetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late RepairJob job;

  @override
  void initState() {
    super.initState();
    job = widget.job;
  }

  void _copyBill() {
    final msg = '''
*Pragati Electronics*
Thanks For Choosing Our Services

*Customer Name:* ${job.customerName ?? 'N/A'}
*Mobile:* ${job.mobile ?? 'N/A'}
*TV Model:* ${job.tvModel ?? 'N/A'}
*Issue:* ${job.tvIssue ?? 'N/A'}
*Drop-off:* ${job.dropoffDate.toLocal().toString().split(' ')[0]}
*Total Charge:* ₹${(job.totalCharge ?? 0).toStringAsFixed(2)}
*Status:* ${job.isPaid ? 'Paid' : 'Pending'}
''';
    Clipboard.setData(ClipboardData(text: msg));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bill copied to clipboard!')),
    );
  }

  Future<void> _navigateToEdit() async {
    final res = await Navigator.pushNamed(
      context, '/edit',
      arguments: job,
    );
    if (res == true) {
      setState(() {
        job = Hive.box<RepairJob>('repairs').get(job.key)!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    final value = TextStyle(fontSize: 18);

    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
        title: Text('Repair Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: _navigateToEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: () async {
            await job.delete();
            await Hive.box<RepairJob>('repairs').compact();
            Navigator.pop(context, true);
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Name:', style: label),
              Text(job.customerName ?? 'N/A', style: value),
              SizedBox(height: 8),
              Text('Mobile:', style: label),
              Text(job.mobile ?? 'N/A', style: value),
              SizedBox(height: 8),
              Text('TV Model:', style: label),
              Text(job.tvModel ?? 'N/A', style: value),
              SizedBox(height: 8),
              Text('Issue:', style: label),
              Text(job.tvIssue ?? 'N/A', style: value),
              SizedBox(height: 8),
              Text('Drop-off Date:', style: label),
              Text(job.dropoffDate.toLocal().toString().split(' ')[0], style: value),
              SizedBox(height: 8),
              Text('Total Charge:', style: label),
              Text('₹${(job.totalCharge ?? 0).toStringAsFixed(2)}', style: value),
              Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B5546),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _copyBill,
                  child: Text('Copy Bill'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
