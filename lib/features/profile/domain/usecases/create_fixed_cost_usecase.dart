import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

@Injectable()
class CreateFixedCostUseCase {
  final ProfileRepository repository;

  CreateFixedCostUseCase(this.repository);

  Future<void> execute(FixedCostEntity payload) {
    return repository.createFixedCost(payload);
  }
}
