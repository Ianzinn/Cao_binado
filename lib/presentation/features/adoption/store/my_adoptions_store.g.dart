// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_adoptions_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyAdoptionsStore on _MyAdoptionsStore, Store {
  late final _$adoptionsAtom = Atom(
    name: '_MyAdoptionsStore.adoptions',
    context: context,
  );

  @override
  ObservableList<AdoptionModel> get adoptions {
    _$adoptionsAtom.reportRead();
    return super.adoptions;
  }

  @override
  set adoptions(ObservableList<AdoptionModel> value) {
    _$adoptionsAtom.reportWrite(value, super.adoptions, () {
      super.adoptions = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_MyAdoptionsStore.isLoading',
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
    name: '_MyAdoptionsStore.errorMessage',
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

  late final _$isProcessingAtom = Atom(
    name: '_MyAdoptionsStore.isProcessing',
    context: context,
  );

  @override
  bool get isProcessing {
    _$isProcessingAtom.reportRead();
    return super.isProcessing;
  }

  @override
  set isProcessing(bool value) {
    _$isProcessingAtom.reportWrite(value, super.isProcessing, () {
      super.isProcessing = value;
    });
  }

  late final _$requestRescheduleAsyncAction = AsyncAction(
    '_MyAdoptionsStore.requestReschedule',
    context: context,
  );

  @override
  Future<bool> requestReschedule(
    AdoptionModel adoption, {
    required DateTime newDateTime,
    required String reason,
  }) {
    return _$requestRescheduleAsyncAction.run(
      () => super.requestReschedule(
        adoption,
        newDateTime: newDateTime,
        reason: reason,
      ),
    );
  }

  late final _$cancelAdoptionAsyncAction = AsyncAction(
    '_MyAdoptionsStore.cancelAdoption',
    context: context,
  );

  @override
  Future<bool> cancelAdoption(AdoptionModel adoption) {
    return _$cancelAdoptionAsyncAction.run(
      () => super.cancelAdoption(adoption),
    );
  }

  late final _$_MyAdoptionsStoreActionController = ActionController(
    name: '_MyAdoptionsStore',
    context: context,
  );

  @override
  void start() {
    final _$actionInfo = _$_MyAdoptionsStoreActionController.startAction(
      name: '_MyAdoptionsStore.start',
    );
    try {
      return super.start();
    } finally {
      _$_MyAdoptionsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
adoptions: ${adoptions},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isProcessing: ${isProcessing}
    ''';
  }
}
