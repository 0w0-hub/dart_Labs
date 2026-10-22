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
      title: 'Lab 7.1 - Basic Registration Form',
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

/// Màn hình đăng ký tài khoản (Lab 7.1: Form + TextFormField + Submit)
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // GlobalKey<FormState> quản lý trạng thái của Form và thực hiện validate, save, reset
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Lưu trữ dữ liệu người dùng nhập
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Trạng thái hiển thị mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  /// Xử lý sự kiện khi nhấn nút Submit
  void _submitForm() {
    // 1. Gọi validate() để kích hoạt validator của tất cả TextFormField trong Form
    final isValid = _formKey.currentState!.validate();

    // 2. Nếu Form không hợp lệ, không thực hiện tiếp
    if (!isValid) {
      return;
    }

    // 3. Nếu hợp lệ, gọi save() để lưu giá trị từ form fields
    _formKey.currentState!.save();

    // In thông tin form ra console (phục vụ debug / kiểm tra)
    debugPrint('=== Form Submitted Successfully ===');
    debugPrint('Full Name: $_fullName');
    debugPrint('Email: $_email');
    debugPrint('Password: ${'*' * _password.length}');
    debugPrint('Confirm Password matches: ${_password == _confirmPassword}');

    // 4. Hiển thị SnackBar thông báo đăng ký thành công
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

  /// Reset toàn bộ dữ liệu trong form
  void _resetForm() {
    _formKey.currentState?.reset();
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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            // Giới hạn chiều rộng tối đa để giao diện đẹp cả trên Tablet và Web
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              // Dùng Form với key _formKey để quản lý các trường nhập liệu
              child: Form(
                key: _formKey,
                // Dùng ListView để tránh lỗi tràn màn hình (overflow) khi bàn phím mở lên
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    // Tiêu đề đầu trang
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

                    // 1. Trường nhập Full Name
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _fullName = value?.trim() ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Trường nhập Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'name@example.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        // Kiểm tra định dạng cơ bản: chứa '@' và '.'
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value?.trim() ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Trường nhập Password
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value ?? '';
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4. Trường nhập Confirm Password
                    TextFormField(
                      obscureText: _obscureConfirmPassword,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmPassword = value ?? '';
                      },
                    ),
                    const SizedBox(height: 28),

                    // 5. Nút Submit
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
    );
  }
}
