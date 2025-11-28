import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TennisScoreKeeper extends ConsumerStatefulWidget {
  const TennisScoreKeeper({super.key});

  @override
  ConsumerState<TennisScoreKeeper> createState() => _TennisScoreKeeperState();
}

class _TennisScoreKeeperState extends ConsumerState<TennisScoreKeeper> {
  int _p1Points = 0;
  int _p2Points = 0;
  
  int _p1Games = 0;
  int _p2Games = 0;
  
  int _p1Sets = 0;
  int _p2Sets = 0;

  String _getScore(int points, int opponentPoints) {
    if (points >= 3 && opponentPoints >= 3) {
      if (points == opponentPoints) return 'Deuce';
      if (points == opponentPoints + 1) return 'Adv';
      if (points > opponentPoints + 1) return 'Game'; // Should be handled in logic
      return '';
    }
    switch (points) {
      case 0: return 'Love';
      case 1: return '15';
      case 2: return '30';
      case 3: return '40';
      default: return '';
    }
  }

  void _addPoint(int player) {
    setState(() {
      if (player == 1) {
        _p1Points++;
      } else {
        _p2Points++;
      }
      _checkGame();
    });
  }

  void _checkGame() {
    if (_p1Points >= 4 && _p1Points >= _p2Points + 2) {
      _winGame(1);
    } else if (_p2Points >= 4 && _p2Points >= _p1Points + 2) {
      _winGame(2);
    }
  }

  void _winGame(int player) {
    _p1Points = 0;
    _p2Points = 0;
    if (player == 1) {
      _p1Games++;
    } else {
      _p2Games++;
    }
    _checkSet();
  }

  void _checkSet() {
    if (_p1Games >= 6 && _p1Games >= _p2Games + 2) {
      _winSet(1);
    } else if (_p2Games >= 6 && _p2Games >= _p1Games + 2) {
      _winSet(2);
    }
  }

  void _winSet(int player) {
    _p1Games = 0;
    _p2Games = 0;
    if (player == 1) {
      _p1Sets++;
    } else {
      _p2Sets++;
    }
  }

  void _reset() {
    setState(() {
      _p1Points = 0; _p2Points = 0;
      _p1Games = 0; _p2Games = 0;
      _p1Sets = 0; _p2Sets = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String p1Score = _getScore(_p1Points, _p2Points);
    String p2Score = _getScore(_p2Points, _p1Points);

    if (p1Score == 'Adv') p2Score = '';
    if (p2Score == 'Adv') p1Score = '';
    if (p1Score == 'Deuce') p2Score = 'Deuce';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tennis Score Keeper'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlayerRow('Player 1', _p1Sets, _p1Games, p1Score, () => _addPoint(1)),
            const Divider(height: 32),
            _buildPlayerRow('Player 2', _p2Sets, _p2Games, p2Score, () => _addPoint(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(String name, int sets, int games, String score, VoidCallback onPoint) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Sets: $sets  Games: $games', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            score,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          onPressed: onPoint,
          child: const Text('Point'),
        ),
      ],
    );
  }
}
