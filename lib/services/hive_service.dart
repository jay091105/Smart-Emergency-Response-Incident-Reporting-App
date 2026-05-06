import 'package:hive_flutter/hive_flutter.dart';
import '../models/incident.dart';
import '../models/user.dart';
import '../utils/logger.dart';

class HiveService {
  HiveService._internal();
  static final HiveService instance = HiveService._internal();

  Future<void> init() async {
    await Hive.initFlutter();

    try {
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(IncidentAdapter());
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(UserAdapter());
    } catch (e) {
      logError('Adapter registration error: $e');
    }

    try {
      await Hive.openBox<Incident>('incidents');
      await Hive.openBox<User>('users');
      await Hive.openBox('settings');
    } catch (e) {
      logError('Failed to open Hive boxes: $e');
      rethrow;
    }
  }
}
