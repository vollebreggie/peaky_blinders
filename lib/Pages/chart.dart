/// Example of a stacked area chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:peaky_blinders/Models/ChartData.dart';

class StackedAreaLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory StackedAreaLineChart.withSampleData(List<ChartData> list) {
    return new StackedAreaLineChart(
      _createGraph(list),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = new Color.fromRGBO(255, 255, 255, 1.0);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      color: Colors.transparent,
      child: new charts.TimeSeriesChart(seriesList,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          domainAxis: charts.DateTimeAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),
              lineStyle: charts.LineStyleSpec(
                  thickness: 0, color: charts.MaterialPalette.transparent),
            ),
            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: charts.TimeFormatterSpec(
                format: 'EEE',
                transitionFormat: 'EEE',
              ),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              labelStyle: charts.TextStyleSpec(
                fontSize: 5,
                color: charts.Color(
                    r: color.red,
                    g: color.green,
                    b: color.blue,
                    a: color.alpha),
              ),
              lineStyle: charts.LineStyleSpec(
                  thickness: 0, color: charts.MaterialPalette.transparent),
            ),
          ),
          defaultRenderer:
              new charts.LineRendererConfig(includeArea: true, stacked: true),
          animate: animate),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<ChartData, DateTime>> _createGraph(list) {
    final List<ChartData> data = <ChartData>[
      ChartData(
        day: DateTime(2019, 1, 7),
        count: 5,
      ),
      ChartData(day: DateTime(2019, 1, 8), count: 25),
      ChartData(day: DateTime(2019, 1, 9), count: 100),
      ChartData(day: DateTime(2019, 1, 10), count: 75),
      ChartData(day: DateTime(2019, 1, 11), count: 25),
      ChartData(day: DateTime(2019, 1, 12), count: 100),
      ChartData(day: DateTime(2019, 1, 13), count: 75),
    ];
    Color color = new Color.fromRGBO(8, 68, 22, 1.0);
    return <charts.Series<ChartData, DateTime>>[
      charts.Series<ChartData, DateTime>(
        id: 'Count',
        colorFn: (_, __) => charts.Color(
            r: color.red,
            g: color.green,
            b: color.blue,
            a: color.alpha), //8, 68, 22
        domainFn: (ChartData data, _) => data.day,
        measureFn: (ChartData data, _) => data.count,
        data: list,
      )
    ];
  }
}
