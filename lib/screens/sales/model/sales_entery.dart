class SalesEntry {
  final String date;
  final double totalSales;

  SalesEntry({required this.date, required this.totalSales});

  factory SalesEntry.fromJson(Map<String, dynamic> json) {
    return SalesEntry(
      date: json['date'],
      totalSales: (json['totalSales'] ?? 0).toDouble(),
    );
  }
}
