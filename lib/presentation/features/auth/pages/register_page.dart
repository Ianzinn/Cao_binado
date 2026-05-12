import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../store/register_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterStore _store;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<RegisterStore>();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final ok = await _store.register();
    if (ok && mounted) context.go('/home');
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
              GestureDetector(
                onTap: () => context.canPop()
                    ? context.pop()
                    : context.go('/onboarding'),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Cadastrar',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Criar conta',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // ── Avatar picker ────────────────────────────────────────────
              Center(
                child: Observer(
                  builder: (_) => GestureDetector(
                    onTap: _store.pickProfileImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            image: _store.profileImage != null
                                ? DecorationImage(
                                    image:
                                        FileImage(_store.profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _store.profileImage == null
                              ? const Icon(Icons.person,
                                  size: 52,
                                  color: AppColors.textSecondary)
                              : null,
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Campos ───────────────────────────────────────────────────
              AppTextField(
                controller: _nameCtrl,
                hint: 'Nome completo',
                icon: Icons.person_outline_rounded,
                onChanged: _store.setName,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneCtrl,
                hint: 'Telefone',
                icon: Icons.smartphone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: _store.setPhone,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailCtrl,
                hint: 'E-mail',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                onChanged: _store.setEmail,
              ),
              const SizedBox(height: 16),
              Observer(
                builder: (_) => AppTextField(
                  controller: _passwordCtrl,
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
              const SizedBox(height: 16),

              // ── Tipo de usuário ──────────────────────────────────────────
              Observer(
                builder: (_) => _TipoUsuarioSelector(
                  selected: _store.tipoUsuario,
                  onChanged: _store.setTipoUsuario,
                ),
              ),

              const SizedBox(height: 36),

              // ── Botão cadastrar ──────────────────────────────────────────
              Observer(
                builder: (_) => GestureDetector(
                  onTap: _store.isLoading ? null : _handleRegister,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppRadius.button),
                      boxShadow: AppShadows.primaryButton,
                    ),
                    alignment: Alignment.center,
                    child: _store.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Criar conta',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              Observer(builder: (_) {
                final err = _store.errorMessage;
                if (err == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(err,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.redAccent),
                      textAlign: TextAlign.center),
                );
              }),

              const SizedBox(height: 28),
              _OrDivider(),
              const SizedBox(height: 20),
              _SocialButton(
                label: 'Entrar com o Google',
                icon: const Icon(Icons.g_mobiledata_rounded,
                    size: 28, color: Color(0xFF4285F4)),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _SocialButton(
                label: 'Entrar com o Facebook',
                icon: const Icon(Icons.facebook,
                    color: Color(0xFF1877F2), size: 28),
                onTap: () {},
              ),
              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/login'),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: 'Já possui um cadastro? '),
                        TextSpan(
                          text: 'Entrar',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipoUsuarioSelector extends StatelessWidget {
  const _TipoUsuarioSelector({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Adotante',
          isSelected: selected == 'adotante',
          onTap: () => onChanged('adotante'),
        ),
        const SizedBox(width: 12),
        _Chip(
          label: 'Protetor',
          isSelected: selected == 'admin',
          onTap: () => onChanged('admin'),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
                isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(thickness: 1.5, color: AppColors.divider)),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider),
          ),
          alignment: Alignment.center,
          child: Text(
            'OU',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
            child: Divider(thickness: 1.5, color: AppColors.divider)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton(
      {required this.label, required this.icon, required this.onTap});

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.buttonSocial),
          boxShadow: AppShadows.socialButton,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 32, height: 32, child: icon),
            const SizedBox(width: 12),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF001833))),
          ],
        ),
      ),
    );
  }
}
