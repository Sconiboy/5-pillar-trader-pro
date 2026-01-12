import 'package:flutter/material.dart';

void main() {
  runApp(const PillarTraderPro());
}

class PillarTraderPro extends StatelessWidget {
  const PillarTraderPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        primaryColor: const Color(0xFF00FF41),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Inter', color: Colors.white70),
          displaySmall: TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.bold),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// --- DATA MODEL UPDATED WITH SAFETY & HISTORY ---
enum Catalyst { strong, moderate, weak }

class Stock {
  final String symbol;
  final double price;
  final double changePercent;
  final double float;
  final double rVol;
  final String riskReward;
  final Catalyst catalyst;
  
  // New "Safety" & "History" Layers
  final bool hasOptions;
  final int ninetyDayRunners; // Frequency of 20% moves
  final bool isAboveVWAP;
  final bool isAtATH;
  final String currentSetup;

  Stock({
    required this.symbol, required this.price, required this.changePercent,
    required this.float, required this.rVol, required this.riskReward,
    required this.catalyst, required this.hasOptions, required this.ninetyDayRunners,
    required this.isAboveVWAP, required this.isAtATH, required this.currentSetup,
  });

  // BH Score: 0-100 based on history of runners
  int get bhScore => (ninetyDayRunners * 20).clamp(0, 100);

  String get grade {
    if (float > 100) return "C";
    if (catalyst == Catalyst.strong && float < 10 && rVol > 3.0) return "A";
    if (catalyst == Catalyst.moderate && float <= 50 && rVol >= 1.5) return "B";
    return "C";
  }
}

// --- DASHBOARD SCREEN ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Stock> watchList = [
      // THE PERFECT GRADE A
      Stock(
        symbol: "NVDX", price: 42.10, changePercent: 18.5, float: 8.5, rVol: 5.2, 
        riskReward: "4:1", catalyst: Catalyst.strong, hasOptions: true, 
        ninetyDayRunners: 5, isAboveVWAP: true, isAtATH: true, currentSetup: "ABCD Pattern"
      ),
      // THE TRAP
      Stock(
        symbol: "TRAP", price: 2.10, changePercent: 4.2, float: 120.0, rVol: 0.8, 
        riskReward: "1:2", catalyst: Catalyst.weak, hasOptions: false, 
        ninetyDayRunners: 0, isAboveVWAP: false, isAtATH: false, currentSetup: "No Setup"
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: const Text("PILLAR TRADER PRO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView.builder(
        itemCount: watchList.length,
        itemBuilder: (context, index) => StockTile(stock: watchList[index]),
      ),
    );
  }
}

// --- UPDATED UI TILE ---
class StockTile extends StatelessWidget {
  final Stock stock;
  const StockTile({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StockDetailScreen(stock: stock))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(stock.symbol, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if (stock.hasOptions) const _OptBadge(),
                    ],
                  ),
                  Text("\$${stock.price}", style: const TextStyle(fontFamily: 'RobotoMono', color: Colors.grey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text("BH: ${stock.bhScore}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 10),
                    _GradeBadge(grade: stock.grade),
                  ],
                ),
                const SizedBox(height: 8),
                Text("${stock.changePercent}%", style: TextStyle(color: stock.changePercent > 0 ? const Color(0xFF00FF41) : Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW STOCK DETAIL SCREEN ---
class StockDetailScreen extends StatelessWidget {
  final Stock stock;
  const StockDetailScreen({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${stock.symbol} Analysis"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Technical Edge
            _sectionHeader("TECHNICAL EDGE"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _detailRow("VWAP Status", stock.isAboveVWAP ? "ABOVE" : "BELOW", stock.isAboveVWAP ? const Color(0xFF00FF41) : Colors.red),
                  _detailRow("Pattern", stock.currentSetup, Colors.white),
                  if (stock.isAtATH) const Center(child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _BlueSkyBadge(),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section 2: Bag Holder Analysis
            _sectionHeader("BAG HOLDER ANALYSIS"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _detailRow("90D Runners (20%+)", "${stock.ninetyDayRunners}", Colors.white),
                  _detailRow("BH Score", "${stock.bhScore}/100", Colors.amber),
                  const Divider(color: Colors.white10),
                  Text(stock.bhScore > 50 ? "STRONG HISTORY: This stock has a memory of running." : "WARNING: Low historical follow-through.", 
                       style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _detailRow(String label, String value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: valColor, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono')),
        ],
      ),
    );
  }
}

// --- MINI COMPONENTS ---

class _OptBadge extends StatelessWidget {
  const _OptBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), border: Border.all(color: Colors.blueAccent), borderRadius: BorderRadius.circular(4)),
      child: const Text("OPT", style: TextStyle(fontSize: 8, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
    );
  }
}

class _BlueSkyBadge extends StatelessWidget {
  const _BlueSkyBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wb_sunny, color: Colors.amber, size: 14),
          SizedBox(width: 6),
          Text("BLUE SKY (ATH)", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  final String grade;
  const _GradeBadge({required this.grade});
  @override
  Widget build(BuildContext context) {
    Color color = grade == "A" ? const Color(0xFF00FF41) : (grade == "B" ? Colors.orange : Colors.red);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(4)),
      child: Text(grade, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
