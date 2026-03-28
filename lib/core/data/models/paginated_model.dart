import 'package:money_management_mobile/core/domain/entities/paginated_entity.dart';

class PaginatedModel<T> extends PaginatedEntity<T> {
  PaginatedModel({
    required super.items,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
  });

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedModel(
      items: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int,
      totalPages: json['last_page'] as int,
      totalItems: json['total'] as int,
    );
  }
}
