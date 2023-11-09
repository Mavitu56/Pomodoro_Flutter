
import 'package:pomodoro/core/models/user.dart';
import 'package:pomodoro/core/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  user? get currentUser;

  Stream<user?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
  );

  Future<void> login(
    String email,
    String password,
  );

  Future<void> logout();

  factory AuthService() {
    // return AuthMockService();
    return AuthFirebaseService();
  }
}
