import 'package:flutter/material.dart';
import '../models/incident.dart';

class IncidentTile extends StatelessWidget {
  final Incident incident;
  const IncidentTile({Key? key, required this.incident}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(incident.title),
      subtitle: Text(incident.description),
      trailing: Text('${incident.timestamp.hour}:${incident.timestamp.minute.toString().padLeft(2, '0')}'),
    );
  }
}
