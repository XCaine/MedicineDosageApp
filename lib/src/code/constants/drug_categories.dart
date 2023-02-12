class DrugCategories {
  static final List<String> categoryNames = categoryExplanationMap.keys.toList();

  static final List<String> categoryExplanations = categoryExplanationMap.values.toList();

  static const List<String> validOnes = ['otc', 'rp', 'rpz', 'rpw', 'lz'];

  static const Map<String, String> categoryExplanationMap = {
    'otc': 'otc - wydawane bez przepisu lekarza',
    'rp': 'rp - wydawane z przepisu lekarza',
    'rpz': 'rpz - wydawane z przepisu lekarza do zastrzeżonego stosowania',
    'rpw': 'rpw - wydawane z przepisu lekarza, zawierające środki odurzające lub substancje psychotropowe',
    'lz': 'lz - stosowane wyłącznie w lecznictwie zamkniętym'
  };
}
