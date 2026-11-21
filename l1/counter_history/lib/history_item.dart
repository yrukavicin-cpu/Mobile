// Один запис в історії лічильника
class HistoryItem {
  final String action; // що зробили: +1, -1 або скидання
  final int value; // значення лічильника після дії
  final DateTime time;

  const HistoryItem({
    required this.action,
    required this.value,
    required this.time,
  });

  // час у форматі 12:05:09
  String timeText() {
    String h = time.hour.toString().padLeft(2, '0');
    String m = time.minute.toString().padLeft(2, '0');
    String s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
