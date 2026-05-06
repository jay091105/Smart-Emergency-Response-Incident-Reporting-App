import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../constants/auth_constants.dart';

final currentUserProvider = Provider<User>((ref) {
  return User(username: AuthConstants.defaultUsername, password: AuthConstants.defaultPassword, role: 'user');
});
