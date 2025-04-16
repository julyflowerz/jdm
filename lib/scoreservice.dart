// Firestore package for accessing the database
import 'package:cloud_firestore/cloud_firestore.dart';

// This service handles saving and retrieving high scores from Firestore
class ScoreService {
  // Reference to the 'leaderboard' collection in Firestore
  final CollectionReference scores =
  FirebaseFirestore.instance.collection('leaderboard');

  // Save a new score to the leaderboard
  Future<void> submitScore(String playerName, int score) {
    return scores.add({
      'player': playerName,                       // Player name or ID
      'score': score,                             // Score value
      'timestamp': FieldValue.serverTimestamp(),  // Save current time (useful for sorting later)
    });
  }

  // Get a stream of the top 10 scores, sorted highest first
  Stream<QuerySnapshot> getTopScores() {
    return scores
        .orderBy('score', descending: true) // Sort by score, highest first
        .limit(10)                          // Only return top 10 entries
        .snapshots();                       // Return a real-time stream
  }

  // (Optional) Fetch scores for a specific player
  Stream<QuerySnapshot> getPlayerHistory(String playerName) {
    return scores
        .where('player', isEqualTo: playerName)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
