// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adoption_requests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdoptionRequestsStore on _AdoptionRequestsStore, Store {
  Computed<int>? _$pendingCountComputed;

  @override
  int get pendingCount => (_$pendingCountComputed ??= Computed<int>(
    () => super.pendingCount,
    name: '_AdoptionRequestsStore.pendingCount',
  )).value;

  late final _$requestsAtom = Atom(
    name: '_AdoptionRequestsStore.requests',
    context: context,
  );

  @override
  ObservableList<AdoptionModel> get requests {
    _$requestsAtom.reportRead();
    return super.requests;
  }

  @override
  set requests(ObservableList<AdoptionModel> value) {
    _$requestsAtom.reportWrite(value, super.requests, () {
      super.requests = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_AdoptionRequestsStore.isLoading',
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
    name: '_AdoptionRequestsStore.errorMessage',
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
    name: '_AdoptionRequestsStore.isProcessing',
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

  late final _$approveAsyncAction = AsyncAction(
    '_AdoptionRequestsStore.approve',
    context: context,
  );

  @override
  Future<bool> approve(
    AdoptionModel request, {
    required String visitLocation,
    required DateTime visitDateTime,
    String? visitNotes,
  }) {
    return _$approveAsyncAction.run(
      () => super.approve(
        request,
        visitLocation: visitLocation,
        visitDateTime: visitDateTime,
        visitNotes: visitNotes,
      ),
    );
  }

  late final _$rejectAsyncAction = AsyncAction(
    '_AdoptionRequestsStore.reject',
    context: context,
  );

  @override
  Future<bool> reject(AdoptionModel request) {
    return _$rejectAsyncAction.run(() => super.reject(request));
  }

  late final _$_AdoptionRequestsStoreActionController = ActionController(
    name: '_AdoptionRequestsStore',
    context: context,
  );

  @override
  void start() {
    final _$actionInfo = _$_AdoptionRequestsStoreActionController.startAction(
      name: '_AdoptionRequestsStore.start',
    );
    try {
      return super.start();
    } finally {
      _$_AdoptionRequestsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requests: ${requests},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
isProcessing: ${isProcessing},
pendingCount: ${pendingCount}
    ''';
  }
}
