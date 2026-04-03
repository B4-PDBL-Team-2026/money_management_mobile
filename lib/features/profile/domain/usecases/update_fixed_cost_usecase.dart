import 'package:injectable/injectable.dart';
import 'package:money_management_mobile/features/profile/domain/entities/fixed_cost_entity.dart';
import 'package:money_management_mobile/features/profile/domain/repositories/profile_repository.dart';

@Injectable()
class UpdateFixedCostUseCase {
  final ProfileRepository repository;

  UpdateFixedCostUseCase(this.repository);

  Future<void> execute(int fixedCostTemplateId, FixedCostEntity payload) {
    return repository.updateFixedCost(fixedCostTemplateId, payload);
  }
}
