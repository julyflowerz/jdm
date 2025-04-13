import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'scoreservice.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏁 Leaderboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: ScoreService().getTopScores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No scores yet!'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final player = data['player'] ?? 'Unknown';
              final score = data['score'] ?? 0;

              return ListTile(
                leading: Text('#${index + 1}'),
                title: Text(player.toString()),
                trailing: Text(score.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
