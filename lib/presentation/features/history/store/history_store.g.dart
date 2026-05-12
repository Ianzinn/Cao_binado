// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryStore on _HistoryStore, Store {
  Computed<int>? _$inProgressCountComputed;

  @override
  int get inProgressCount => (_$inProgressCountComputed ??= Computed<int>(
    () => super.inProgressCount,
    name: '_HistoryStore.inProgressCount',
  )).value;
  Computed<int>? _$completedCountComputed;

  @override
  int get completedCount => (_$completedCountComputed ??= Computed<int>(
    () => super.completedCount,
    name: '_HistoryStore.completedCount',
  )).value;

  late final _$recordsAtom = Atom(
    name: '_HistoryStore.records',
    context: context,
  );

  @override
  ObservableList<AdoptionRecord> get records {
    _$recordsAtom.reportRead();
    return super.records;
  }

  @override
  set records(ObservableList<AdoptionRecord> value) {
    _$recordsAtom.reportWrite(value, super.records, () {
      super.records = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_HistoryStore.isLoading',
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

  late final _$loadHistoryAsyncAction = AsyncAction(
    '_HistoryStore.loadHistory',
    context: context,
  );

  @override
  Future<void> loadHistory() {
    return _$loadHistoryAsyncAction.run(() => super.loadHistory());
  }

  @override
  String toString() {
    return '''
records: ${records},
isLoading: ${isLoading},
inProgressCount: ${inProgressCount},
completedCount: ${completedCount}
    ''';
  }
}
