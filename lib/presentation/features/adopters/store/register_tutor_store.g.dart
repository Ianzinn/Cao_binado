// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_tutor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterTutorStore on _RegisterTutorStore, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid => (_$isFormValidComputed ??= Computed<bool>(
    () => super.isFormValid,
    name: '_RegisterTutorStore.isFormValid',
  )).value;

  late final _$nameAtom = Atom(
    name: '_RegisterTutorStore.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$cpfAtom = Atom(
    name: '_RegisterTutorStore.cpf',
    context: context,
  );

  @override
  String get cpf {
    _$cpfAtom.reportRead();
    return super.cpf;
  }

  @override
  set cpf(String value) {
    _$cpfAtom.reportWrite(value, super.cpf, () {
      super.cpf = value;
    });
  }

  late final _$phoneAtom = Atom(
    name: '_RegisterTutorStore.phone',
    context: context,
  );

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$emailAtom = Atom(
    name: '_RegisterTutorStore.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$cepAtom = Atom(
    name: '_RegisterTutorStore.cep',
    context: context,
  );

  @override
  String get cep {
    _$cepAtom.reportRead();
    return super.cep;
  }

  @override
  set cep(String value) {
    _$cepAtom.reportWrite(value, super.cep, () {
      super.cep = value;
    });
  }

  late final _$ufAtom = Atom(name: '_RegisterTutorStore.uf', context: context);

  @override
  String get uf {
    _$ufAtom.reportRead();
    return super.uf;
  }

  @override
  set uf(String value) {
    _$ufAtom.reportWrite(value, super.uf, () {
      super.uf = value;
    });
  }

  late final _$cityAtom = Atom(
    name: '_RegisterTutorStore.city',
    context: context,
  );

  @override
  String get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(String value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  late final _$neighborhoodAtom = Atom(
    name: '_RegisterTutorStore.neighborhood',
    context: context,
  );

  @override
  String get neighborhood {
    _$neighborhoodAtom.reportRead();
    return super.neighborhood;
  }

  @override
  set neighborhood(String value) {
    _$neighborhoodAtom.reportWrite(value, super.neighborhood, () {
      super.neighborhood = value;
    });
  }

  late final _$addressAtom = Atom(
    name: '_RegisterTutorStore.address',
    context: context,
  );

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$numberAtom = Atom(
    name: '_RegisterTutorStore.number',
    context: context,
  );

  @override
  String get number {
    _$numberAtom.reportRead();
    return super.number;
  }

  @override
  set number(String value) {
    _$numberAtom.reportWrite(value, super.number, () {
      super.number = value;
    });
  }

  late final _$complementAtom = Atom(
    name: '_RegisterTutorStore.complement',
    context: context,
  );

  @override
  String get complement {
    _$complementAtom.reportRead();
    return super.complement;
  }

  @override
  set complement(String value) {
    _$complementAtom.reportWrite(value, super.complement, () {
      super.complement = value;
    });
  }

  late final _$notesAtom = Atom(
    name: '_RegisterTutorStore.notes',
    context: context,
  );

  @override
  String get notes {
    _$notesAtom.reportRead();
    return super.notes;
  }

  @override
  set notes(String value) {
    _$notesAtom.reportWrite(value, super.notes, () {
      super.notes = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_RegisterTutorStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_RegisterTutorStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$saveAsyncAction = AsyncAction(
    '_RegisterTutorStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_RegisterTutorStoreActionController = ActionController(
    name: '_RegisterTutorStore',
    context: context,
  );

  @override
  void setName(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setName',
    );
    try {
      return super.setName(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCpf(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setCpf',
    );
    try {
      return super.setCpf(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setPhone',
    );
    try {
      return super.setPhone(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setEmail',
    );
    try {
      return super.setEmail(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCep(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setCep',
    );
    try {
      return super.setCep(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUf(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setUf',
    );
    try {
      return super.setUf(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCity(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setCity',
    );
    try {
      return super.setCity(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNeighborhood(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setNeighborhood',
    );
    try {
      return super.setNeighborhood(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddress(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setAddress',
    );
    try {
      return super.setAddress(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNumber(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setNumber',
    );
    try {
      return super.setNumber(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComplement(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setComplement',
    );
    try {
      return super.setComplement(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotes(String v) {
    final _$actionInfo = _$_RegisterTutorStoreActionController.startAction(
      name: '_RegisterTutorStore.setNotes',
    );
    try {
      return super.setNotes(v);
    } finally {
      _$_RegisterTutorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
cpf: ${cpf},
phone: ${phone},
email: ${email},
cep: ${cep},
uf: ${uf},
city: ${city},
neighborhood: ${neighborhood},
address: ${address},
number: ${number},
complement: ${complement},
notes: ${notes},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isFormValid: ${isFormValid}
    ''';
  }
}
