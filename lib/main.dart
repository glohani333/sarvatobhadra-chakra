import 'package:flutter/material.dart';

void main() {
  runApp(const SarvatobhadraApp());
}

class SarvatobhadraApp extends StatelessWidget {
  const SarvatobhadraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sarvatobhadra Chakra',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const ChakraScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChakraScreen extends StatefulWidget {
  const ChakraScreen({super.key});

  @override
  State<ChakraScreen> createState() => _ChakraScreenState();
}

class _ChakraScreenState extends State<ChakraScreen> {
  final List<String> nakshatras = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira',
    'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha',
    'Purva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati',
    'Vishakha', 'Anuradha', 'Jyeshtha', 'Mula', 'Purva Ashadha',
    'Uttara Ashadha', 'Abhijit', 'Shravana', 'Dhanishta', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
  ];

  final Map<String, int> planetPositions = {
    'Sun': 11,
    'Moon': 23,
    'Mars': 6,
    'Mercury': 13,
    'Jupiter': 8,
    'Venus': 14,
    'Saturn': 27,
    'Rahu': 23,
    'Ketu': 9,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सर्वतोभद्र चक्र'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sample Transit Positions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: planetPositions.entries.map((e) {
                      return Chip(
                        label: Text('${e.key}: ${nakshatras[e.value]}',
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: _getPlanetColor(e.key),
                        labelStyle: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  childAspectRatio: 1,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                ),
                itemCount: 81,
                itemBuilder: (context, index) => _buildCell(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    int row = index ~/ 9;
    int col = index % 9;

    String? label;
    Color bgColor = Colors.grey.shade100;

    if (row == 0) {
      label = nakshatras[col % 28];
      bgColor = Colors.orange.shade50;
    } else if (row == 8) {
      label = nakshatras[(col + 7) % 28];
      bgColor = Colors.orange.shade50;
    } else if (col == 0) {
      label = nakshatras[(row + 14) % 28];
      bgColor = Colors.orange.shade50;
    } else if (col == 8) {
      label = nakshatras[(row + 21) % 28];
      bgColor = Colors.orange.shade50;
    } else if (row == 4 && col == 4) {
      label = 'Poorna';
      bgColor = Colors.deepOrange.shade300;
    }

    String? planetHere;
    planetPositions.forEach((planet, nakIndex) {
      if (label == nakshatras[nakIndex]) {
        planetHere = planet;
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: planetHere != null ? _getPlanetColor(planetHere!) : bgColor,
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (planetHere != null)
              Text(
                planetHere!,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            Text(
              label ?? '',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: planetHere != null ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPlanetColor(String planet) {
    switch (planet) {
      case 'Sun': return Colors.orange.shade700;
      case 'Moon': return Colors.blueGrey;
      case 'Mars': return Colors.red.shade700;
      case 'Mercury': return Colors.green.shade600;
      case 'Jupiter': return Colors.amber.shade800;
      case 'Venus': return Colors.pink.shade400;
      case 'Saturn': return Colors.brown.shade600;
      case 'Rahu': return Colors.purple.shade700;
      case 'Ketu': return Colors.deepPurple.shade900;
      default: return Colors.grey;
    }
  }
}
