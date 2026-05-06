import 'package:hive/hive.dart';

import '../models/incident.dart';
import '../utils/logger.dart';

class IncidentService {
  IncidentService._internal();
  static final IncidentService instance = IncidentService._internal();

  // Internal helpers
  Future<Box<Incident>> _openIncidentBox() async {
    // Ensure adapter registered
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(IncidentAdapter());
      }
    } catch (e) {
      // Adapter may already be registered or registration failed
      logError('Adapter registration error: $e');
    }

    if (!Hive.isBoxOpen('incidents')) {
      try {
        await Hive.openBox<Incident>('incidents');
      } catch (e) {
        logError('Failed to open incidents box: $e');
        rethrow;
      }
    }
    return Hive.box<Incident>('incidents');
  }

  Future<Box> _openSyncBox() async {
    if (!Hive.isBoxOpen('pending_sync')) {
      try {
        await Hive.openBox('pending_sync');
      } catch (e) {
        logError('Failed to open pending_sync box: $e');
        rethrow;
      }
    }
    return Hive.box('pending_sync');
  }

  // Save a new incident (uses incident.id as key)
  Future<void> saveIncident(Incident incident, {bool markPending = true}) async {
    try {
      final box = await _openIncidentBox();
      await box.put(incident.id, incident);
      if (markPending) {
        final sync = await _openSyncBox();
        await sync.put(incident.id, DateTime.now().toIso8601String());
      }
    } catch (e, st) {
      logError('saveIncident error: $e\n$st');
      rethrow;
    }
  }

  // Update existing incident by id
  Future<void> updateIncident(String id, Incident updated, {bool markPending = true}) async {
    try {
      final box = await _openIncidentBox();
      if (!box.containsKey(id)) {
        throw Exception('Incident with id $id not found');
      }
      await box.put(id, updated);
      if (markPending) {
        final sync = await _openSyncBox();
        await sync.put(id, DateTime.now().toIso8601String());
      }
    } catch (e, st) {
      logError('updateIncident error: $e\n$st');
      rethrow;
    }
  }

  // Delete incident and clear any pending sync marker
  Future<void> deleteIncident(String id) async {
    try {
      final box = await _openIncidentBox();
      await box.delete(id);
      final sync = await _openSyncBox();
      if (sync.containsKey(id)) await sync.delete(id);
    } catch (e, st) {
      logError('deleteIncident error: $e\n$st');
      rethrow;
    }
  }

  // Get all incidents
  Future<List<Incident>> getAllIncidents() async {
    try {
      final box = await _openIncidentBox();
      return box.values.toList();
    } catch (e, st) {
      logError('getAllIncidents error: $e\n$st');
      return <Incident>[];
    }
  }

  // Get incidents marked as pending sync
  Future<List<Incident>> getPendingSyncIncidents() async {
    try {      final box = await _openIncidentBox();
      final sync = await _openSyncBox();
      final ids = sync.keys.cast<String>().toList();
      final List<Incident> results = [];
      for (final id in ids) {
        final inc = box.get(id);
        if (inc != null) results.add(inc);
      }
      return results;
    } catch (e, st) {
      logError('getPendingSyncIncidents error: $e\n$st');
      return <Incident>[];
    }
  }

  // Mark or clear pending sync flag
  Future<void> markPending(String id) async {
    try {
      final sync = await _openSyncBox();
      await sync.put(id, DateTime.now().toIso8601String());
    } catch (e, st) {
      logError('markPending error: $e\n$st');
      rethrow;
    }
  }

  Future<void> clearPending(String id) async {
    try {
      final sync = await _openSyncBox();
      if (sync.containsKey(id)) await sync.delete(id);
    } catch (e, st) {
      logError('clearPending error: $e\n$st');
      rethrow;
    }
  }
  // Search incidents (case-insensitive) by id, title, or description
  Future<List<Incident>> searchIncidents(String query) async {
    try {
      if (query.trim().isEmpty) return getAllIncidents();
      final lower = query.toLowerCase();
      final all = await getAllIncidents();
      return all.where((i) {
        return i.id.toLowerCase().contains(lower) ||
            i.title.toLowerCase().contains(lower) ||
            i.description.toLowerCase().contains(lower);
      }).toList();
    } catch (e, st) {
      logError('searchIncidents error: $e\n$st');
      return <Incident>[];
    }
  }

  // Filter incidents by optional time range
  Future<List<Incident>> filterIncidents({DateTime? since, DateTime? until}) async {
    try {
      final all = await getAllIncidents();
      return all.where((i) {
        if (since != null && i.timestamp.isBefore(since)) return false;
        if (until != null && i.timestamp.isAfter(until)) return false;
        return true;
      }).toList();
    } catch (e, st) {
      logError('filterIncidents error: $e\n$st');
      return <Incident>[];
    }
  }
}
