import 'package:flutter/material.dart';
// Firestore: used to stream real-time leaderboard data
import 'package:cloud_firestore/cloud_firestore.dart';
// Your custom score-fetching logic
import 'scoreservice.dart';

// This screen shows a live leaderboard of top scores from Firebase
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏁 Leaderboard'), // Top app bar title
      ),

      // StreamBuilder allows live updates from Firebase
      body: StreamBuilder<QuerySnapshot>(
        stream: ScoreService().getTopScores(), // Get top scores from Firestore
        builder: (context, snapshot) {
          // Show loading spinner if data is still being fetched
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs; // List of Firestore documents

          // If the collection is empty
          if (docs.isEmpty) {
            return const Center(child: Text('No scores yet!'));
          }

          // Display leaderboard list
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Parse the Firestore document into a map
              final data = docs[index].data() as Map<String, dynamic>;

              // Get player name and score, or fallback to default values
              final player = data['player'] ?? 'Unknown';
              final score = data['score'] ?? 0;

              // Render a row in the leaderboard
              return ListTile(
                leading: Text('#${index + 1}'),         // Position number
                title: Text(player.toString()),         // Player name
                trailing: Text(score.toString()),       // Score value
              );
            },
          );
        },
      ),
    );
  }
}
