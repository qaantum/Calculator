import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BirthdayCalculator extends ConsumerStatefulWidget {
  const BirthdayCalculator({super.key});

  @override
  ConsumerState<BirthdayCalculator> createState() => _BirthdayCalculatorState();
}

class _BirthdayCalculatorState extends ConsumerState<BirthdayCalculator> {
  DateTime? _birthDate;

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  Map<String, dynamic> _calculateInfo() {
    if (_birthDate == null) return {};
    
    final now = DateTime.now();
    final age = now.year - _birthDate!.year - 
        (now.month < _birthDate!.month || 
        (now.month == _birthDate!.month && now.day < _birthDate!.day) ? 1 : 0);
    
    final nextBirthday = DateTime(
      now.year,
      _birthDate!.month,
      _birthDate!.day,
    );
    final nextBirthdayDate = nextBirthday.isBefore(now) 
        ? DateTime(now.year + 1, _birthDate!.month, _birthDate!.day)
        : nextBirthday;
    
    final daysUntil = nextBirthdayDate.difference(now).inDays;
    final totalDays = now.difference(_birthDate!).inDays;
    final totalWeeks = (totalDays / 7).floor();
    final totalMonths = (now.year - _birthDate!.year) * 12 + now.month - _birthDate!.month;
    final totalHours = now.difference(_birthDate!).inHours;
    
    return {
      'age': age,
      'dayOfWeek': _getDayOfWeek(_birthDate!.weekday),
      'zodiac': _getZodiacSign(_birthDate!.month, _birthDate!.day),
      'chineseZodiac': _getChineseZodiac(_birthDate!.year),
      'daysUntilBirthday': daysUntil,
      'totalDays': totalDays,
      'totalWeeks': totalWeeks,
      'totalMonths': totalMonths,
      'totalHours': totalHours,
      'birthstone': _getBirthstone(_birthDate!.month),
      'nextBirthday': nextBirthdayDate,
    };
  }

  String _getDayOfWeek(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }

  String _getZodiacSign(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return '♈ Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return '♉ Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return '♊ Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return '♋ Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return '♌ Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return '♍ Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return '♎ Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return '♏ Scorpio';
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return '♐ Sagittarius';
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return '♑ Capricorn';
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return '♒ Aquarius';
    return '♓ Pisces';
  }

  String _getChineseZodiac(int year) {
    const animals = ['Rat 🐀', 'Ox 🐂', 'Tiger 🐅', 'Rabbit 🐇', 'Dragon 🐉', 'Snake 🐍',
                     'Horse 🐎', 'Goat 🐐', 'Monkey 🐒', 'Rooster 🐓', 'Dog 🐕', 'Pig 🐖'];
    return animals[(year - 1900) % 12];
  }

  String _getBirthstone(int month) {
    const stones = ['Garnet', 'Amethyst', 'Aquamarine', 'Diamond', 'Emerald', 'Pearl',
                    'Ruby', 'Peridot', 'Sapphire', 'Opal', 'Topaz', 'Turquoise'];
    return stones[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final info = _calculateInfo();

    return Scaffold(
      appBar: AppBar(title: const Text('Birthday Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Discover interesting facts about your birthday.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_birthDate == null
                  ? 'Select Your Birthday'
                  : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'),
              subtitle: const Text('Tap to select date'),
              trailing: const Icon(Icons.cake),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            if (info.isNotEmpty) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('🎂', style: TextStyle(fontSize: 40)),
                      Text(
                        'You are ${info['age']} years old',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${info['daysUntilBirthday']} days until your next birthday!',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard('📅 You were born on', info['dayOfWeek']),
              _buildInfoCard('⭐ Zodiac Sign', info['zodiac']),
              _buildInfoCard('🐲 Chinese Zodiac', info['chineseZodiac']),
              _buildInfoCard('💎 Birthstone', info['birthstone']),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time Alive:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('• ${_formatNumber(info['totalDays'])} days'),
                      Text('• ${_formatNumber(info['totalWeeks'])} weeks'),
                      Text('• ${_formatNumber(info['totalMonths'])} months'),
                      Text('• ${_formatNumber(info['totalHours'])} hours'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  String _formatNumber(int? num) => num?.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},') ?? '0';
}
