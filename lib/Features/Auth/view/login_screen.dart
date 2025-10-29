import 'package:flutter/material.dart';
import 'package:minhalistadecompras/features/Auth/view/forgot_password_screen.dart';
import 'package:minhalistadecompras/features/Home/view/home_screen.dart';
import 'package:minhalistadecompras/Helper/validator.dart';
import 'package:provider/provider.dart';
import 'register_account_screen.dart';
import '../view_model/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();


  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showErrorLogin = false ;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  
  // Alternar visibilidade da senha
  void togglePasswordVisibility()  {
    setState(() {
   _obscurePassword = !_obscurePassword;      
    });
  }

  Future<void> _signIn(AuthViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await viewModel.signIn(emailController.text.trim(), passwordController.text.trim());
      await Future.delayed(const Duration(seconds: 1));
      if (success && mounted) {
                setState(() {
          _showErrorLogin = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _showErrorLogin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    final validatorHelper = Validator();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2ECC71),
                    Color(0xFF27AE60),
                    Color(0xFF3498DB),
                  ],
                ),
              ),
            ),

            // Conteúdo do Login
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Título
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          size: 60,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Smart Market',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gerencie suas compras com facilidade',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Card de Login
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xFF2ECC71),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2ECC71),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: validatorHelper.validarEmail,
                            ),

                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFF2ECC71),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: togglePasswordVisibility,
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color(0xFF2ECC71),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: validatorHelper.validatePassword,
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: _showErrorLogin,
                              child: Text(
                                viewModel.errorMessage ?? '',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () => _signIn(viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2ECC71),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                icon: viewModel.isLoading 
                                ?  Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0), 
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )) : null,
                                label: const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(color: Color(0xFF2ECC71)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrarAccount(),
                            ),
                          );
                        },
                        child: Text(
                          'Criar uma conta',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
