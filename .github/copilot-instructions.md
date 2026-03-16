# GitHub Copilot Instructions for Money Management Mobile

You are an Expert Flutter Software Architect assisting with the `money_management_mobile` project. Always strictly adhere to the following architectural patterns, coding standards, and libraries used in this project.

## 1. Architectural Pattern: Clean Architecture

The project follows a strict feature-based Clean Architecture: `lib/features/<feature_name>/`.
Each feature must be separated into three main layers:

- **Domain (`domain/`)**: Contains `entities` (pure data objects), `repositories` (abstract interfaces), and `usecases`. The Domain layer MUST NOT depend on any Flutter-specific packages, JSON serialization, or Data layer implementations.
- **Data (`data/`)**: Contains `data_sources` (remote/local), `models` (DTOs/JSON representations), and `repositories` (implementation of domain interfaces).
  - _Crucial Rule_: `Models` MUST be a subclass/implementation of the `Entity` from the Domain layer. The Data Repository implementation is responsible for mapping Models to Entities.
- **Presentation (`presentation/`)**: Contains `cubit`/`bloc` (state management), `pages`, and `widgets`.

## 2. Feature Implementation Flow (Reference: Login Feature)

Whenever generating a new feature, follow this exact dependency flow:

1. **Model**: Create a model in `data/models/` for JSON parsing (`fromJson`/`toJson`) that extends the Domain Entity.
2. **Data Source**: Create functions in `RemoteDataSource` that return the `Model`.
3. **Repository Impl**: Implement the Domain repository interface in `RepositoryImpl`. Call the Data Source, catch exceptions, and map the returned `Model` into an `Entity`.
4. **UseCase**: Call the repository interface from a dedicated UseCase.
5. **Cubit**: Call the UseCase within the Cubit to process data and emit states (e.g., Loading, Success, Error).
6. **UI (Page)**: Listen to Cubit states using `BlocBuilder` or `BlocConsumer` and trigger Cubit functions from UI events.

## 3. Core Libraries & State Management

- **State Management**: Use `flutter_bloc` (specifically `Cubit` for most cases). Always create separate `<feature>_state.dart` and `<feature>_cubit.dart` files. Do not mix business logic inside UI files.
- **Dependency Injection**: Use `get_it`. Always remind the user to register new instances (UseCases, Repositories, DataSources, Cubits) in `lib/injection_container.dart`. Use `sl()` or `sl.get<T>()` to resolve dependencies.
- **Routing**: Use `go_router`. Define all routes declaratively in `lib/core/routes/app_router.dart`. Use `context.go()` or `context.pop()`, NEVER use standard `Navigator.push()`.
- **Networking**: Use `dio`.

## 4. UI and Styling Guidelines

- **NEVER use hardcoded colors, padding, sizes, or text styles.**
- **Colors**: Always use `AppColors` from `lib/core/theme/app_colors.dart` (e.g., `AppColors.primary`, `AppColors.gohan`, `AppColors.trunks`).
- **Spacing/Radius**: Always use `AppSizes` from `lib/core/theme/app_sizes.dart` (e.g., `AppSizes.spacing4`, `AppSizes.radiusNm`).
- **Typography**: Rely on `Theme.of(context).textTheme` combined with `.copyWith()` or custom styles defined in `lib/core/theme/app_text_styles.dart`.
- **Components**: Reuse existing custom widgets located in `lib/core/widgets/` (like `AppButton`, `AppTextField`, `AppAlert`) instead of creating new basic material widgets.
- **Assets**: Use `flutter_svg` for vector graphics (`SvgPicture.asset`).

## 5. Error Handling & Logging

- **NO `print()` STATEMENTS ALLOWED.**
- **Logging**: Always use the `logging` package. Initialize a logger at the class level: `final _log = Logger('ClassName');`. Use appropriate log levels (`_log.fine`, `_log.info`, `_log.warning`, `_log.severe`) to trace requests, responses, and errors.
- **Exceptions & Failures**: Catch errors in `RepositoryImpl` and map them to custom Exceptions or Failures defined in `lib/core/error/` (e.g., `ServerException`, `NetworkException`). Inside the Cubit, map these failures to user-friendly UI messages (`emit(AuthError(failure.message))`).

## 6. Mocking / Dummy Data Implementations (DEFAULT BEHAVIOR)

By default, ALWAYS implement mock/dummy data for all new features unless explicitly instructed to integrate a real API.

- **Implementation Layer**: Implement the mock logic directly inside the `RemoteDataSource` class.
- **Simulate Latency**: Use `await Future.delayed(const Duration(seconds: 1));` to simulate network latency.
- **Logging**: Log the simulated request payloads and responses using the `Logger`.
- **Simulate Scenarios**: Implement hardcoded logic to simulate both `success` and `failure` scenarios (e.g., `if (email == "test@mail.com") { return successModel; } else { throw ServerException(); }`).
- **Seamless Integration**: Ensure the Repository, UseCase, and Cubit treat these dummy data sources exactly as they would treat a real network call, including graceful exception handling and state mapping.

## 7. General Code Generation Rules

