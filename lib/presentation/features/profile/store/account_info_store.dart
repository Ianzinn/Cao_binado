// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'package:mobx/mobx.dart';
import '../../../../core/services/cep_service.dart';
import '../../../../domain/models/user_model.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../auth/store/auth_store.dart';

part 'account_info_store.g.dart';

class AccountInfoStore = _AccountInfoStore with _$AccountInfoStore;

abstract class _AccountInfoStore with Store {
  _AccountInfoStore(
      this._authStore, this._userRepository, this._cepService);

  final AuthStore _authStore;
  final UserRepository _userRepository;
  final CepService _cepService;

  @observable
  String nome = '';

  @observable
  String cpf = '';

  @observable
  String telefone = '';

  @observable
  String email = '';

  @observable
  String cep = '';

  @observable
  String uf = '';

  @observable
  String cidade = '';

  @observable
  String bairro = '';

  @observable
  String endereco = '';

  @observable
  String numero = '';

  @observable
  String complemento = '';

  @observable
  String observacoes = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool isCepLoading = false;

  @observable
  String? cepError;

  @action
  void initialize() {
    final profile = _authStore.userProfile;
    if (profile == null) return;
    nome = profile.nome;
    email = profile.email;
    cpf = profile.cpf ?? '';
    telefone = profile.telefone ?? '';
    cep = profile.cep ?? '';
    uf = profile.uf ?? '';
    cidade = profile.cidade ?? '';
    bairro = profile.bairro ?? '';
    endereco = profile.endereco ?? '';
    numero = profile.numero ?? '';
    complemento = profile.complemento ?? '';
    observacoes = profile.observacoes ?? '';
  }

  @action
  void setNome(String v) => nome = v;
  @action
  void setCpf(String v) => cpf = v;
  @action
  void setTelefone(String v) => telefone = v;
  @action
  void setCep(String v) {
    cep = v;
    cepError = null;
  }

  @action
  void setUf(String v) => uf = v;
  @action
  void setCidade(String v) => cidade = v;
  @action
  void setBairro(String v) => bairro = v;
  @action
  void setEndereco(String v) => endereco = v;
  @action
  void setNumero(String v) => numero = v;
  @action
  void setComplemento(String v) => complemento = v;
  @action
  void setObservacoes(String v) => observacoes = v;

  @action
  Future<void> searchAddressByCep(String rawCep) async {
    final digits = rawCep.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return;

    isCepLoading = true;
    cepError = null;
    try {
      final result = await _cepService.lookup(digits);
      if (result == null) {
        cepError = 'CEP não encontrado.';
        return;
      }
      if (result.logradouro.isNotEmpty) endereco = result.logradouro;
      if (result.bairro.isNotEmpty) bairro = result.bairro;
      if (result.localidade.isNotEmpty) cidade = result.localidade;
      if (result.uf.isNotEmpty) uf = result.uf;
    } on SocketException {
      cepError = 'Não foi possível buscar endereço.';
    } on TimeoutException {
      cepError = 'Não foi possível buscar endereço.';
    } catch (_) {
      cepError = 'Não foi possível buscar endereço.';
    } finally {
      isCepLoading = false;
    }
  }

  @action
  Future<bool> save() async {
    final profile = _authStore.userProfile;
    if (profile == null) return false;

    if (nome.trim().isEmpty) {
      errorMessage = 'O nome não pode estar vazio.';
      return false;
    }

    isLoading = true;
    errorMessage = null;
    try {
      final updated = UserModel(
        uid: profile.uid,
        nome: nome.trim(),
        email: profile.email,
        tipoUsuario: profile.tipoUsuario,
        fotoPerfilUrl: profile.fotoPerfilUrl,
        criadoEm: profile.criadoEm,
        favoritePetIds: profile.favoritePetIds,
        telefone: telefone.trim().isEmpty ? null : telefone.trim(),
        cpf: cpf.trim().isEmpty ? null : cpf.trim(),
        cep: cep.trim().isEmpty ? null : cep.trim(),
        uf: uf.trim().isEmpty ? null : uf.trim(),
        cidade: cidade.trim().isEmpty ? null : cidade.trim(),
        bairro: bairro.trim().isEmpty ? null : bairro.trim(),
        endereco: endereco.trim().isEmpty ? null : endereco.trim(),
        numero: numero.trim().isEmpty ? null : numero.trim(),
        complemento: complemento.trim().isEmpty ? null : complemento.trim(),
        observacoes: observacoes.trim().isEmpty ? null : observacoes.trim(),
      );
      await _userRepository.updateUser(updated);
      await _authStore.refreshProfile();
      return true;
    } catch (_) {
      errorMessage = 'Erro ao salvar. Tente novamente.';
      return false;
    } finally {
      isLoading = false;
    }
  }
}
