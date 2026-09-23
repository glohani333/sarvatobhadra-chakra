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
  // Classical 9x9 layout (based on standard sources)
  // Top row = North, Right side = East (common modern display)
  final List<List<String>> grid = [
    // Row 0 (Top / North)
    ['ई', 'Dhanishta', 'Shatabhisha', 'P.Bhadra', 'U.Bhadra', 'Revati', 'Ashwini', 'Bharani', 'अ'],
    // Row 1
    ['Shravana', 'ऋ', 'ग', 'स', 'द', 'च', 'ल', 'उ', 'Krittika'],
    // Row 2
    ['Abhijit', 'ख', 'ऐ', 'Aquarius', 'Pisces', 'Aries', 'लृ', 'अ', 'Rohini'],
    // Row 3
    ['U.Ashadha', 'ज', 'Capricorn', 'अः', 'Friday', 'ओ', 'Taurus', 'व', 'Mrigashira'],
    // Row 4 (Middle)
    ['P.Ashadha', 'भ', 'Sagittarius', 'Thursday', 'Saturday\nPoorna', 'Sun/Tue', 'Gemini', 'क', 'Ardra'],
    // Row 5
    ['Mula', 'य', 'Scorpio', 'अं', 'Mon/Wed', 'औ', 'Cancer', 'ह', 'Punarvasu'],
    // Row 6
    ['Jyeshtha', 'न', 'ए', 'Libra', 'Virgo', 'Leo', 'लॄ', 'ड', 'Pushya'],
    // Row 7
    ['Anuradha', 'ऋ', 'त', 'र', 'प', 'ट', 'म', 'ऊ', 'Ashlesha'],
    // Row 8 (Bottom / South)
    ['इ', 'Vishakha', 'Swati', 'Chitra', 'Hasta', 'U.Phalguni', 'P.Phalguni', 'Magha', 'आ'],
  ];

  // Sample planet positions (nakshatra name → planet)
  final Map<String, String> planetOnNakshatra = {
    'U.Phalguni': 'Sun',
    'Dhanishta': 'Moon',
    'Punarvasu': 'Mars',
    'Chitra': 'Mercury',
    'Ashlesha': 'Jupiter',
    'Swati': 'Venus',
    'Revati': 'Saturn',
    'Magha': 'Ketu',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सर्वतोभद्र चक्र (Classical)'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade100,
            child: const Wrap(
              spacing: 12,
              children: [
                LegendItem(color: Colors.orange, label: 'Nakshatra'),
                LegendItem(color: Colors.purple, label: 'Vowel'),
                LegendItem(color: Colors.teal, label: 'Consonant'),
                LegendItem(color: Colors.blue, label: 'Rashi'),
                LegendItem(color: Colors.green, label: 'Tithi/Vara'),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  childAspectRatio: 1,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 1.5,
                ),
                itemCount: 81,
                itemBuilder: (context, index) {
                  int row = index ~/ 9;
                  int col = index % 9;
                  String cell = grid[row][col];
                  return _buildCell(cell);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text) {
    Color bgColor = Colors.grey.shade100;
    Color textColor = Colors.black87;
    FontWeight weight = FontWeight.w500;

    // Detect type
    if (_isVowel(text)) {
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade900;
      weight = FontWeight.bold;
    } else if (_isNakshatra(text)) {
      bgColor = Colors.orange.shade50;
    } else if (_isRashi(text)) {
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade900;
    } else if (_isTithiOrVara(text)) {
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
      weight = FontWeight.bold;
    } else {
      // Consonant
      bgColor = Colors.teal.shade50;
      textColor = Colors.teal.shade900;
    }

    // Planet check
    String? planet = planetOnNakshatra[text];
    if (planet != null) {
      bgColor = _getPlanetColor(planet);
      textColor = Colors.white;
      weight = FontWeight.bold;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey.shade400, width: 0.6),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (planet != null)
              Text(
                planet,
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: text.length > 8 ? 7.5 : 9,
                fontWeight: weight,
                color: textColor,
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

  bool _isVowel(String t) {
    const vowels = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ऋ', 'ॠ', 'ऌ', 'लृ', 'लॄ', 'ए', 'ऐ', 'ओ', 'औ', 'अं', 'अः'];
    return vowels.contains(t);
  }

  bool _isNakshatra(String t) {
    const naks = [
      'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
      'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'P.Phalguni', 'U.Phalguni',
      'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
      'Mula', 'P.Ashadha', 'U.Ashadha', 'Abhijit', 'Shravana', 'Dhanishta',
      'Shatabhisha', 'P.Bhadra', 'U.Bhadra', 'Revati'
    ];
    return naks.contains(t);
  }

  bool _isRashi(String t) {
    const rashis = [
      'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
      'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
    ];
    return rashis.contains(t);
  }

  bool _isTithiOrVara(String t) {
    return t.contains('day') || t.contains('Poorna') || t.contains('Sun') || t.contains('Mon');
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

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
