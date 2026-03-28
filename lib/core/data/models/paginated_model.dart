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
    final data = json['data'] as Map<String, dynamic>;
    final dataList = data['data'] as List<dynamic>;

    return PaginatedModel(
      items: dataList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: data['current_page'] as int,
      totalPages: data['last_page'] as int,
      totalItems: data['total'] as int,
    );
  }

  PaginatedEntity<U> toEntity<U>(U Function(T) toEntityT) {
    return PaginatedEntity<U>(
      items: items.map((item) => toEntityT(item)).toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }
}