- Write code in Dart 3.0+ style (use modern features like records, pattern matching, and exhaustive switch where applicable).
- Include standard error snackbars matching the project's styling (`AppColors.danger100` for errors) when handling state failures in the UI.
- Ensure all imports use absolute package paths (e.g., `import 'package:money_management_mobile/features/...'`) rather than relative paths (`../../`).

## 8. Dependency Rules and Cross-Feature Collaboration

Follow these dependency rules for all new code and refactors.

### 8.1 Allowed dependency direction

- `presentation -> domain` (same feature)
- `data -> domain` (same feature)
- Composition root (`lib/injection_container.dart`, `lib/core/routes/app_router.dart`) can import all features for wiring.

### 8.2 Forbidden dependency direction

- `domain -> data`
- `domain -> presentation`
- Direct cross-feature access to implementation details (e.g., using another feature's `RemoteDataSource` or repository implementation class).

### 8.3 Cross-feature collaboration contract

- Use **Router** for navigation between feature flows.
- Use **DI** only for composition/wiring, not as a shortcut to bypass architecture boundaries.
- Use **app-level state** (for example, session/auth state) for read-only cross-feature UI needs.
- Use **domain contracts** (repository interfaces/use cases) for business-level integration.
- **Crucial:** When Feature A depends on Feature B's UseCase (e.g., Dashboard calling Transaction UseCase), Feature A must only consume the **Domain Entities** returned by that UseCase. Feature A must never import Feature B's Data Models, Repositories, or State/Cubit classes.

### 8.4 UI component sharing rule

- A widget from another feature may be reused only if it is pure presentation.
- Shared widget must not depend on the source feature's cubit/use case/repository.
- If reused in multiple features and business-agnostic, move it to `lib/core/widgets/`.

### 8.5 Session ownership rule

- Session status and lightweight user identity can be read by any feature at presentation level.
- Session persistence mutations (`login`, `logout`, `restore`, token save/clear) are owned by Auth and must remain in Auth use cases/repositories.
- **Strict Storage Rule:** No other feature is allowed to write or delete the Auth Token in local storage (e.g., SharedPreferences/SecureStorage). If an HTTP 401 Unauthorized occurs in another feature (e.g., Transaction), the network interceptor must trigger a global event (or call Auth Logout UseCase) rather than clearing the token directly.

### 8.6 Concrete collaboration examples

#### Example A: Transaction feature needs active user (The Mobile Way)

**Valid approach**:

- Inject `SessionCubit` or `AuthRepository` directly into `TransactionCubit` or its UseCase via Dependency Injection.
- Let the Cubit/UseCase resolve the `userId` internally so the UI remains clean and dumb.

**Invalid approach**:

- The UI constantly reads the `userId` from app state and passes it as a parameter to the Cubit's methods.
- Transaction feature directly calls Auth remote/local data source.

```dart
// Valid UI Trigger (Dumb UI):
context.read<TransactionCubit>().loadRecent();

// Valid Cubit Logic (Resolving User ID internally via DI):
class TransactionCubit extends Cubit<TransactionState> {
  final GetRecentTransactionsUseCase useCase;
  final SessionCubit sessionCubit; // Injected via get_it

  TransactionCubit(this.useCase, this.sessionCubit);

  Future<void> loadRecent() async {
    final session = sessionCubit.state;
    if (session is SessionAuthenticated) {
        emit(const TransactionLoading());
        final items = await useCase.execute(userId: session.user.id);
        emit(TransactionLoaded(items));
    }
  }
}
```

#### Example B: Other page needs user profile summary

**Valid approach:**

- Read name/email from session state for lightweight UI rendering.
- If rich profile data is needed, call Profile use case (when profile feature exists).

**Invalid approach:**

- Other page reads Auth local data source directly.

```dart
final sessionState = context.watch<SessionCubit>().state;
if (sessionState is SessionAuthenticated) {
  final displayName = sessionState.user.name;
  final email = sessionState.user.email;
  // render header UI
}
```

#### Example C: Dashboard needs latest transactions

**Valid approach:**

- Dashboard uses a Dashboard/Transaction use case contract to fetch recent transactions.
- Transaction feature remains the owner of transaction data retrieval logic.
- Dashboard strictly uses the Entity returned by the Transaction UseCase.

**Invalid approach:**

- Dashboard directly calls transaction data source or uses transaction data models from data layer.

```dart
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this.getRecentTransactionsUseCase)
      : super(const DashboardInitial());

  final GetRecentTransactionsUseCase getRecentTransactionsUseCase;

  Future<void> loadRecent({required String userId}) async {
    emit(const DashboardLoading());
    // Items returned MUST be Domain Entities, not Data Models
    final items = await getRecentTransactionsUseCase.execute(userId: userId);
    emit(DashboardLoaded(recentTransactions: items));
  }
}
```

### 8.7 PR review checklist for dependency safety

- No feature imports another feature's implementation classes in data/domain layers.
- No domain layer imports Flutter/UI/framework classes.
- Cross-feature collaboration happens via router, app-level state, or domain contracts.
- Shared components are presentation-only or moved to core shared modules.
- Cross-feature UseCase calls strictly exchange Domain Entities, never Data Models.
