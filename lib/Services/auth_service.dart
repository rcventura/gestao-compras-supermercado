import 'package:firebase_auth/firebase_auth.dart';
import 'package:minhalistadecompras/Services/UserFirestore.dart';
import '../Features/Auth/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Userfirestore _firestoreService = Userfirestore();

  // Obter usuário atual
  User? get currentUser  => _auth.currentUser;

  // Stream para verificar mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // CRIAR USUÁRIO
  Future<UserCredential?> createUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Criar documento no Firestore
      if (userCredential.user != null) {
        UserModel userModel = UserModel.fromFirebaseUser(
          firebaseUser: userCredential.user!,
          name: displayName,
        );
        
        await _firestoreService.createUserDocument(userModel);
      }
      // Enviar e-mail de verificação (opcional)
     // await userCredential.user?.sendEmailVerification();
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro desconhecido ao criar usuário';
    }
  }

  // FAZER LOGIN
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro desconhecido ao fazer login';
    }
  }

  // FAZER LOGOUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Erro ao fazer logout';
    }
  }

  // ENVIAR E-MAIL DE RESET DE SENHA
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Erro ao enviar e-mail de recuperação';
    }
  }

  // REENVIAR E-MAIL DE VERIFICAÇÃO
  Future<void> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Erro ao enviar e-mail de verificação';
    }
  }

  // VERIFICAR SE O E-MAIL FOI VERIFICADO
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // RECARREGAR DADOS DO USUÁRIO
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  // TRATAMENTO DE ERROS
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'user-disabled':
        return 'Este usuário foi desabilitado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro: ${e.message}';
    }
  }
}