import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/repair_job.dart';

Future<void> exportJobsToPdfAndShare(List<RepairJob> jobs) async {
  final doc = pw.Document();
  final tableHeaders = ['Customer', 'Mobile', 'Model', 'Issue', 'DropOff', 'Charge', 'Paid'];

  // Build a simple table of all jobs
  doc.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    build: (context) => [
      pw.Header(level: 0, child: pw.Text('Pragati Electronics  All Repairs Report', style: pw.TextStyle(fontSize: 24))),
      pw.Table.fromTextArray(
        headers: tableHeaders,
        data: jobs.map((j) {
          return [
            j.customerName ?? '—',
            j.mobile ?? '—',
            j.tvModel ?? '—',
            j.tvIssue ?? '—',
            j.dropoffDate.toLocal().toString().split(' ')[0],
            '${(j.totalCharge ?? 0).toStringAsFixed(2)}',
            j.isPaid ? 'Yes' : 'No',
          ];
        }).toList(),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        cellAlignment: pw.Alignment.centerLeft,
        cellPadding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        columnWidths: {
          0: pw.FlexColumnWidth(7),
          1: pw.FlexColumnWidth(8),
          2: pw.FlexColumnWidth(5),
          3: pw.FlexColumnWidth(8),
          4: pw.FlexColumnWidth(9),
          5: pw.FlexColumnWidth(5),
          6: pw.FlexColumnWidth(4),
        },
      ),
    ],
  ));

  // Write to a temp file
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/repairs_report.pdf');
  await file.writeAsBytes(await doc.save());

  // Launch platform share dialog
  await Printing.sharePdf(bytes: await doc.save(), filename: 'repairs_report.pdf');
}
