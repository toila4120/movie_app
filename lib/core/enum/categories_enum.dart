enum CategoriesEnum {
  all,
  phimLe,
  phimBo,
  tvShow,
  hoatHinh;

  bool get isAll => this == CategoriesEnum.all;

  bool get isPhimLe => this == CategoriesEnum.phimLe;

  bool get isPhimBo => this == CategoriesEnum.phimBo;

  bool get isTvShow => this == CategoriesEnum.tvShow;

  bool get isHoatHinh => this == CategoriesEnum.hoatHinh;

  String toSlug() {
    switch (this) {
      case CategoriesEnum.all:
        return 'all';
      case CategoriesEnum.phimLe:
        return 'phim-le';
      case CategoriesEnum.phimBo:
        return 'phim-bo';
      case CategoriesEnum.tvShow:
        return 'tv-show';
      case CategoriesEnum.hoatHinh:
        return 'hoat-hinh';
    }
  }

  String toText() {
    switch (this) {
      case CategoriesEnum.all:
        return 'Tất cả';
      case CategoriesEnum.phimLe:
        return 'Phim lẻ';
      case CategoriesEnum.phimBo:
        return 'Phim bộ';
      case CategoriesEnum.tvShow:
        return 'TV Show';
      case CategoriesEnum.hoatHinh:
        return 'Hoạt hình';
    }
  }

  static List<Map<String, String>> toList() {
    return CategoriesEnum.values.map((category) {
      return {
        'slug': category.toSlug(),
        'name': category.toText(),
      };
    }).toList();
  }

  static int toCount() {
    return CategoriesEnum.values.length;
  }
}
