// lib/pages/agent_detail_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/agent.dart';
import '../models/agent_transaction.dart';

class AgentDetailPage extends StatefulWidget {
  final int agentKey;
  final Agent agent;

  const AgentDetailPage({Key? key, required this.agentKey, required this.agent}) : super(key: key);

  @override
  _AgentDetailPageState createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  late final Box<AgentTransaction> _txBox;

  @override
  void initState() {
    super.initState();
    _txBox = Hive.box<AgentTransaction>('transactions');
  }

  List<AgentTransaction> get _transactions {
    final txs = _txBox.values.where((tx) => tx.agentKey == widget.agentKey).toList();
    txs.sort((a, b) {
      final aDate = a.date ?? DateTime(2000);
      final bDate = b.date ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    return txs;
  }

  double get _totalPurchased =>
      _transactions.where((tx) => !tx.isPayment).fold(0.0, (sum, tx) => sum + tx.amount);

  double get _totalPaid =>
      _transactions.where((tx) => tx.isPayment).fold(0.0, (sum, tx) => sum + tx.amount);

  double get _balance => _totalPurchased - _totalPaid;

  Future<void> _addTransaction(bool isPayment) async {
    DateTime? selectedDate = DateTime.now();
    final descController = TextEditingController();
    final amtController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isPayment ? 'Record Payment' : 'Record Purchase'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isPayment)
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(labelText: 'Materials Description'),
                      ),
                    TextField(
                      controller: amtController,
                      decoration: InputDecoration(labelText: 'Amount (₹)'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        'Date: ${selectedDate!.toLocal().toIso8601String().split('T')[0]}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final desc = descController.text.trim();
                    final amt = double.tryParse(amtController.text) ?? 0.0;
                    if (amt > 0 && (isPayment || desc.isNotEmpty)) {
                      _txBox.add(
                        AgentTransaction(
                          agentKey: widget.agentKey,
                          description: desc,
                          amount: amt,
                          isPayment: isPayment,
                          date: selectedDate,
                        ),
                      );
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
        title: Text(widget.agent.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Purchased: ₹${_totalPurchased.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
            Text('Total Paid: ₹${_totalPaid.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 4),
            Text(
              'Balance: ₹${_balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _balance >= 0 ? Colors.redAccent : Colors.green,
              ),
            ),
            Divider(height: 32),
            Expanded(
              child: _transactions.isEmpty
                  ? Center(child: Text('No transactions yet.'))
                  : ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  final key = _txBox.keyAt(_txBox.values.toList().indexOf(tx));
                  return Dismissible(
                    key: ValueKey(key),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (_) => showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete Transaction'),
                        content: Text('Are you sure you want to delete this transaction?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Delete')),
                        ],
                      ),
                    ),
                    onDismissed: (_) {
                      tx.delete();
                      setState(() {});
                    },
                    child: ListTile(
                      leading: Icon(
                        tx.isPayment ? Icons.attach_money : Icons.shopping_cart,
                        color: tx.isPayment ? Colors.green : Colors.blueGrey,
                      ),
                      title: Text(tx.isPayment ? 'Payment' : tx.description, style: TextStyle(fontSize: 20)),
                      subtitle: Text(
                        tx.date != null
                            ? '${tx.date!.toLocal().toIso8601String().split('T')[0]}'
                            : 'No date',
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('₹${tx.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Delete Transaction'),
                                  content: Text('Delete this transaction?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                tx.delete();
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.shopping_cart),
                  label: Text('Add Purchase'),
                  onPressed: () => _addTransaction(false),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.payment),
                  label: Text('Add Payment'),
                  onPressed: () => _addTransaction(true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
