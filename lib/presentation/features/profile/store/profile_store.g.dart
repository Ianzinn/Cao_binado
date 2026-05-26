// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??= Computed<bool>(
    () => super.isAdmin,
    name: '_ProfileStore.isAdmin',
  )).value;
  Computed<String>? _$userNameComputed;

  @override
  String get userName => (_$userNameComputed ??= Computed<String>(
    () => super.userName,
    name: '_ProfileStore.userName',
  )).value;
  Computed<String>? _$userEmailComputed;

  @override
  String get userEmail => (_$userEmailComputed ??= Computed<String>(
    () => super.userEmail,
    name: '_ProfileStore.userEmail',
  )).value;
  Computed<String?>? _$fotoPerfilUrlComputed;

  @override
  String? get fotoPerfilUrl => (_$fotoPerfilUrlComputed ??= Computed<String?>(
    () => super.fotoPerfilUrl,
    name: '_ProfileStore.fotoPerfilUrl',
  )).value;

  late final _$biometricSupportedAtom = Atom(
    name: '_ProfileStore.biometricSupported',
    context: context,
  );

  @override
  bool get biometricSupported {
    _$biometricSupportedAtom.reportRead();
    return super.biometricSupported;
  }

  @override
  set biometricSupported(bool value) {
    _$biometricSupportedAtom.reportWrite(value, super.biometricSupported, () {
      super.biometricSupported = value;
    });
  }

  late final _$biometricEnabledAtom = Atom(
    name: '_ProfileStore.biometricEnabled',
    context: context,
  );

  @override
  bool get biometricEnabled {
    _$biometricEnabledAtom.reportRead();
    return super.biometricEnabled;
  }

  @override
  set biometricEnabled(bool value) {
    _$biometricEnabledAtom.reportWrite(value, super.biometricEnabled, () {
      super.biometricEnabled = value;
    });
  }

  late final _$appVersionAtom = Atom(
    name: '_ProfileStore.appVersion',
    context: context,
  );

  @override
  String get appVersion {
    _$appVersionAtom.reportRead();
    return super.appVersion;
  }

  @override
  set appVersion(String value) {
    _$appVersionAtom.reportWrite(value, super.appVersion, () {
      super.appVersion = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_ProfileStore.isLoading',
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

  late final _$disableBiometricAsyncAction = AsyncAction(
    '_ProfileStore.disableBiometric',
    context: context,
  );

  @override
  Future<void> disableBiometric() {
    return _$disableBiometricAsyncAction.run(() => super.disableBiometric());
  }

  late final _$pickAndUpdatePhotoAsyncAction = AsyncAction(
    '_ProfileStore.pickAndUpdatePhoto',
    context: context,
  );

  @override
  Future<void> pickAndUpdatePhoto() {
    return _$pickAndUpdatePhotoAsyncAction.run(
      () => super.pickAndUpdatePhoto(),
    );
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_ProfileStore.logout',
    context: context,
  );

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
biometricSupported: ${biometricSupported},
biometricEnabled: ${biometricEnabled},
appVersion: ${appVersion},
isLoading: ${isLoading},
isAdmin: ${isAdmin},
userName: ${userName},
userEmail: ${userEmail},
fotoPerfilUrl: ${fotoPerfilUrl}
    ''';
  }
}
