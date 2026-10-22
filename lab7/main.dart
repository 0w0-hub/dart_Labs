import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Ứng dụng chính thiết lập Theme và màn hình SignupScreen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7.3 - Focus & Keyboard Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

/// Enum mức độ bảo mật của mật khẩu
enum PasswordStrength { none, weak, medium, strong }

/// Màn hình đăng ký tài khoản
/// Lab 7.3: Quản lý FocusNode, Chuyển focus bằng Next/Done, Ẩn bàn phím khi chạm ra ngoài
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey<FormState> quản lý trạng thái của Form (validate, save, reset)
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingControllers để theo dõi nội dung nhập theo thời gian thực
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Lab 7.3: FocusNode cho từng ô nhập liệu để điều khiển di chuyển focus
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // Biến lưu trữ giá trị sau khi formKey.currentState!.save()
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Trạng thái hiển thị mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi mật khẩu để cập nhật thanh đo độ mạnh (Password Strength)
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Lab 7.3: Luôn giải phóng (dispose) các FocusNode để tránh rò rỉ bộ nhớ
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  // ==========================================
  // CÁC HÀM VALIDATION RIÊNG BIỆT (LAB 7.2)
  // ==========================================

  /// Kiểm tra họ tên: Bắt buộc, tối thiểu 2 ký tự
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  /// Kiểm tra email: Bắt buộc, phải chứa '@', '.' và đúng cấu trúc email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final email = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!email.contains('@') || !email.contains('.') || !emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Kiểm tra mật khẩu: Bắt buộc, tối thiểu 8 ký tự, ít nhất 1 chữ số
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  /// Kiểm tra xác nhận mật khẩu: Bắt buộc, phải trùng khớp với trường Password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ==========================================
  // TÍNH TOÁN ĐỘ MẠNH CỦA MẬT KHẨU
  // ==========================================

  PasswordStrength _getStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 8) return PasswordStrength.weak;

    bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLower = RegExp(r'[a-z]').hasMatch(password);
    bool hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    int score = 0;
    if (hasDigit) score++;
    if (hasUpper) score++;
    if (hasLower) score++;
    if (hasSpecial) score++;
    if (password.length >= 10) score++;

    if (!hasDigit || score <= 2) {
      return PasswordStrength.weak;
    } else if (score >= 4) {
      return PasswordStrength.strong;
    } else {
      return PasswordStrength.medium;
    }
  }

  /// Widget thanh đo độ mạnh mật khẩu (Weak / Medium / Strong)
  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _getStrength(password);
    Color color;
    String label;
    double progress;

    switch (strength) {
      case PasswordStrength.weak:
        color = Colors.red;
        label = 'Weak (Needs ≥8 chars & 1 digit)';
        progress = 0.33;
        break;
      case PasswordStrength.medium:
        color = Colors.orange;
        label = 'Medium';
        progress = 0.66;
        break;
      case PasswordStrength.strong:
        color = Colors.green;
        label = 'Strong';
        progress = 1.0;
        break;
      case PasswordStrength.none:
        color = Colors.grey;
        label = '';
        progress = 0.0;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    color: color,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // XỬ LÝ SUBMIT & RESET (KẾT HỢP FOCUS)
  // ==========================================

  void _submitForm() {
    // Ẩn bàn phím khi submit form
    FocusScope.of(context).unfocus();

    // 1. Kích hoạt kiểm tra validation toàn bộ Form
    final isValid = _formKey.currentState!.validate();

    // 2. Chặn submit nếu form không hợp lệ
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form before submitting.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 3. Form hợp lệ: Lưu dữ liệu
    _formKey.currentState!.save();

    debugPrint('=== Form Submitted Successfully (Lab 7.3) ===');
    debugPrint('Full Name: $_fullName');
    debugPrint('Email: $_email');
    debugPrint('Password length: ${_password.length}');
    debugPrint('Confirm Password length: ${_confirmPassword.length}');

    // 4. Hiển thị SnackBar thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signup successful! Welcome, $_fullName'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _resetForm() {
    // Bỏ focus và ẩn bàn phím
    FocusScope.of(context).unfocus();

    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _fullName = '';
      _email = '';
      _password = '';
      _confirmPassword = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset Form',
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
          ),
        ],
      ),
      // Lab 7.3: Bọc toàn màn hình bằng GestureDetector để khi người dùng chạm
      // vào vùng trống bên ngoài, bàn phím ảo sẽ tự động ẩn đi (unfocus).
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // Dùng ListView để nội dung có thể cuộn, tránh lỗi tràn màn hình khi bàn phím xuất hiện
                  child: ListView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Please fill in the information below to register.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 1. Full Name
                      // textInputAction: next -> chuyển sang EmailFocus khi nhấn Next
                      TextFormField(
                        controller: _fullNameController,
                        focusNode: _fullNameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: _validateFullName,
                        onSaved: (value) {
                          _fullName = value?.trim() ?? '';
                        },
                      ),
                      const SizedBox(height: 16),

                      // 2. Email
                      // textInputAction: next -> chuyển sang PasswordFocus khi nhấn Next
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'name@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: _validateEmail,
                        onSaved: (value) {
                          _email = value?.trim() ?? '';
                        },
                      ),
                      const SizedBox(height: 16),

                      // 3. Password
                      // textInputAction: next -> chuyển sang ConfirmPasswordFocus khi nhấn Next
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'At least 8 characters with numbers',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: _validatePassword,
                        onSaved: (value) {
                          _password = value ?? '';
                        },
                      ),
                      // Thanh hiển thị độ mạnh mật khẩu theo thời gian thực
                      _buildPasswordStrengthIndicator(),
                      const SizedBox(height: 16),

                      // 4. Confirm Password
                      // textInputAction: done -> gọi submit khi nhấn Done trên bàn phím
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _submitForm();
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: _validateConfirmPassword,
                        onSaved: (value) {
                          _confirmPassword = value ?? '';
                        },
                      ),
                      const SizedBox(height: 28),

                      // 5. Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
