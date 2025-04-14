enum TranslationType {
  all,
  vietsub,
  thuyetMinh,
  longTieng;

  bool get isAll => this == TranslationType.all;

  bool get isVietsub => this == TranslationType.vietsub;

  bool get isThuyetMinh => this == TranslationType.thuyetMinh;

  bool get isLongTieng => this == TranslationType.longTieng;

  String toSlug() {
    switch (this) {
      case TranslationType.all:
        return 'all';
      case TranslationType.vietsub:
        return 'vietsub';
      case TranslationType.thuyetMinh:
        return 'thuyet-minh';
      case TranslationType.longTieng:
        return 'long-tieng';
    }
  }

  String toText() {
    switch (this) {
      case TranslationType.all:
        return 'Tất cả';
      case TranslationType.vietsub:
        return 'Vietsub';
      case TranslationType.thuyetMinh:
        return 'Thuyết Minh';
      case TranslationType.longTieng:
        return 'Lồng Tiếng';
    }
  }

  static List<Map<String, String>> toList() {
    return TranslationType.values.map((type) {
      return {
        'slug': type.toSlug(),
        'name': type.toText(),
      };
    }).toList();
  }

  static int toCount() {
    return TranslationType.values.length;
  }
}
