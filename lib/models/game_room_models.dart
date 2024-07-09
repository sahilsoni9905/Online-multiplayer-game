class GameRoomModels {
  final String roomCode;
  final String user1;
  final String user1profilePic;
  final String user2profilePic;
  final String user2;
  String winner;
  String turn;
  final DateTime createdAt;
  List<String> gameIndex;

  GameRoomModels({
    required this.roomCode,
    required this.user1,
    required this.user1profilePic,
    required this.user2profilePic,
    required this.user2,
    this.winner = "",
    required this.turn,
    required this.createdAt,
    this.gameIndex = const ['', '', '', '', '', '', '', '', ''],
  });

  Map<String, dynamic> toMap() {
    return {
      'roomCode': roomCode,
      'user1': user1,
      'user1profilePic': user1profilePic,
      'user2profilePic': user2profilePic,
      'user2': user2,
      'winner': winner,
      'turn': turn,
      'createdAt': createdAt.toIso8601String(),
      'gameIndex': gameIndex,
    };
  }

  // Create a GameRoomModels instance from a map
  factory GameRoomModels.fromMap(Map<String, dynamic> map) {
    return GameRoomModels(
      roomCode: map['roomCode'] ?? '',
      user1: map['user1'] ?? '',
      user1profilePic: map['user1profilePic'],
      user2profilePic: map['user2profilePic'],
      user2: map['user2'] ?? '',
      winner: map['winner'] ?? '',
      turn: map['turn'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      gameIndex: List<String>.from(map['gameIndex'] ?? ['', '', '', '', '', '', '', '', '']),
    );
  }

  List<List<String>> getNestedGameIndex() {
    return [
      gameIndex.sublist(0, 3),
      gameIndex.sublist(3, 6),
      gameIndex.sublist(6, 9),
    ];
  }
}
