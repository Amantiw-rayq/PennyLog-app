import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/repair_job.dart';
import 'models/agent.dart';
import 'models/agent_transaction.dart';

import 'pages/list_page.dart';
import 'pages/new_entry_page.dart';
import 'pages/inventory_page.dart';
import 'pages/route_builder.dart';  // for agent detail routing

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(RepairJobAdapter());
  Hive.registerAdapter(AgentAdapter());
  Hive.registerAdapter(AgentTransactionAdapter());

  // Open Hive boxes
  await Hive.openBox<RepairJob>('repairs');
  await Hive.openBox<Agent>('agents');
  await Hive.openBox<AgentTransaction>('transactions');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Repair Manager',
      navigatorKey: navigatorKey,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF7B5546),
      ),
      home: ListPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/new': (_) => NewEntryPage(),
        '/edit': (ctx) {
          final job = ModalRoute.of(ctx)!.settings.arguments as RepairJob;
          return NewEntryPage(editJob: job);
        },
        '/inventory': (_) => InventoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/agent_detail') {
          // Preserve arguments for RouteBuilder
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => RouteBuilder(),
          );
        }
        return null; // Fall back to routes
      },
    );
  }
}
