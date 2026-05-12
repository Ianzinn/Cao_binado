// ignore_for_file: library_private_types_in_public_api
import 'package:mobx/mobx.dart';

part 'register_tutor_store.g.dart';

class RegisterTutorStore = _RegisterTutorStore with _$RegisterTutorStore;

abstract class _RegisterTutorStore with Store {
  @observable String name = '';
  @observable String cpf = '';
  @observable String phone = '';
  @observable String email = '';
  @observable String cep = '';
  @observable String uf = '';
  @observable String city = '';
  @observable String neighborhood = '';
  @observable String address = '';
  @observable String number = '';
  @observable String complement = '';
  @observable String notes = '';
  @observable bool isLoading = false;
  @observable String? errorMessage;

  @computed
  bool get isFormValid => name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty;

  @action void setName(String v) => name = v;
  @action void setCpf(String v) => cpf = v;
  @action void setPhone(String v) => phone = v;
  @action void setEmail(String v) => email = v;
  @action void setCep(String v) => cep = v;
  @action void setUf(String v) => uf = v;
  @action void setCity(String v) => city = v;
  @action void setNeighborhood(String v) => neighborhood = v;
  @action void setAddress(String v) => address = v;
  @action void setNumber(String v) => number = v;
  @action void setComplement(String v) => complement = v;
  @action void setNotes(String v) => notes = v;

  @action
  Future<bool> save() async {
    if (!isFormValid) return false;
    isLoading = true;
    errorMessage = null;
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (_) {
      errorMessage = 'Erro ao salvar tutor.';
      return false;
    } finally {
      isLoading = false;
    }
  }
}
