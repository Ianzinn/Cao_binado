// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterStore on _RegisterStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??= Computed<bool>(
    () => super.isLoading,
    name: '_RegisterStore.isLoading',
  )).value;
  Computed<String?>? _$errorMessageComputed;

  @override
  String? get errorMessage => (_$errorMessageComputed ??= Computed<String?>(
    () => super.errorMessage,
    name: '_RegisterStore.errorMessage',
  )).value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid => (_$isFormValidComputed ??= Computed<bool>(
    () => super.isFormValid,
    name: '_RegisterStore.isFormValid',
  )).value;

  late final _$nameAtom = Atom(name: '_RegisterStore.name', context: context);

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

  late final _$phoneAtom = Atom(name: '_RegisterStore.phone', context: context);

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

  late final _$emailAtom = Atom(name: '_RegisterStore.email', context: context);

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

  late final _$passwordAtom = Atom(
    name: '_RegisterStore.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$tipoUsuarioAtom = Atom(
    name: '_RegisterStore.tipoUsuario',
    context: context,
  );

  @override
  String get tipoUsuario {
    _$tipoUsuarioAtom.reportRead();
    return super.tipoUsuario;
  }

  @override
  set tipoUsuario(String value) {
    _$tipoUsuarioAtom.reportWrite(value, super.tipoUsuario, () {
      super.tipoUsuario = value;
    });
  }

  late final _$isPasswordVisibleAtom = Atom(
    name: '_RegisterStore.isPasswordVisible',
    context: context,
  );

  @override
  bool get isPasswordVisible {
    _$isPasswordVisibleAtom.reportRead();
    return super.isPasswordVisible;
  }

  @override
  set isPasswordVisible(bool value) {
    _$isPasswordVisibleAtom.reportWrite(value, super.isPasswordVisible, () {
      super.isPasswordVisible = value;
    });
  }

  late final _$profileImageAtom = Atom(
    name: '_RegisterStore.profileImage',
    context: context,
  );

  @override
  File? get profileImage {
    _$profileImageAtom.reportRead();
    return super.profileImage;
  }

  @override
  set profileImage(File? value) {
    _$profileImageAtom.reportWrite(value, super.profileImage, () {
      super.profileImage = value;
    });
  }

  late final _$isUploadingPhotoAtom = Atom(
    name: '_RegisterStore.isUploadingPhoto',
    context: context,
  );

  @override
  bool get isUploadingPhoto {
    _$isUploadingPhotoAtom.reportRead();
    return super.isUploadingPhoto;
  }

  @override
  set isUploadingPhoto(bool value) {
    _$isUploadingPhotoAtom.reportWrite(value, super.isUploadingPhoto, () {
      super.isUploadingPhoto = value;
    });
  }

  late final _$pickProfileImageAsyncAction = AsyncAction(
    '_RegisterStore.pickProfileImage',
    context: context,
  );

  @override
  Future<void> pickProfileImage() {
    return _$pickProfileImageAsyncAction.run(() => super.pickProfileImage());
  }

  late final _$_RegisterStoreActionController = ActionController(
    name: '_RegisterStore',
    context: context,
  );

  @override
  void setName(String v) {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.setName',
    );
    try {
      return super.setName(v);
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhone(String v) {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.setPhone',
    );
    try {
      return super.setPhone(v);
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String v) {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.setEmail',
    );
    try {
      return super.setEmail(v);
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String v) {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.setPassword',
    );
    try {
      return super.setPassword(v);
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTipoUsuario(String v) {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.setTipoUsuario',
    );
    try {
      return super.setTipoUsuario(v);
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
      name: '_RegisterStore.togglePasswordVisibility',
    );
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
phone: ${phone},
email: ${email},
password: ${password},
tipoUsuario: ${tipoUsuario},
isPasswordVisible: ${isPasswordVisible},
profileImage: ${profileImage},
isUploadingPhoto: ${isUploadingPhoto},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isFormValid: ${isFormValid}
    ''';
  }
}
