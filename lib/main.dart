import 'package:flutter/material.dart';
import 'package:utip/widgets/bill_amount_field.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_row.dart';
import 'package:utip/widgets/tip_slider.dart';
import 'package:utip/widgets/total_per_person.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() => _mode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTip',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,

      // Light theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: const CardThemeData(
          elevation: 4,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),

      // Dark theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),

      home: UTip(isDark: _mode == ThemeMode.dark, onToggleTheme: _toggleTheme),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key, required this.isDark, required this.onToggleTheme});
  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  int _personCount = 1;
  double _tipPercentage = 0.0;
  double _billTotal = 0.0;

  double totalPerPerson() =>
      (_billTotal + _billTotal * _tipPercentage) / _personCount;

  double totalTip() => _billTotal * _tipPercentage;

  void incrementPerson() => setState(() => _personCount++);
  void decrementPerson() {
    if (_personCount > 1) setState(() => _personCount--);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = totalPerPerson();
    final totalT = totalTip();

    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: const Text('UTip'),
        backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
          Switch(value: widget.isDark, onChanged: widget.onToggleTheme),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/img1.png', fit: BoxFit.cover),

          // Light overlay
          Container(color: Colors.white.withOpacity(0.05)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Semi-transparent top card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TotalPerPerson(
                      theme: theme,
                      style: style,
                      total: total,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.6),
                          width: 2,
                        ),
                        color: theme.colorScheme.surface.withOpacity(0.78),
                      ),
                      child: Column(
                        children: [
                          BillAmountField(
                            billAmont: _billTotal.toStringAsFixed(2),
                            onChanged: (value) {
                              setState(() {
                                _billTotal = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          PersonCounter(
                            theme: theme,
                            personCount: _personCount,
                            onIcrement: incrementPerson,
                            onDecrement: decrementPerson,
                          ),
                          const SizedBox(height: 8),
                          TipRow(theme: theme, totalT: totalT, style: style),
                          Text('${(_tipPercentage * 100).round()}%'),
                          TipSlider(
                            tipPercentage: _tipPercentage,
                            onChanged: (value) {
                              setState(() => _tipPercentage = value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
