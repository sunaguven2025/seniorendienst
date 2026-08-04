import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Aktif kullanıcı
  User? get currentUser => _auth.currentUser;

  /// Oturum durumunu dinlemek için
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Giriş Yap
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (_) {
      throw "Beklenmeyen bir hata oluştu.";
    }
  }

  /// Kullanıcı Oluştur
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (_) {
      throw "Beklenmeyen bir hata oluştu.";
    }
  }

  /// Şifre Sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } catch (_) {
      throw "Şifre sıfırlama sırasında hata oluştu.";
    }
  }

  /// Çıkış Yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Hata Mesajlarını Türkçeleştir
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Geçersiz e-posta adresi.";

      case 'user-disabled':
        return "Bu kullanıcı devre dışı bırakılmış.";

      case 'user-not-found':
        return "Bu e-posta adresine ait kullanıcı bulunamadı.";

      case 'wrong-password':
        return "Şifre hatalı.";

      case 'invalid-credential':
        return "E-posta veya şifre hatalı.";

      case 'email-already-in-use':
        return "Bu e-posta adresi zaten kayıtlı.";

      case 'weak-password':
        return "Şifre en az 6 karakter olmalıdır.";

      case 'too-many-requests':
        return "Çok fazla başarısız giriş denemesi yapıldı. Lütfen daha sonra tekrar deneyin.";

      case 'network-request-failed':
        return "İnternet bağlantısı bulunamadı.";

      default:
        return e.message ?? "Bilinmeyen bir hata oluştu.";
    }
  }
}
