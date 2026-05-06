import 'package:hive/hive.dart';

class User {
  final String username;
  final String password;
  final String role;

  User({
    required this.username,
    required this.password,
    this.role = 'user',
  });
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final username = reader.readString();
    final password = reader.readString();
    final role = reader.readString();
    return User(username: username, password: password, role: role);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.username);
    writer.writeString(obj.password);
    writer.writeString(obj.role);
  }
}