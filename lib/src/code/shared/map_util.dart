class MapUtil {
  static Map<String, String> reverse(Map<String, String> map) {
    Iterable<MapEntry<String, String>> entries = map.entries;
    Map<String, String> reverseMap = {};
    for (var entry in entries) {
      reverseMap[entry.value] = entry.key;
    }
    return reverseMap;
  }
}
