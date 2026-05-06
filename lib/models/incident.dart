import 'package:hive/hive.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class IncidentAdapter extends TypeAdapter<Incident> {
  @override
  final int typeId = 0;

  @override
  Incident read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final timestampMillis = reader.readInt();
    return Incident(
      id: id,
      title: title,
      description: description,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMillis),
    );
  }

  @override
  void write(BinaryWriter writer, Incident obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
  }
}