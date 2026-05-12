// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated => (_$isAuthenticatedComputed ??= Computed<bool>(
    () => super.isAuthenticated,
    name: '_AuthStore.isAuthenticated',
  )).value;
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??= Computed<bool>(
    () => super.isAdmin,
    name: '_AuthStore.isAdmin',
  )).value;
  Computed<String>? _$displayNameComputed;

  @override
  String get displayName => (_$displayNameComputed ??= Computed<String>(
    () => super.displayName,
    name: '_AuthStore.displayName',
  )).value;
  Computed<String>? _$displayEmailComputed;

  @override
  String get displayEmail => (_$displayEmailComputed ??= Computed<String>(
    () => super.displayEmail,
    name: '_AuthStore.displayEmail',
  )).value;

  late final _$firebaseUserAtom = Atom(
    name: '_AuthStore.firebaseUser',
    context: context,
  );

  @override
  User? get firebaseUser {
    _$firebaseUserAtom.reportRead();
    return super.firebaseUser;
  }

  @override
  set firebaseUser(User? value) {
    _$firebaseUserAtom.reportWrite(value, super.firebaseUser, () {
      super.firebaseUser = value;
    });
  }

  late final _$userProfileAtom = Atom(
    name: '_AuthStore.userProfile',
    context: context,
  );

  @override
  UserModel? get userProfile {
    _$userProfileAtom.reportRead();
    return super.userProfile;
  }

  @override
  set userProfile(UserModel? value) {
    _$userProfileAtom.reportWrite(value, super.userProfile, () {
      super.userProfile = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AuthStore.isLoading',
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
    name: '_AuthStore.errorMessage',
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

  late final _$_fetchProfileAsyncAction = AsyncAction(
    '_AuthStore._fetchProfile',
    context: context,
  );

  @override
  Future<void> _fetchProfile(String uid) {
    return _$_fetchProfileAsyncAction.run(() => super._fetchProfile(uid));
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthStore.login',
    context: context,
  );

  @override
  Future<bool> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$registerAsyncAction = AsyncAction(
    '_AuthStore.register',
    context: context,
  );

  @override
  Future<bool> register({
    required String email,
    required String password,
    required String nome,
    required String tipoUsuario,
  }) {
    return _$registerAsyncAction.run(
      () => super.register(
        email: email,
        password: password,
        nome: nome,
        tipoUsuario: tipoUsuario,
      ),
    );
  }

  late final _$updateProfilePhotoAsyncAction = AsyncAction(
    '_AuthStore.updateProfilePhoto',
    context: context,
  );

  @override
  Future<void> updateProfilePhoto(String url) {
    return _$updateProfilePhotoAsyncAction.run(
      () => super.updateProfilePhoto(url),
    );
  }

  late final _$refreshProfileAsyncAction = AsyncAction(
    '_AuthStore.refreshProfile',
    context: context,
  );

  @override
  Future<void> refreshProfile() {
    return _$refreshProfileAsyncAction.run(() => super.refreshProfile());
  }

  late final _$_AuthStoreActionController = ActionController(
    name: '_AuthStore',
    context: context,
  );

  @override
  void _onAuthChanged(User? user) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
      name: '_AuthStore._onAuthChanged',
    );
    try {
      return super._onAuthChanged(user);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> logout() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
      name: '_AuthStore.logout',
    );
    try {
      return super.logout();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
firebaseUser: ${firebaseUser},
userProfile: ${userProfile},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isAuthenticated: ${isAuthenticated},
isAdmin: ${isAdmin},
displayName: ${displayName},
displayEmail: ${displayEmail}
    ''';
  }
}
