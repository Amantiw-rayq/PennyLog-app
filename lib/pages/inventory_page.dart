// lib/pages/inventory_page.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/agent.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final Box<Agent> _agentBox = Hive.box<Agent>('agents');

  Future<void> _addAgent() async {
    final TextEditingController _nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('New Agent'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Agent Name',
            hintText: 'Enter name',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                _agentBox.add(Agent(name: name));
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _openAgentDetail(int key, Agent agent) {
    Navigator.pushNamed(
      context,
      '/agent_detail',
      arguments: {'key': key, 'agent': agent},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEDD6),
      appBar: AppBar(
        backgroundColor: Color(0xFF7B5546),
        foregroundColor: Colors.white,
        title: Text('Agents'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Agent>>(
        valueListenable: _agentBox.listenable(),
        builder: (context, box, _) {
          final entries = box.toMap().entries.toList();
          if (entries.isEmpty) {
            return Center(
              child: Text(
                'No agents added yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final key = entry.key as int;
              final agent = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(agent.name[0].toUpperCase()),
                ),
                title: Text(agent.name, style: TextStyle(fontSize: 20)),
                onTap: () => _openAgentDetail(key, agent),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAgent,
        child: Icon(Icons.person_add),
        tooltip: 'Add Agent',
        backgroundColor: Colors.white,
      ),
    );
  }
}
