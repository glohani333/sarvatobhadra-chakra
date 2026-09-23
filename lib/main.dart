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
  double latitude = 28.6139;
  double longitude = 77.2090;
  double timezoneOffset = 5.5;
  bool showVedha = true;

  Map<String, String> planetNakshatra = {
    'Sun': 'U.Phalguni',
    'Moon': 'Dhanishta',
    'Mars': 'Punarvasu',
    'Mercury': 'Chitra',
    'Jupiter': 'Ashlesha',
    'Venus': 'Swati',
    'Saturn': 'Revati',
    'Rahu': 'Dhanishta',
    'Ketu': 'Magha',
  };

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

  (int, int)? findNakshatraPosition(String nak) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (grid[r][c] == nak || grid[r][c].contains(nak) || nak.contains(grid[r][c])) {
          return (r, c);
        }
      }
    }
    return null;
  }

  void _openBirthForm() {
    DateTime tempDate = birthDate ?? DateTime(1990, 5, 15);
    TimeOfDay tempTime = birthTime ?? const TimeOfDay(hour: 10, minute: 30);
    String tempPlace = birthPlace;
    double tempLat = latitude;
    double tempLon = longitude;
    double tempTz = timezoneOffset;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
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
                      final p = await showDatePicker(
                        context: context,
                        initialDate: tempDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
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
                    decoration: const InputDecoration(labelText: 'Place Name', border: OutlineInputBorder()),
                    controller: TextEditingController(text: tempPlace),
                    onChanged: (v) => tempPlace = v,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Latitude', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: tempLat.toString()),
                          onChanged: (v) => tempLat = double.tryParse(v) ?? tempLat,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Longitude', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: tempLon.toString()),
                          onChanged: (v) => tempLon = double.tryParse(v) ?? tempLon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Timezone Offset (e.g. 5.5)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: tempTz.toString()),
                    onChanged: (v) => tempTz = double.tryParse(v) ?? tempTz,
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
                        latitude = tempLat;
                        longitude = tempLon;
                        timezoneOffset = tempTz;
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
          IconButton(
            icon: Icon(showVedha ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => showVedha = !showVedha),
          ),
          IconButton(icon: const Icon(Icons.person), onPressed: _openBirthForm),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (birthDate != null)
                    Text(
                      'Birth: \( {birthDate!.day}/ \){birthDate!.month}/${birthDate!.year} ${birthTime?.format(context)} | TZ: $timezoneOffset',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    children: planetNakshatra.entries.map((e) {
                      return Chip(
                        label: Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: _getPlanetColor(e.key),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cellSize = constraints.maxWidth / 9;
                  return Stack(
                    children: [
                      GridView.builder(
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
                      if (showVedha)
                        CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxWidth),
                          painter: VedhaPainter(
                            planetNakshatra: planetNakshatra,
                            findPosition: findNakshatraPosition,
                            cellSize: cellSize,
                          ),
                        ),
                    ],
                  );
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

    if (['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ', 'ऋ', 'ॠ', 'ऌ', 'लृ', 'लॄ', 'ए', 'ऐ', 'ओ', 'औ', 'अं', 'अः'].contains(text)) {
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade900;
    } else if (text.contains('Phalguni') || text.contains('Ashadha') || text.contains('Bhadra') ||
        ['Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha', 'Mula', 'Abhijit', 'Shravana', 'Dhanishta', 'Shatabhisha', 'Revati'].contains(text)) {
      bgColor = Colors.orange.shade50;
    } else if (['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'].contains(text)) {
      bgColor = Colors.blue.shade50;
    } else if (text.contains('day') || text.contains('Poorna') || text.contains('Sun') || text.contains('Mon')) {
      bgColor = Colors.green.shade100;
    } else {
      bgColor = Colors.teal.shade50;
    }

    String? planetHere;
    planetNakshatra.forEach((p, nak) {
      if (nak == text || text.contains(nak) || nak.contains(text)) {
        planetHere = p;
      }
    });

    if (planetHere != null) {
      bgColor = _getPlanetColor(planetHere!);
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
            if (planetHere != null)
              Text(planetHere!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(
              text,
              style: TextStyle(fontSize: text.length > 8 ? 7.5 : 9, color: textColor),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
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

class VedhaPainter extends CustomPainter {
  final Map<String, String> planetNakshatra;
  final (int, int)? Function(String) findPosition;
  final double cellSize;

  VedhaPainter({
    required this.planetNakshatra,
    required this.findPosition,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintAcross = Paint()
      ..color = Colors.red.withOpacity(0.55)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final paintFore = Paint()
      ..color = Colors.blue.withOpacity(0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final paintHind = Paint()
      ..color = Colors.green.withOpacity(0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    planetNakshatra.forEach((planet, nak) {
      final pos = findPosition(nak);
      if (pos == null) return;

      final r = pos.$1;
      final c = pos.$2;
      final center = Offset((c + 0.5) * cellSize, (r + 0.5) * cellSize);

      // Across (opposite)
      final oppCenter = Offset(((8 - c) + 0.5) * cellSize, ((8 - r) + 0.5) * cellSize);
      canvas.drawLine(center, oppCenter, paintAcross);

      // Fore
      if (c + 1 < 9 && r - 1 >= 0) {
        final fore = Offset((c + 1.5) * cellSize, (r - 0.5) * cellSize);
        canvas.drawLine(center, fore, paintFore);
      }

      // Hind
      if (c - 1 >= 0 && r + 1 < 9) {
        final hind = Offset((c - 0.5) * cellSize, (r + 1.5) * cellSize);
        canvas.drawLine(center, hind, paintHind);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
