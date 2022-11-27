class DrugCategoryUtil {
  static final List<String> drugCategories =
      categoryExplanationMap.keys.toList();

  static const List<String> validDrugCategories = ['rp', 'rpz', 'rpw'];

  static const Map<String, String> categoryExplanationMap = {
    'otc': 'otc - wydawane bez przepisu lekarza',
    'rp': 'rp - wydawane z przepisu lekarza',
    'rpz': 'rpz - wydawane z przepisu lekarza do zastrzeżonego stosowania',
    'rpw': 'rpw - wydawane z przepisu lekarza, zawierające środki odurzające lub substancje psychotropowe',
    'lz': 'lz - stosowane wyłącznie w lecznictwie zamkniętym'
  };
}
