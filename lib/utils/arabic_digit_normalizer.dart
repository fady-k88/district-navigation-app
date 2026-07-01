class ArabicDigitNormalizer {
  ArabicDigitNormalizer._(); // prevent instantiation

  // Converts Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩) to Western Arabic (0-9)
  // and trims surrounding whitespace.
  // Use before any numeric string comparison to support Egyptian phone keyboards.
  static String normalize(String s) {
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = s.trim();
    for (var i = 0; i < arabicIndic.length; i++) {
      result = result.replaceAll(arabicIndic[i], '$i');
    }
    return result;
  }
}
