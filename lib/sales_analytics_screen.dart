import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesAnalyticsScreen extends StatefulWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  _SalesAnalyticsScreenState createState() => _SalesAnalyticsScreenState();
}

class _SalesAnalyticsScreenState extends State<SalesAnalyticsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalOrders = 0;
  double totalRevenue = 0;
  Map<String, double> paymentMethods = {"GCash": 0, "COD": 0};
  List<double> monthlySales = List.filled(12, 0);

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  void _fetchSalesData() async {
    QuerySnapshot ordersSnapshot = await _firestore.collection('transactions').get();

    int ordersCount = ordersSnapshot.docs.length;
    double revenue = 0;
    Map<String, double> paymentCount = {"GCash": 0, "COD": 0};
    List<double> salesData = List.filled(12, 0);

    for (var doc in ordersSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      revenue += double.tryParse(data['totalPrice'].toString()) ?? 0;
      paymentCount[data['paymentMethod']] = (paymentCount[data['paymentMethod']] ?? 0) + 1;

      DateTime orderDate = (data['timestamp'] as Timestamp).toDate();
      salesData[orderDate.month - 1] += double.tryParse(data['totalPrice'].toString()) ?? 0;
    }

    setState(() {
      totalOrders = ordersCount;
      totalRevenue = revenue;
      paymentMethods = paymentCount;
      monthlySales = salesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Sales Analytics'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalesSummary(),
              const SizedBox(height: 20),
              _buildBarChart(),
              const SizedBox(height: 20),
              _buildPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesSummary() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryTile("Total Revenue", "₱${totalRevenue.toStringAsFixed(2)}"),
          _summaryTile("Total Orders", totalOrders.toString()),
        ],
      ),
    );
  }

  Widget _summaryTile(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, _) => Text(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][value.toInt()], style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ),
          barGroups: List.generate(12, (index) => BarChartGroupData(x: index, barRods: [BarChartRodData(toY: monthlySales[index], color: Colors.green)])),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: paymentMethods["GCash"], color: Colors.blue, title: "GCash"),
            PieChartSectionData(value: paymentMethods["COD"], color: Colors.red, title: "COD"),
          ],
        ),
      ),
    );
  }
}
