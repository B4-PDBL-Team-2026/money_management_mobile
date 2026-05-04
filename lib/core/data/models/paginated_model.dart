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
    final dataValue = json['data'];
    final metaValue = json['meta'];

    List<dynamic> dataList;
    Map<String, dynamic>? meta;

    if (dataValue is Map<String, dynamic>) {
      final nestedData = dataValue['data'];
      if (nestedData is List<dynamic>) {
        dataList = nestedData;
      } else {
        dataList = const <dynamic>[];
      }

      final nestedMeta = dataValue['meta'];
      if (nestedMeta is Map<String, dynamic>) {
        meta = nestedMeta;
      }
    } else if (dataValue is List<dynamic>) {
      dataList = dataValue;
    } else {
      dataList = const <dynamic>[];
    }

    if (meta == null && metaValue is Map<String, dynamic>) {
      meta = metaValue;
    }

    int parseInt(dynamic value, int fallback) {
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
      return fallback;
    }

    final totalItems = parseInt(meta?['total'], dataList.length);
    final currentPage = parseInt(meta?['currentPage'], 1);
    final totalPages = parseInt(meta?['lastPage'], 1);

    return PaginatedModel(
      items: dataList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
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
