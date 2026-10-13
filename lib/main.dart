
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const CareerApp());

const red = Color(0xFFD10A2C);
const dark = Color(0xFF151515);
const panel = Color(0xFF242424);

class CareerApp extends StatelessWidget {
  const CareerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسيرة لاعب الإفريقي',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: red,
          brightness: Brightness.dark,
        ),
      ),
      home: const CareerHome(),
    );
  }
}

class CareerHome extends StatefulWidget {
  const CareerHome({super.key});

  @override
  State<CareerHome> createState() => _CareerHomeState();
}

class _CareerHomeState extends State<CareerHome> {
  final nameController = TextEditingController(text: 'الزعلوني');

  final random = Random();

  String position = 'مهاجم';
  int shirtNumber = 105;

  int level = 1;
  int xp = 0;
  int energy = 100;

  int shooting = 55;
  int speed = 55;
  int passing = 50;

  int matches = 0;
  int goals = 0;
  int wins = 0;

  int caScore = 0;
  int opponentScore = 0;
  int minute = 0;

  bool matchActive = false;

  String message = 'مرحبا بك في مسيرة لاعب النادي الإفريقي!';

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void notify(String text) {
    setState(() => message = text);
  }

  void addXP(int amount) {
    xp += amount;

    while (xp >= level * 50) {
      xp -= level * 50;
      level++;
      message = '🎉 مبروك! وصلت إلى المستوى $level';
    }
  }

  void train(String skill) {
    if (matchActive) {
      notify('أكمل المباراة أولاً!');
      return;
    }

    if (energy < 15) {
      notify('طاقتك منخفضة! خذ قسطاً من الراحة.');
      return;
    }

    setState(() {
      energy -= 15;
      addXP(10);

      switch (skill) {
        case 'التسديد':
          shooting = min(99, shooting + 3);
          break;
        case 'السرعة':
          speed = min(99, speed + 3);
          break;
        case 'التمرير':
          passing = min(99, passing + 3);
          break;
      }

      if (!message.startsWith('🎉')) {
        message = '💪 تدريب $skill ناجح! استمر يا بطل.';
      }
    });
  }

  void rest() {
    if (matchActive) {
      notify('لا يمكنك الراحة أثناء المباراة!');
      return;
    }

    setState(() {
      energy = min(100, energy + 35);
      message = '🔋 استعدت طاقتك. هيا إلى الملعب!';
    });
  }

  void startMatch() {
    if (energy < 25) {
      notify('تحتاج إلى مزيد من الطاقة قبل المباراة.');
      return;
    }

    setState(() {
      caScore = 0;
      opponentScore = 0;
      minute = 0;
      matchActive = true;
      message = '📣 انطلقت المباراة! ديما النادي الإفريقي!';
    });
  }

  void playNextPeriod() {
    if (!matchActive) return;

    setState(() {
      minute = min(90, minute + 15);

      // فرصة اللاعب للتسجيل بناءً على مهاراته.
      final chance = random.nextInt(100);
      final playerChance = min(70, shooting ~/ 2 + speed ~/ 5);

      if (chance < playerChance) {
        caScore++;
        goals++;
        addXP(20);
        message = '⚽ غوووول! $playerName يسجل للإفريقي!';
      } else if (chance < playerChance + 20) {
        message = '🥅 تسديدة خطيرة! الحارس يتصدى.';
      } else {
        message = '🔥 واصل الضغط! فرصة جديدة قادمة.';
      }

      // محاولة عشوائية للمنافس.
      if (random.nextInt(100) < 18) {
        opponentScore++;
      }

      energy = max(0, energy - 7);

      if (minute >= 90) {
        matchActive = false;
        matches++;

        if (caScore > opponentScore) {
          wins++;
          addXP(30);
          message =
              '🏆 فوز النادي الإفريقي $caScore - $opponentScore! ❤️🤍';
        } else if (caScore == opponentScore) {
          addXP(10);
          message = '🤝 تعادل $caScore - $opponentScore. القادم أفضل!';
        } else {
          message =
              'انتهت المباراة $caScore - $opponentScore. تدرب وعد أقوى!';
        }
      }
    });
  }

