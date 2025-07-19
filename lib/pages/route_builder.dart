// lib/pages/route_builder.dart

import 'package:flutter/material.dart';
import 'agent_detail_page.dart';
import '../models/agent.dart';

class RouteBuilder extends StatelessWidget {
  const RouteBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pull the args map that InventoryPage passed
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int agentKey = args['key'] as int;
    final Agent agent = args['agent'] as Agent;

    return AgentDetailPage(
      agentKey: agentKey,
      agent: agent,
    );
  }
}
