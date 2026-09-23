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
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String birthPlace = '';

  final List<List<String>> grid = [
    ['ई', 'Dhanishta', 'Shatabhisha', 'P.Bhadra', 'U.Bhadra', 'Revati', 'Ashwini', 'Bharani', 'अ'],
    ['Shravana', 'ऋ', 'ग', 'स', 'द', 'च', 'ल', 'उ', 'Krittika'],
    ['Abhijit', 'ख', 'ऐ', 'Aquarius', 'Pisces', 'Aries', 'लृ', 'अ', 'Rohini'],
    ['U.Ashadha', 'ज', 'Capricorn', 'अः', 'Friday', 'ओ', 'Taurus', 'व', 'Mrigashira'],
    ['P.Ashadha', 'भ', 'Sagittarius', 'Thursday', 'Saturday\nPoorna', 'Sun/Tue', 'Gemini', 'क', 'Ardra'],
    ['Mula', 'य', 'Scorpio', 'अं', 'Mon/Wed', 'औ', 'Cancer', 'ह', 'Punarvasu'],
    ['Jyeshtha', 'न', 'ए', 'Libra', 'Virgo', 'Leo', 'लॄ', 'ड', 'Pushya'],
    ['Anuradha', 'ऋ', 'त', 'र', 'प', 'ट', 'म', 'ऊ', 'Ashlesha'],
    ['इ', 'Vishakha', 'Swati', 'Chitra', 'Hasta', 'U.Phalguni', 'P.Phalguni', 'Magha', 'आ'],
  ];

  // Sample positions (baad mein real calculation add karenge)
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

  void _openBirthForm() {
    DateTime tempDate = birthDate ?? DateTime(1990, 5, 15);
    TimeOfDay tempTime = birthTime ?? const TimeOfDay(hour: 10, minute: 30);
    String tempPlace = birthPlace;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20, right: 20, top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Birth Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Date: \( {tempDate.day}/ \){tempDate.month}/${tempDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final p = await showDatePicker(context: context, initialDate: tempDate, firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (p != null) setModalState(() => tempDate = p);
                    },
                  ),
                  ListTile(
                    title: Text('Time: ${tempTime.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final p = await showTimePicker(context: context, initialTime: tempTime);
                      if (p != null) setModalState(() => tempTime = p);
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Place of Birth', border: OutlineInputBorder()),
                    controller: TextEditingController(text: tempPlace),
                    onChanged: (v) => tempPlace = v,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        birthDate = tempDate;
                        birthTime = tempTime;
                        birthPlace = tempPlace;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सर्वतोभद्र चक्र'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: _openBirthForm),
        ],
      ),
      body: Column(
        children: [
          if (birthDate != null)
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Birth: \( {birthDate!.day}/ \){birthDate!.month}/${birthDate!.year}  ${birthTime?.format(context)} | $birthPlace',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
                  return _buildCell(grid[row][col]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBirthForm,
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.edit),
        label: const Text('Birth Details'),
      ),
    );
  }

  Widget _buildCell(String text) {
    Color bgColor = Colors.grey.shade100;
    Color textColor = Colors.black87;

    if (['अ','आ','इ','ई','उ','ऊ','ऋ','ॠ','ऌ','लृ','लॄ','ए','ऐ','ओ','औ','अं','अः'].contains(text)) {
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade900;
    } else if (text.contains('Phalguni') || text.contains('Ashadha') || text.contains('Bhadra') || 
               ['Ashwini','Bharani','Krittika','Rohini','Mrigashira','Ardra','Punarvasu','Pushya','Ashlesha','Magha','Hasta','Chitra','Swati','Vishakha','Anuradha','Jyeshtha','Mula','Abhijit','Shravana','Dhanishta','Shatabhisha','Revati'].contains(text)) {
      bgColor = Colors.orange.shade50;
    } else if (['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'].contains(text)) {
      bgColor = Colors.blue.shade50;
    } else if (text.contains('day') || text.contains('Poorna') || text.contains('Sun') || text.contains('Mon')) {
      bgColor = Colors.green.shade100;
    } else {
      bgColor = Colors.teal.shade50;
    }

    String? planet = planetOnNakshatra[text];
    if (planet != null) {
      bgColor = _getPlanetColor(planet);
      textColor = Colors.white;
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
              Text(planet, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(text, style: TextStyle(fontSize: text.length > 8 ? 7.5 : 9, color: textColor),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Color _getPlanetColor(String p) {
    switch (p) {
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
