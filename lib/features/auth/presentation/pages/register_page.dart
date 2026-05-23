import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_event.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _agreeTerms = false;
  String _passwordStrength = "Yếu";
  Color _strengthColor = AppColors.red;
  double _strengthWidthFactor = 0.33;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 6) {
        _passwordStrength = "Yếu";
        _strengthColor = AppColors.red;
        _strengthWidthFactor = 0.33;
      } else if (password.length < 9) {
        _passwordStrength = "Trung bình";
        _strengthColor = Colors.orange;
        _strengthWidthFactor = 0.66;
      } else {
        _passwordStrength = "Mạnh";
        _strengthColor = Colors.green;
        _strengthWidthFactor = 1.0;
      }
    });
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
                  _buildBackButton(),
                  const SizedBox(height: 30),
                  
                  Text("Tạo tài khoản\nmới", style: GoogleFonts.bebasNeue(fontSize: 30, color: AppColors.darkText)),
                  const SizedBox(height: 8),
                  const Text("Tham gia cộng đồng MangaX", style: TextStyle(fontSize: 13, color: AppColors.darkText2)),
                  const SizedBox(height: 30),

                  // [3] Avatar Picker Row
                  _buildAvatarPicker(),
                  const SizedBox(height: 30),

                  // [4] Form Fields
                  _buildLabel("TÊN HIỂN THỊ"),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: "ví dụ: mangalover_99",
                    validator: (v) => (v == null || v.length < 3) ? "Tên hiển thị quá ngắn" : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("EMAIL"),
                  _buildTextField(
                    controller: _emailController,
                    hintText: "Nhập email của bạn",
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? "Email không hợp lệ" : null,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("MẬT KHẨU"),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: "Tối thiểu 6 ký tự",
                    obscureText: _obscurePassword,
                    onChanged: _checkPasswordStrength,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.darkText3, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? "Mật khẩu quá ngắn" : null,
                  ),
                  _buildPasswordStrengthBar(),
                  const SizedBox(height: 20),

                  _buildLabel("XÁC NHẬN MẬT KHẨU"),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: "Nhập lại mật khẩu",
                    obscureText: true,
                    validator: (v) => v != _passwordController.text ? "Mật khẩu không khớp" : null,
                  ),
                  const SizedBox(height: 24),

                  // [5] Terms Checkbox
                  _buildTermsCheckbox(),
                  const SizedBox(height: 30),

                  // [6] Register Button
                  _buildRegisterButton(),
                  const SizedBox(height: 30),

                  // [7] Footer
                  Center(
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: AppColors.darkText2),
                          children: [
                            TextSpan(text: "Đã có tài khoản? "),
                            TextSpan(text: "Đăng nhập", style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
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
      onTap: () => context.pop(),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: AppColors.darkBg3, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.chevron_left, color: AppColors.darkText, size: 20),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkBg3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.red, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Chọn ảnh đại diện", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                Text("Tuỳ chọn, có thể thêm sau", style: TextStyle(fontSize: 11, color: AppColors.darkText3)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.darkText3),
        ],
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
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
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

  Widget _buildPasswordStrengthBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(height: 4, width: double.infinity, decoration: BoxDecoration(color: AppColors.darkBg2, borderRadius: BorderRadius.circular(2))),
            FractionallySizedBox(
              widthFactor: _strengthWidthFactor,
              child: Container(height: 4, decoration: BoxDecoration(color: _strengthColor, borderRadius: BorderRadius.circular(2))),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Độ mạnh: $_passwordStrength", style: TextStyle(fontSize: 11, color: _strengthColor)),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            activeColor: AppColors.red,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: AppColors.darkText3),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 12, color: AppColors.darkText2),
              children: [
                TextSpan(text: "Tôi đồng ý với "),
                TextSpan(text: "Điều khoản dịch vụ", style: TextStyle(color: AppColors.red)),
                TextSpan(text: " và "),
                TextSpan(text: "Chính sách bảo mật", style: TextStyle(color: AppColors.red)),
                TextSpan(text: " của MangaX"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: (!_agreeTerms || state is AuthLoading) ? null : () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthBloc>().add(AuthRegisterRequested(
                email: _emailController.text,
                password: _passwordController.text,
                username: _usernameController.text,
              ));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            disabledBackgroundColor: AppColors.red.withOpacity(0.3),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: state is AuthLoading 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Tạo tài khoản", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
