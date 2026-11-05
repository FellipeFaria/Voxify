import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Usuário não encontrado.';
          break;
        case 'wrong-password':
          _errorMessage = 'Senha incorreta.';
          break;
        case 'invalid-email':
          _errorMessage = 'E-mail com formato inválido.';
          break;
        case 'invalid-credential':
          _errorMessage = 'E-mail ou senha incorretos.';
          break;
        case 'user-disabled':
          _errorMessage = 'Este usuário foi desativado.';
          break;
        default:
          _errorMessage = 'Erro ao fazer login: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> singUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'Este e-mail já está cadastrado.';
          break;
        case 'invalid-email':
          _errorMessage = 'E-mail com formato inválido.';
          break;
        case 'weak-password':
          _errorMessage = 'A senha é muito fraca.';
          break;
        default:
          _errorMessage = 'Erro ao cadastrar: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      print("ERRO DETALHADO: $e");
      _isLoading = false;
      _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      notifyListeners();
      return false;
    }
  }
}
