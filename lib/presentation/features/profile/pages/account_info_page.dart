import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../store/account_info_store.dart';
import '../../auth/store/auth_store.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late final AccountInfoStore _store;
  final List<ReactionDisposer> _disposers = [];

  final _nomeCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _cepCtrl = TextEditingController();
  final _ufCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _bairroCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();
  final _numeroCtrl = TextEditingController();
  final _complementoCtrl = TextEditingController();
  final _observacoesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = getIt<AccountInfoStore>();
    _store.initialize();

    _nomeCtrl.text = _store.nome;
    _cpfCtrl.text = _store.cpf;
    _telefoneCtrl.text = _store.telefone;
    _cepCtrl.text = _store.cep;
    _ufCtrl.text = _store.uf;
    _cidadeCtrl.text = _store.cidade;
    _bairroCtrl.text = _store.bairro;
    _enderecoCtrl.text = _store.endereco;
    _numeroCtrl.text = _store.numero;
    _complementoCtrl.text = _store.complemento;
    _observacoesCtrl.text = _store.observacoes;

    // Sync controllers when CEP auto-fill updates the store values
    _disposers.addAll([
      reaction((_) => _store.endereco, (v) {
        if (_enderecoCtrl.text != v) _enderecoCtrl.text = v;
      }),
      reaction((_) => _store.bairro, (v) {
        if (_bairroCtrl.text != v) _bairroCtrl.text = v;
      }),
      reaction((_) => _store.cidade, (v) {
        if (_cidadeCtrl.text != v) _cidadeCtrl.text = v;
      }),
      reaction((_) => _store.uf, (v) {
        if (_ufCtrl.text != v) _ufCtrl.text = v;
      }),
    ]);
  }

  @override
  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _nomeCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _cepCtrl.dispose();
    _ufCtrl.dispose();
    _cidadeCtrl.dispose();
    _bairroCtrl.dispose();
    _enderecoCtrl.dispose();
    _numeroCtrl.dispose();
    _complementoCtrl.dispose();
    _observacoesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await _store.save();
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações salvas com sucesso.')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppDarkTopBar(title: 'Cadastro'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar + Nome ──────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Observer(builder: (_) {
                  final url = getIt<AuthStore>().userProfile?.fotoPerfilUrl;
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      image: (url != null && url.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (url == null || url.isEmpty)
                        ? const Icon(Icons.person,
                            size: 40, color: AppColors.textSecondary)
                        : null,
                  );
                }),
                const SizedBox(width: 16),
                Expanded(
                  child: AppLabeledField(
                    label: 'Nome',
                    controller: _nomeCtrl,
                    hint: 'Seu nome completo',
                    onChanged: _store.setNome,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── CPF / CNPJ ─────────────────────────────────────────────────
            AppLabeledField(
              label: 'CPF/CNPJ',
              controller: _cpfCtrl,
              hint: '000.000.000-00',
              keyboardType: TextInputType.number,
              onChanged: _store.setCpf,
            ),
            const SizedBox(height: 14),

            // ── Celular ────────────────────────────────────────────────────
            AppLabeledField(
              label: 'Celular/Whatsapp',
              controller: _telefoneCtrl,
              hint: '(00) 00000-0000',
              keyboardType: TextInputType.phone,
              onChanged: _store.setTelefone,
            ),
            const SizedBox(height: 14),

            // ── E-mail (read-only) ─────────────────────────────────────────
            _ReadOnlyField(label: 'E-mail', value: _store.email),
            const SizedBox(height: 14),

            // ── CEP + UF ───────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppLabeledField(
                    label: 'CEP',
                    controller: _cepCtrl,
                    hint: '00000-000',
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      _store.setCep(v);
                      final digits = v.replaceAll(RegExp(r'\D'), '');
                      if (digits.length == 8) {
                        _store.searchAddressByCep(digits);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: Observer(
                    builder: (_) => AppLabeledField(
                      label: 'UF',
                      controller: _ufCtrl,
                      hint: 'SP',
                      onChanged: _store.setUf,
                    ),
                  ),
                ),
              ],
            ),

            // ── CEP feedback (loading / error) ─────────────────────────────
            Observer(
              builder: (_) {
                if (_store.isCepLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Buscando endereço...',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                if (_store.cepError != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _store.cepError!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.statusCancelled,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 14),

            // ── Cidade + Bairro ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AppLabeledField(
                    label: 'Cidade',
                    controller: _cidadeCtrl,
                    hint: 'Sua cidade',
                    onChanged: _store.setCidade,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppLabeledField(
                    label: 'Bairro',
                    controller: _bairroCtrl,
                    hint: 'Seu bairro',
                    onChanged: _store.setBairro,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Endereço ───────────────────────────────────────────────────
            AppLabeledField(
              label: 'Endereço',
              controller: _enderecoCtrl,
              hint: 'Rua, avenida...',
              onChanged: _store.setEndereco,
            ),
            const SizedBox(height: 14),

            // ── Número + Complemento ───────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AppLabeledField(
                    label: 'Número',
                    controller: _numeroCtrl,
                    hint: '000',
                    keyboardType: TextInputType.number,
                    onChanged: _store.setNumero,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppLabeledField(
                    label: 'Complemento',
                    controller: _complementoCtrl,
                    hint: 'Apto, casa...',
                    onChanged: _store.setComplemento,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Observações ────────────────────────────────────────────────
            AppLabeledField(
              label: 'Observações',
              controller: _observacoesCtrl,
              hint: 'Informações adicionais',
              onChanged: _store.setObservacoes,
              maxLines: 3,
            ),

            // ── Save error ─────────────────────────────────────────────────
            Observer(
              builder: (_) => _store.errorMessage != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _store.errorMessage!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.statusCancelled,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 28),

            // ── Save button ────────────────────────────────────────────────
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
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'Salvar',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            value.isEmpty ? '—' : value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
