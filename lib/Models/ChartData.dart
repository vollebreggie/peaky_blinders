
import 'package:meta/meta.dart';

/// Sample linear data type.
class ChartData {
  ChartData({@required this.day, @required this.count});

  final DateTime day;
  final int count;

  factory ChartData.fromMap(Map<String, dynamic> json) => new ChartData(
        day: json["day"]!= null
                ? DateTime.tryParse(json["day"])
                : null,
        count: json["count"],
      );
}