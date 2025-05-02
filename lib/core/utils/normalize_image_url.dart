String normalizeImageUrl(String posterUrl) {
  const baseUrl = 'https://phimimg.com/';
  if (posterUrl.startsWith(baseUrl)) {
    return posterUrl;
  } else if (posterUrl.startsWith('/')) {
    return '$baseUrl${posterUrl.substring(1)}';
  } else {
    return '$baseUrl$posterUrl';
  }
}
