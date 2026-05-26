// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  Computed<String>? _$userNameComputed;

  @override
  String get userName => (_$userNameComputed ??= Computed<String>(
    () => super.userName,
    name: '_HomeStore.userName',
  )).value;
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??= Computed<bool>(
    () => super.isAdmin,
    name: '_HomeStore.isAdmin',
  )).value;

  late final _$totalDonationsAtom = Atom(
    name: '_HomeStore.totalDonations',
    context: context,
  );

  @override
  int get totalDonations {
    _$totalDonationsAtom.reportRead();
    return super.totalDonations;
  }

  @override
  set totalDonations(int value) {
    _$totalDonationsAtom.reportWrite(value, super.totalDonations, () {
      super.totalDonations = value;
    });
  }

  late final _$adoptedAnimalsAtom = Atom(
    name: '_HomeStore.adoptedAnimals',
    context: context,
  );

  @override
  int get adoptedAnimals {
    _$adoptedAnimalsAtom.reportRead();
    return super.adoptedAnimals;
  }

  @override
  set adoptedAnimals(int value) {
    _$adoptedAnimalsAtom.reportWrite(value, super.adoptedAnimals, () {
      super.adoptedAnimals = value;
    });
  }

  late final _$currentDateAtom = Atom(
    name: '_HomeStore.currentDate',
    context: context,
  );

  @override
  String get currentDate {
    _$currentDateAtom.reportRead();
    return super.currentDate;
  }

  @override
  set currentDate(String value) {
    _$currentDateAtom.reportWrite(value, super.currentDate, () {
      super.currentDate = value;
    });
  }

  late final _$adminPendingCountAtom = Atom(
    name: '_HomeStore.adminPendingCount',
    context: context,
  );

  @override
  int get adminPendingCount {
    _$adminPendingCountAtom.reportRead();
    return super.adminPendingCount;
  }

  @override
  set adminPendingCount(int value) {
    _$adminPendingCountAtom.reportWrite(value, super.adminPendingCount, () {
      super.adminPendingCount = value;
    });
  }

  late final _$newAdminRequestAtom = Atom(
    name: '_HomeStore.newAdminRequest',
    context: context,
  );

  @override
  AdoptionModel? get newAdminRequest {
    _$newAdminRequestAtom.reportRead();
    return super.newAdminRequest;
  }

  @override
  set newAdminRequest(AdoptionModel? value) {
    _$newAdminRequestAtom.reportWrite(value, super.newAdminRequest, () {
      super.newAdminRequest = value;
    });
  }

  late final _$userUnreadCountAtom = Atom(
    name: '_HomeStore.userUnreadCount',
    context: context,
  );

  @override
  int get userUnreadCount {
    _$userUnreadCountAtom.reportRead();
    return super.userUnreadCount;
  }

  @override
  set userUnreadCount(int value) {
    _$userUnreadCountAtom.reportWrite(value, super.userUnreadCount, () {
      super.userUnreadCount = value;
    });
  }

  late final _$initializeAsyncAction = AsyncAction(
    '_HomeStore.initialize',
    context: context,
  );

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$_HomeStoreActionController = ActionController(
    name: '_HomeStore',
    context: context,
  );

  @override
  void clearAdminNotification() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore.clearAdminNotification',
    );
    try {
      return super.clearAdminNotification();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalDonations: ${totalDonations},
adoptedAnimals: ${adoptedAnimals},
currentDate: ${currentDate},
adminPendingCount: ${adminPendingCount},
newAdminRequest: ${newAdminRequest},
userUnreadCount: ${userUnreadCount},
userName: ${userName},
isAdmin: ${isAdmin}
    ''';
  }
}
