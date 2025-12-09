import '../constants.dart';

class ReadingUtils {

  static double toKwh(String reading) {
    final value = int.tryParse(reading) ?? 0;
    return value / 1000;
  }


  static double calculateCost(String reading) {
    final kwh = toKwh(reading);
    return kwh * PricingConfig.pricePerKwh;
  }

  static String formatKwh(String reading) {
    return "${toKwh(reading).toStringAsFixed(2)} kWh";
  }


}