  String get playerName {
    final name = nameController.text.trim();
    return name.isEmpty ? 'لاعب الإفريقي' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: red,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            '🔴⚪ مسيرة لاعب الإفريقي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              heroCard(),
              const SizedBox(height: 12),
              messageCard(),
              const SizedBox(height: 18),

              sectionTitle('👤 ملف اللاعب'),
              playerCard(),

              const SizedBox(height: 18),
              sectionTitle('💪 تطوير المهارات'),
              trainingCard(),

              const SizedBox(height: 18),
              sectionTitle('⚽ يوم المباراة'),
              matchCard(),

              const SizedBox(height: 18),
              sectionTitle('🏆 إحصائيات المسيرة'),
              statisticsCard(),

              const SizedBox(height: 22),
              const Center(
                child: Text(
                  'نسخة جماهيرية تجريبية ❤️🤍',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heroCard() {
    final requiredXP = level * 50;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [red, Color(0xFF760019)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('🦅', style: TextStyle(fontSize: 48)),
          const Text(
            'النادي الإفريقي',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const Text('من الأكاديمية إلى نجومية الفريق'),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              miniStat('المستوى', '$level'),
              miniStat('الخبرة', '$xp/$requiredXP'),
              miniStat('الطاقة', '$energy%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (xp / requiredXP).clamp(0.0, 1.0),
              minHeight: 8,
              color: Colors.white,
              backgroundColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget miniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget messageCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: red),
      ),
      child: Row(
        children: [
          const Text('📣', style: TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }

  Widget playerCard() {
    return card(
      Column(
        children: [
          TextField(
            controller: nameController,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: 'اسم اللاعب',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: position,
            decoration: const InputDecoration(
              labelText: 'مركز اللاعب',
              border: OutlineInputBorder(),
            ),
            items: const [
              'مهاجم',
              'وسط ميدان',
              'مدافع',
              'حارس مرمى',
            ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (value) {
              if (value != null) setState(() => position = value);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('رقم القميص')),
              IconButton(
                onPressed: () =>
                    setState(() => shirtNumber = max(1, shirtNumber - 1)),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$shirtNumber',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: red,
                ),
              ),
              IconButton(
                onPressed: () =>
                    setState(() => shirtNumber = min(99, shirtNumber + 1)),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🔴⚪ $playerName | #$shirtNumber | $position',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget trainingCard() {
    return card(
      Column(
        children: [
          skillRow('التسديد', shooting, Icons.sports_soccer),
          skillRow('السرعة', speed, Icons.bolt),
          skillRow('التمرير', passing, Icons.swap_horiz),
          const Divider(height: 25),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              actionButton(
                'تدريب التسديد',
                Icons.sports_soccer,
                () => train('التسديد'),
              ),
              actionButton(
                'تدريب السرعة',
                Icons.bolt,
                () => train('السرعة'),
              ),
              actionButton(
                'تدريب التمرير',
                Icons.swap_horiz,
                () => train('التمرير'),
              ),
              OutlinedButton.icon(
                onPressed: rest,
                icon: const Icon(Icons.hotel),
                label: const Text('استراحة'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget skillRow(String title, int value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, color: red),
          const SizedBox(width: 8),
          SizedBox(width: 78, child: Text(title)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 9,
                color: red,
                backgroundColor: Colors.white12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$value'),
        ],
      ),
    );
  }

  Widget actionButton(
    String title,
    IconData icon,
    VoidCallback action,
  ) {
    return FilledButton.icon(
      onPressed: action,
      icon: Icon(icon),
      label: Text(title),
      style: FilledButton.styleFrom(
        backgroundColor: red,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget matchCard() {
    return card(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(
                child: Column(
                  children: [
                    Text('🔴⚪', style: TextStyle(fontSize: 30)),
                    Text(
                      'النادي الإفريقي',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '$caScore - $opponentScore',
                    style: const TextStyle(
                      fontSize: 29,
                      color: red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(matchActive ? 'الدقيقة $minute' : 'مباراة تجريبية'),
                ],
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text('⚽', style: TextStyle(fontSize: 30)),
                    Text(
                      'المنافس',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              onPressed: matchActive ? playNextPeriod : startMatch,
              icon: Icon(
                matchActive ? Icons.sports_soccer : Icons.play_arrow,
              ),
              label: Text(
                matchActive ? 'العب 15 دقيقة' : 'ابدأ المباراة',
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'كل ضغطة تتقدم بالمباراة 15 دقيقة. '
            'النتائج عشوائية داخل اللعبة وليست حقيقية.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget statisticsCard() {
    return card(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          statItem('المباريات', matches, Icons.flag),
          statItem('الأهداف', goals, Icons.sports_soccer),
          statItem('الانتصارات', wins, Icons.emoji_events),
        ],
      ),
    );
  }

  Widget statItem(String title, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: red, size: 27),
        const SizedBox(height: 5),
        Text(
          '$value',
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        Text(title, style: const TextStyle(color: Colors.white60)),
      ],
    );
  }
}
