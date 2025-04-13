import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreService {
  final CollectionReference scores =
  FirebaseFirestore.instance.collection('leaderboard');

  Future<void> submitScore(String playerName, int score) {
    return scores.add({
      'player': playerName,
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTopScores() {
    return scores
        .orderBy('score', descending: true)
        .limit(10)
        .snapshots();
  }
}
