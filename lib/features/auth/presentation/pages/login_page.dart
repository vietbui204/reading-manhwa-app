import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_event.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // [1] Back button
                  _buildBackButton(),
                  const SizedBox(height: 40),
                  
                  // [2] Title & Subtitle
                  Text("Chào mừng\ntrở lại", style: GoogleFonts.bebasNeue(fontSize: 30, color: AppColors.darkText)),
                  const SizedBox(height: 8),
                  const Text("Đăng nhập để tiếp tục đọc truyện", style: TextStyle(fontSize: 13, color: AppColors.darkText2)),
                  const SizedBox(height: 40),
                  
                  // [3] Form
                  _buildLabel("EMAIL"),
                  _buildTextField(
                    controller: _emailController,
                    hintText: "Nhập email của bạn",
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? "Email không hợp lệ" : null,
                  ),
                  const SizedBox(height: 24),
                  
                  _buildLabel("MẬT KHẨU"),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: "Nhập mật khẩu",
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.darkText3, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? "Mật khẩu tối thiểu 6 ký tự" : null,
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Quên mật khẩu?", style: TextStyle(color: AppColors.red, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // [4] Login Button
                  _buildLoginButton(),
                  const SizedBox(height: 30),
                  
                  // [5] Divider
                  _buildDivider(),
                  const SizedBox(height: 30),
                  
                  // [6] Google Login
                  _buildGoogleButton(),
                  const SizedBox(height: 40),
                  
                  // [7] Footer
                  Center(
                    child: InkWell(
                      onTap: () => context.push('/register'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: AppColors.darkText2),
                          children: [
                            TextSpan(text: "Chưa có tài khoản? "),
                            TextSpan(text: "Đăng ký ngay", style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => context.go('/splash'),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: AppColors.darkBg3, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.chevron_left, color: AppColors.darkText, size: 20),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText2)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.darkText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.darkText3, fontSize: 14),
        fillColor: AppColors.darkBg3,
        filled: true,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.red)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is AuthLoading ? null : () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthBloc>().add(AuthLoginRequested(
                email: _emailController.text,
                password: _passwordController.text,
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: state is AuthLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Đăng nhập", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.darkBorder.withOpacity(0.1))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("hoặc", style: TextStyle(color: AppColors.darkText3, fontSize: 12)),
        ),
        Expanded(child: Divider(color: AppColors.darkBorder.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: () {}, // Implement Google Sign In logic here
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(color: AppColors.darkBorder.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.darkBg3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg', width: 24, height: 24, 
            errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.white, size: 24)),
          const SizedBox(width: 12),
          const Text("Tiếp tục với Google", style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
