import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/incident.dart';
import '../widgets/incident_tile.dart';

class IncidentListScreen extends StatelessWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Incident>('incidents');

    return Scaffold(
      appBar: AppBar(title: const Text('Incidents')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Incident> b, _) {
          final items = b.values.toList().reversed.toList();
          if (items.isEmpty) {
            return const Center(child: Text('No incidents yet'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => IncidentTile(incident: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final incident = Incident(id: id, title: 'Test Incident', description: 'Auto-created incident');
          box.add(incident);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
