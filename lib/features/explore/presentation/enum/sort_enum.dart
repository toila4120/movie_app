enum SortType {
  modifiedTime,
  id,
  year;

  bool get isModifiedTime => this == SortType.modifiedTime;

  bool get isId => this == SortType.id;

  bool get isYear => this == SortType.year;

  String toSlug() {
    switch (this) {
      case SortType.modifiedTime:
        return 'modified.time';
      case SortType.id:
        return '_id';
      case SortType.year:
        return 'year';
    }
  }

  String toText() {
    switch (this) {
      case SortType.modifiedTime:
        return 'Mới cập nhật';
      case SortType.id:
        return 'Thời gian đăng';
      case SortType.year:
        return 'Năm phát hành';
    }
  }

  static List<Map<String, String>> toList() {
    return SortType.values.map((type) {
      return {
        'slug': type.toSlug(),
        'name': type.toText(),
      };
    }).toList();
  }

  static int toCount() {
    return SortType.values.length;
  }
}
