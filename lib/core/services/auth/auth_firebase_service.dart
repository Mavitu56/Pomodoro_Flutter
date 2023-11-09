import 'dart:io';
import 'dart:async';
import 'package:pomodoro/core/models/user.dart';
import 'package:pomodoro/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static user? _currentUser;
  static final _userStream = Stream<user?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _touser(user);
      controller.add(_currentUser);
    }
  });

  @override
  user? get currentUser {
    return _currentUser;
  }

  @override
  Stream<user?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
      String name, String email, String password,) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {

      // 2. atualizar os atributos do usuário
      await credential.user?.updateDisplayName(name);

      // 3. salvar usuário no banco de dados (opcional)
      await _saveChatUser(_touser(credential.user!));
    }
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(user user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
    });
  }

  static user _touser(User user1) {
    return user(
      id: user1.uid,
      name: user1.displayName ?? user1.email!.split('@')[0],
      email: user1.email!,
    );
  }
}
