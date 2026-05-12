import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../store/register_tutor_store.dart';

class RegisterTutorPage extends StatefulWidget {
  const RegisterTutorPage({super.key});

  @override
  State<RegisterTutorPage> createState() => _RegisterTutorPageState();
}

class _RegisterTutorPageState extends State<RegisterTutorPage> {
  late final RegisterTutorStore _store;
  final _nameCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cepCtrl = TextEditingController();
  final _ufCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _neighborhoodCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _complementCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<RegisterTutorStore>();
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _cpfCtrl, _phoneCtrl, _emailCtrl, _cepCtrl, _ufCtrl,
      _cityCtrl, _neighborhoodCtrl, _addressCtrl, _numberCtrl,
      _complementCtrl, _notesCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await _store.save();
    if (ok && mounted) context.go('/adopters');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Cadastro'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: const Icon(Icons.person, size: 48, color: AppColors.textSecondary),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _label('Nome'),
            _field(_nameCtrl, 'Sarah Joe Chamoun', onChanged: _store.setName),
            _label('CPF/CNPJ'),
            _field(_cpfCtrl, '987.654.321-00', onChanged: _store.setCpf,
                type: TextInputType.number),
            _label('Celular/Whatsapp'),
            _field(_phoneCtrl, '(31) 998766-6996', onChanged: _store.setPhone,
                type: TextInputType.phone),
            _label('E-mail'),
            _field(_emailCtrl, 'SraMiaJoeChamoun@gmail.com',
                onChanged: _store.setEmail,
                type: TextInputType.emailAddress),
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('CEP'),
                      _field(_cepCtrl, '12060-000', onChanged: _store.setCep,
                          type: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('UF'),
                      _field(_ufCtrl, 'SP', onChanged: _store.setUf),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Cidade'),
                      _field(_cityCtrl, 'Taubaté', onChanged: _store.setCity),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Bairro'),
                      _field(_neighborhoodCtrl, 'Centro',
                          onChanged: _store.setNeighborhood),
                    ],
                  ),
                ),
              ],
            ),
            _label('Endereço'),
            _field(_addressCtrl, 'Rua das Palmeiras, nº 123 Centro Taubaté',
                onChanged: _store.setAddress),
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Número'),
                      _field(_numberCtrl, '123', onChanged: _store.setNumber,
                          type: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Complemento'),
                      _field(_complementCtrl, 'Casa',
                          onChanged: _store.setComplement),
                    ],
                  ),
                ),
              ],
            ),
            _label('Observações'),
            _field(_notesCtrl, '', onChanged: _store.setNotes),
            const SizedBox(height: 28),
            Center(
              child: Observer(
                builder: (_) => GestureDetector(
                  onTap: _store.isLoading ? null : _save,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      boxShadow: AppShadows.primaryButton,
                    ),
                    alignment: Alignment.center,
                    child: _store.isLoading
                        ? const SizedBox(
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : Text('Salvar',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 4),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: AppColors.textPrimary)),
      );

  Widget _field(
    TextEditingController ctrl,
    String hint, {
    ValueChanged<String>? onChanged,
    TextInputType? type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        onChanged: onChanged,
        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
              fontSize: 13, color: AppColors.textPlaceholder),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
