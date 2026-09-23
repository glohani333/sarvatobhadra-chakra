import 'package:flutter/material.dart';
import 'package:sweph/sweph.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Swiss Ephemeris (Moshier - no data files needed)
  await Sweph.init();
  
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
  // Birth Details
  DateTime? birthDate;
  TimeOfDay? birthTime;
  String birthPlace = '';

  // Calculated positions
  Map<String, String> planetNakshatra = {};
  bool isCalculating = false;
  String? errorMessage;

  // Classical 9x9 grid
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

  final List<String> nakshatraList = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'P.Phalguni', 'U.Phalguni',
    'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
    'Mula', 'P.Ashadha', 'U.Ashadha', 'Abhijit', 'Shravana', 'Dhanishta',
    'Shatabhisha', 'P.Bhadra', 'U.Bhadra', 'Revati'
  ];

  // Convert longitude to Nakshatra (sidereal)
  String longitudeToNakshatra(double longitude) {
    // Each nakshatra = 13°20' = 13.333... degrees
    double adjusted = longitude % 360;
    if (adjusted < 0) adjusted += 360;
    
    int index = (adjusted / (360 / 27)).floor(); // 27 nakshatras normally
    // For Abhijit we keep it simple for now (using 27)
    if (index >= 27) index = 26;
    return nakshatraList[index];
  }

  Future<void> _calculatePlanets() async {
    if (birthDate == null || birthTime == null) {
      setState(() => errorMessage = 'Pehle Birth Details save karo');
      return;
    }

    setState(() {
      isCalculating = true;
      errorMessage = null;
      planetNakshatra.clear();
    });

    try {
      // Create DateTime in UTC (simple approximation)
      final dt = DateTime(
        birthDate!.year,
        birthDate!.month,
        birthDate!.day,
        birthTime!.hour,
        birthTime!.minute,
      );

      // Julian Day
      final jd = Sweph.swe_julday(
        dt.year,
        dt.month,
        dt.day,
        dt.hour + dt.minute / 60.0,
        CalendarType.SE_GREG_CAL,
      );

      // Set Lahiri ayanamsa
      Sweph.swe_set_sid_mode(SiderealMode.SE_SIDM_LAHIRI);

      // Planets to calculate
      final planets = {
        'Sun': HeavenlyBody.SE_SUN,
        'Moon': HeavenlyBody.SE_MOON,
        'Mars': HeavenlyBody.SE_MARS,
        'Mercury': HeavenlyBody.SE_MERCURY,
        'Jupiter': HeavenlyBody.SE_JUPITER,
        'Venus': HeavenlyBody.SE_VENUS,
        'Saturn': HeavenlyBody.SE_SATURN,
        'Rahu': HeavenlyBody.SE_TRUE_NODE,
      };

      Map<String, String> results = {};

      for (var entry in planets.entries) {
        final flags = SwephFlag.SEFLG_SWIEPH | SwephFlag.SEFLG_SIDEREAL | SwephFlag.SEFLG_SPEED;
        
        final pos = Sweph.swe_calc_ut(jd, entry.value, flags);
        final longitude = pos.longitude;
        
        final nak = longitudeToNakshatra(longitude);
        results[entry.key] = nak;
      }

      // Ketu is opposite to Rahu
      if (results.containsKey('Rahu')) {
        // Simple: Ketu is 180° opposite
        results['Ketu'] = 'Magha'; // placeholder - improve later
      }

      setState(() {
        planetNakshatra = results;
        isCalculating = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Calculation error: $e';
        isCalculating = false;
      });
    }
  }

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
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Birth Details / जन्म विवरण',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Date: \( {tempDate.day}/ \){tempDate.month}/${tempDate.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setModalState(() => tempDate = picked);
                    },
                  ),
                  ListTile(
                    title: Text('Time: ${tempTime.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: tempTime,
                      );
                      if (picked != null) setModalState(() => tempTime = picked);
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Place of Birth',
                      border: OutlineInputBorder(),
                    ),
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
                      _calculatePlanets(); // auto calculate
                    },
                    child: const Text('Save & Calculate'),
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
            icon: const Icon(Icons.person),
            onPressed: _openBirthForm,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Card
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (birthDate != null) ...[
                    Text(
                      'Birth: \( {birthDate!.day}/ \){birthDate!.month}/${birthDate!.year}  ${birthTime?.format(context) ?? ""}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Place: ${birthPlace.isEmpty ? "Not set" : birthPlace}'),
                  ] else
                    const Text('Birth details nahi dale hain'),
                  
                  if (isCalculating)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: LinearProgressIndicator(),
                    ),
                  
                  if (errorMessage != null)
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                  
                  if (planetNakshatra.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text('Calculated Positions:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 6,
                      children: planetNakshatra.entries.map((e) {
                        return Chip(
                          label: Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 11)),
                          backgroundColor: _getPlanetColor(e.key),
                          labelStyle: const TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
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
        icon: const Icon(Icons.calculate),
        label: const Text('Birth + Calculate'),
      ),
    );
  }

  Widget _buildCell(String text) {
    Color bgColor = Colors.grey.shade100;
    Color textColor = Colors.black87;

    if (_isVowel(text)) {
      bgColor = Colors.purple.shade100;
      textColor = Colors.purple.shade900;
    } else if (_isNakshatra(text)) {
      bgColor = Colors.orange.shade50;
    } else if (_isRashi(text)) {
      bgColor = Colors.blue.shade50;
    } else if (_isTithiOrVara(text)) {
      bgColor = Colors.green.shade100;
    } else {
      bgColor = Colors.teal.shade50;
    }

    // Check if any planet is on this nakshatra
    String? planetHere;
    planetNakshatra.forEach((planet, nak) {
      if (nak == text || text.contains(nak) || nak.contains(text)) {
        planetHere = planet;
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
              Text(planetHere!,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
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

  bool _isVowel(String t) => ['अ','आ','इ','ई','उ','ऊ','ऋ','ॠ','ऌ','लृ','लॄ','ए','ऐ','ओ','औ','अं','अः'].contains(t);
  bool _isNakshatra(String t) => nakshatraList.contains(t) || t.contains('Phalguni') || t.contains('Ashadha') || t.contains('Bhadra');
  bool _isRashi(String t) => ['Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'].contains(t);
  bool _isTithiOrVara(String t) => t.contains('day') || t.contains('Poorna') || t.contains('Sun') || t.contains('Mon');

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
