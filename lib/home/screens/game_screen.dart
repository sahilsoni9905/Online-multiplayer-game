import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_app_project/home/widgets/board.dart';
import 'package:mega_app_project/home/widgets/congrats_dialogue.dart';
import 'package:mega_app_project/models/game_room_models.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = 'game-screen';

  GameScreen({
    super.key,
    required this.gameCode
  });
  String gameCode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final String documentId = 'abc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('games')
            .doc(widget.gameCode)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Document does not exist'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          GameRoomModels gameData = GameRoomModels.fromMap(data);
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(21, 0, 31, 1),
                        Color.fromRGBO(66, 1, 51, 1),
                        Color.fromRGBO(32, 1, 47, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 0.75, 0.9],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      gameData.user2 == ''
                          ? const SizedBox(
                              height: 20,
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 31, 203, 37),
                                  radius: 10,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Both User connected')
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      gameData.winner == '' ? const SizedBox(height: 2,) : CongratsDialog(name: gameData.winner, imageUrl: gameData.winner == gameData.user1 ? gameData.user1profilePic : gameData.user2profilePic),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: gameData.turn == gameData.user1
                                        ? Colors.green
                                        : Colors.transparent,
                                    width: 3.0, // border width
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(gameData.user1profilePic!),
                                  radius: 45,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                gameData.user1,
                                style: const TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Vs',
                            style: GoogleFonts.patrickHand(fontSize: 35),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: gameData.turn == gameData.user2
                                        ? Colors.green
                                        : Colors.transparent, // border color
                                    width: 3.0, // border width
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(gameData.user2profilePic!),
                                  radius: 45,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              gameData.user2 == ''
                                  ? const Text('Offline')
                                  : Text(
                                      (gameData.user2),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Turn :',
                            style:
                                TextStyle(fontSize: 20, color: Colors.orange),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            gameData.turn,
                            style: const TextStyle(
                                shadows: [
                                  Shadow(color: Colors.green, blurRadius: 10)
                                ],
                                fontSize: 30,
                                color: Color.fromARGB(255, 91, 131, 64)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TicTacToeBoard(
                          userTurn: gameData.turn,
                          snap: snapshot,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
