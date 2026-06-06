class ApiPagination {
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const ApiPagination({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory ApiPagination.fromJson(Map<String, dynamic> json) {
    final hasStandardKeys =
        json.containsKey('page') || json.containsKey('page_size');

    if (hasStandardKeys) {
      final pageSize = json['page_size'] as int? ?? 20;
      final totalCount = json['total_count'] as int? ?? 0;
      return ApiPagination(
        page: json['page'] as int? ?? 1,
        pageSize: pageSize,
        totalCount: totalCount,
        totalPages: json['total_pages'] as int? ?? (pageSize > 0 ? (totalCount / pageSize).ceil() : 1),
      );
    }

    final limit = json['limit'] as int?;
    final offset = json['offset'] as int?;
    final total = json['total'] as int?;

    if (limit != null && offset != null && total != null) {
      final pageSize = limit;
      final page = offset ~/ limit + 1;
      final totalPages = pageSize > 0 ? (total / pageSize).ceil() : 1;
      return ApiPagination(
        page: page,
        pageSize: pageSize,
        totalCount: total,
        totalPages: totalPages,
      );
    }

    if (limit != null && total != null) {
      final pageSize = limit;
      return ApiPagination(
        page: 1,
        pageSize: pageSize,
        totalCount: total,
        totalPages: pageSize > 0 ? (total / pageSize).ceil() : 1,
      );
    }

    return const ApiPagination(
      page: 1,
      pageSize: 0,
      totalCount: 0,
      totalPages: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_count': totalCount,
      'total_pages': totalPages,
    };
  }

  @override
  String toString() =>
      'ApiPagination(page: $page, pageSize: $pageSize, totalCount: $totalCount, totalPages: $totalPages)';
}
