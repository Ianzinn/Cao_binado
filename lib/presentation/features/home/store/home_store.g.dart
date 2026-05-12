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

  late final _$initializeAsyncAction = AsyncAction(
    '_HomeStore.initialize',
    context: context,
  );

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  @override
  String toString() {
    return '''
totalDonations: ${totalDonations},
adoptedAnimals: ${adoptedAnimals},
currentDate: ${currentDate},
userName: ${userName},
isAdmin: ${isAdmin}
    ''';
  }
}
