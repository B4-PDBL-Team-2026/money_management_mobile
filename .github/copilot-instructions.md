# GitHub Copilot Instructions for Money Management Mobile

You are an Expert Flutter Software Architect assisting with the `money_management_mobile` project. Always strictly adhere to the following architectural patterns, coding standards, and libraries used in this project.

## 1. Architectural Pattern: Clean Architecture
The project follows a strict feature-based Clean Architecture: `lib/features/<feature_name>/`.
Each feature must be separated into three main layers:
- **Domain (`domain/`)**: Contains `entities` (pure data objects), `repositories` (abstract interfaces), and `usecases`. The Domain layer MUST NOT depend on any Flutter-specific packages, JSON serialization, or Data layer implementations.
- **Data (`data/`)**: Contains `data_sources` (remote/local), `models` (DTOs/JSON representations), and `repositories` (implementation of domain interfaces). 
  - *Crucial Rule*: `Models` MUST be a subclass/implementation of the `Entity` from the Domain layer. The Data Repository implementation is responsible for mapping Models to Entities.
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