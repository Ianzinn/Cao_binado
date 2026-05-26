import 'package:get_it/get_it.dart';

// Core
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../services/cep_service.dart';

// Domain — repository interfaces
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/repositories/adoption_repository.dart';
import '../../domain/repositories/storage_repository.dart';

// Data — datasources
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/pet_remote_datasource.dart';
import '../../data/datasources/remote/adoption_remote_datasource.dart';
import '../../data/datasources/remote/storage_remote_datasource.dart';

// Data — repository implementations
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/pet_repository_impl.dart';
import '../../data/repositories/adoption_repository_impl.dart';
import '../../data/repositories/storage_repository_impl.dart';

// Presentation — Auth stores
import '../../presentation/features/auth/store/auth_store.dart';
import '../../presentation/features/auth/store/login_store.dart';
import '../../presentation/features/auth/store/register_store.dart';

// Presentation — Home / Profile stores
import '../../presentation/features/home/store/home_store.dart';
import '../../presentation/features/profile/store/profile_store.dart';
import '../../presentation/features/profile/store/account_info_store.dart';

// Presentation — Pets stores
import '../../presentation/features/pets/store/pet_store.dart';
import '../../presentation/features/pets/store/find_store.dart';
import '../../presentation/features/pets/store/favorites_store.dart';
import '../../presentation/features/pets/store/register_animal_store.dart';

// Presentation — Adopters / Tutor stores
import '../../presentation/features/adopters/store/adopters_store.dart';
import '../../presentation/features/adopters/store/register_tutor_store.dart';

// Presentation — History store
import '../../presentation/features/history/store/history_store.dart';

// Presentation — Adoption Requests store
import '../../presentation/features/adoption/store/adoption_requests_store.dart';
import '../../presentation/features/adoption/store/my_adoptions_store.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // ── Core services ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  getIt.registerLazySingleton<CepService>(() => CepService());

  // ── Remote datasources ─────────────────────────────────────────────────────
  getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource());
  getIt.registerLazySingleton<PetRemoteDatasource>(
      () => PetRemoteDatasource());
  getIt.registerLazySingleton<AdoptionRemoteDatasource>(
      () => AdoptionRemoteDatasource());
  getIt.registerLazySingleton<StorageRemoteDatasource>(
      () => StorageRemoteDatasource());

  // ── Repository implementations ─────────────────────────────────────────────
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<UserRemoteDatasource>()));
  getIt.registerLazySingleton<PetRepository>(
      () => PetRepositoryImpl(getIt<PetRemoteDatasource>()));
  getIt.registerLazySingleton<AdoptionRepository>(
      () => AdoptionRepositoryImpl(getIt<AdoptionRemoteDatasource>()));
  getIt.registerLazySingleton<StorageRepository>(
      () => StorageRepositoryImpl(getIt<StorageRemoteDatasource>()));

  // ── AuthStore — singleton so auth state is shared app-wide ────────────────
  getIt.registerLazySingleton<AuthStore>(
    () => AuthStore(getIt<AuthService>(), getIt<UserRepository>()),
  );

  // ── PetStore — singleton so the pet list & images survive navigation ───────
  getIt.registerLazySingleton<PetStore>(
    () => PetStore(getIt<PetRepository>(), getIt<StorageRepository>()),
  );

  // ── Page-scoped stores (new instance per page) ────────────────────────────
  getIt.registerFactory<LoginStore>(
    () => LoginStore(getIt<AuthStore>(), getIt<BiometricService>()),
  );
  getIt.registerFactory<RegisterStore>(
    () => RegisterStore(getIt<AuthStore>(), getIt<StorageRepository>()),
  );
  getIt.registerLazySingleton<HomeStore>(
    () => HomeStore(getIt<AuthStore>(), getIt<AdoptionRepository>()),
  );
  getIt.registerFactory<ProfileStore>(
    () => ProfileStore(
      getIt<AuthStore>(),
      getIt<StorageRepository>(),
      getIt<BiometricService>(),
    ),
  );
  getIt.registerFactory<AccountInfoStore>(
    () => AccountInfoStore(
      getIt<AuthStore>(),
      getIt<UserRepository>(),
      getIt<CepService>(),
    ),
  );
  getIt.registerFactory<FavoritesStore>(
    () => FavoritesStore(
      getIt<UserRepository>(),
      getIt<PetRepository>(),
      getIt<AuthStore>(),
    ),
  );
  getIt.registerFactory<FindStore>(
    () => FindStore(
      getIt<PetStore>(),
      getIt<AdoptionRepository>(),
      getIt<AuthStore>(),
    ),
  );
  getIt.registerFactory<RegisterAnimalStore>(
    () => RegisterAnimalStore(getIt<PetStore>(), getIt<AuthStore>()),
  );
  getIt.registerFactory<AdoptersStore>(
    () => AdoptersStore(getIt<AdoptionRepository>(), getIt<AuthStore>()),
  );
  getIt.registerFactory<RegisterTutorStore>(() => RegisterTutorStore());
  getIt.registerFactory<HistoryStore>(
    () => HistoryStore(getIt<AdoptionRepository>(), getIt<AuthStore>()),
  );
  getIt.registerFactory<AdoptionRequestsStore>(
    () => AdoptionRequestsStore(
      getIt<AdoptionRepository>(),
      getIt<AuthStore>(),
    ),
  );
  getIt.registerFactory<MyAdoptionsStore>(
    () => MyAdoptionsStore(
      getIt<AdoptionRepository>(),
      getIt<AuthStore>(),
    ),
  );
}
