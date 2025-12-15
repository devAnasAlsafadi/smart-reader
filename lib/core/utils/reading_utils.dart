import '../constants.dart';

class ReadingUtils {

  static double calculateConsumption({
    required double previousMeter,
    required double currentMeter,
  }) {
    final diff = currentMeter - previousMeter;
    return diff > 0 ? diff : 0.0;
  }

  static double calculateCost(double consumption) {
    return consumption * PricingConfig.pricePerKwh;
  }

  static String formatMeterValue(double meterValue) {
    return meterValue.toStringAsFixed(2);
  }

  static String formatConsumption(double consumption) {
    return "${consumption.toStringAsFixed(2)} kWh";
  }

  static String formatCost(double cost) {
    return "₪${cost.toStringAsFixed(2)}";
  }


}