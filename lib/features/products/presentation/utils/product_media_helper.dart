class ProductMediaHelper {
  static const String baseUrl = 'https://olampardalar.uz';

  static String fullUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '$baseUrl$path';
  }
}