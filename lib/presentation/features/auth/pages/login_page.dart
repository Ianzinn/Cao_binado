import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../store/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginStore _store;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _autoTriggered = false;
  bool _isBiometricRunning = false;

  @override
  void initState() {
    super.initState();
    _store = getIt<LoginStore>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoBiometric());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _maybeAutoBiometric() async {
    if (_autoTriggered) return;
    _autoTriggered = true;
    final biometric = getIt<BiometricService>();
    final enabled = await biometric.isEnabled();
    debugPrint('🔐 LoginPage auto-trigger: biometric.isEnabled=$enabled');
    if (!enabled) return;
    await _runBiometric();
  }

  Future<void> _runBiometric() async {
    if (_isBiometricRunning) return;
    setState(() => _isBiometricRunning = true);
    try {
      final success = await _store.loginWithBiometric();
      if (success && mounted) context.go('/home');
    } finally {
      if (mounted) setState(() => _isBiometricRunning = false);
    }
  }

  Future<void> _handleLogin() async {
    final success = await _store.login();
    if (success && mounted) context.go('/home');
  }

  Future<void> _handleForgotPassword() async {
    final email = await showDialog<String>(
      context: context,
      builder: (_) => _ForgotPasswordDialog(initialEmail: _emailController.text),
    );
    if (email == null || email.isEmpty) return;

    final success = await _store.sendPasswordReset(email);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('E-mail de recuperação enviado para $email.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(_store.errorMessage ?? 'Não foi possível enviar o e-mail.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 43),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _BackButton(),
              const SizedBox(height: 72),
              Text(
                'Entrar',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Bem-vindo',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 42),
              _IconTextField(
                controller: _emailController,
                hint: 'E-mail',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                onChanged: _store.setEmail,
              ),
              const SizedBox(height: 28),
              Observer(
                builder: (_) => _IconTextField(
                  controller: _passwordController,
                  hint: 'Senha',
                  icon: Icons.lock_outline_rounded,
                  obscureText: !_store.isPasswordVisible,
                  onChanged: _store.setPassword,
                  suffix: GestureDetector(
                    onTap: _store.togglePasswordVisibility,
                    child: Icon(
                      _store.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textPlaceholder,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _handleForgotPassword,
                  child: Text(
                    'Esqueceu sua senha?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.accent,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Observer(builder: (_) => _PrimaryButton(
                label: 'Entrar',
                isLoading: _store.isLoading,
                onTap: _handleLogin,
              )),
              Observer(builder: (_) {
                if (_store.errorMessage == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _store.errorMessage!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.redAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/register'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                      children: [
                        const TextSpan(text: 'Novo usuário? '),
                        TextSpan(
                          text: 'Cadastre-se',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.canPop() ? context.pop() : context.go('/'),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }
}

class _IconTextField extends StatelessWidget {
  const _IconTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textPlaceholder, size: 22),
        const SizedBox(width: 4),
        Container(width: 1, height: 26, color: AppColors.divider),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      obscureText: obscureText,
                      keyboardType: keyboardType,
                      onChanged: onChanged,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPlaceholder,
                          letterSpacing: -0.2,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (suffix != null) suffix!,
                ],
              ),
              const SizedBox(height: 4),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: AppShadows.primaryButton,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        'Recuperar senha',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informe seu e-mail. Enviaremos um link para redefinir sua senha.',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'E-mail',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
