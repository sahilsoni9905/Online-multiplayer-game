import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/home/screens/game_screen.dart';
import 'package:mega_app_project/models/game_room_models.dart';
import 'package:mega_app_project/models/users_models.dart';
import 'package:mega_app_project/utils.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(ref: ref),
);
final userDataAuthProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getCurrentUserData();
});

class HomeRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProviderRef ref;

  HomeRepository({required this.ref});

  void createRoom(String roomName, BuildContext context) async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();
      GameRoomModels game = GameRoomModels(
          user1profilePic: userData['profilePic'],
          user2profilePic:
              'https://th.bing.com/th/id/OIP.10eUaR89ccjlncXQx2Hu-gAAAA?w=300&h=300&rs=1&pid=ImgDetMain',
          roomCode: roomName,
          user1: userData['userName'],
          user2: '',
          turn: userData['userName'],
          createdAt: DateTime.now());
      await firestore.collection('games').doc(roomName).set(game.toMap());
      showSnackBar(context: context, content: 'Room created successfully');
      Navigator.pushNamed(context, GameScreen.routeName, arguments: roomName);
    } catch (e) {
      showSnackBar(
          context: context,
          content: "Something went wrong in creating room + ${e.toString()}");
    }
  }

  void joinGame(String roomName, BuildContext context) async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();
      var gameData = await firestore.collection('games').doc(roomName).update({
        'user2': userData['userName'],
        'user2profilePic': userData['profilePic'],
      });
      Navigator.pushNamed(context, GameScreen.routeName, arguments: roomName);
    } catch (e) {
      showSnackBar(
          context: context,
          content: 'Something went wrong while joining game ${e.toString()}');
    }
  }

  void tappedOnBoard(
      AsyncSnapshot snap, BuildContext context, int index) async {
    try {
      print('reached here on tapping');
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();
      var userName = userData['userName'];
      if (userName != snap.data['turn']) {
        showSnackBar(context: context, content: 'It is not yours turn');
        return;
      }
      print('here at 1');
      if (snap.data['gameIndex'][index] == '0' ||
          snap.data['gameIndex'][index] == 'X') {
        showSnackBar(context: context, content: 'Choose another index');
        return;
      }
      final docRef =
          await firestore.collection('games').doc(snap.data['roomCode']).get();
      GameRoomModels newGame = GameRoomModels.fromMap(docRef.data()!);
      if (userName == snap.data['user1']) {
        newGame.gameIndex[index] = '0';
      } else {
        newGame.gameIndex[index] = 'X';
      }
      userName == snap.data['user1']
          ? await firestore
              .collection('games')
              .doc(snap.data['roomCode'])
              .update(newGame.toMap())
          : await firestore
              .collection('games')
              .doc(snap.data['roomCode'])
              .update(newGame.toMap());
      if ((newGame.gameIndex[0] == '0' &&
              newGame.gameIndex[1] == '0' &&
              newGame.gameIndex[2] == '0') || // Row 1
          (newGame.gameIndex[3] == '0' &&
              newGame.gameIndex[4] == '0' &&
              newGame.gameIndex[5] == '0') || // Row 2
          (newGame.gameIndex[6] == '0' &&
              newGame.gameIndex[7] == '0' &&
              newGame.gameIndex[8] == '0') || // Row 3
          (newGame.gameIndex[0] == '0' &&
              newGame.gameIndex[3] == '0' &&
              newGame.gameIndex[6] == '0') || // Column 1
          (newGame.gameIndex[1] == '0' &&
              newGame.gameIndex[4] == '0' &&
              newGame.gameIndex[7] == '0') || // Column 2
          (newGame.gameIndex[2] == '0' &&
              newGame.gameIndex[5] == '0' &&
              newGame.gameIndex[8] == '0') || // Column 3
          (newGame.gameIndex[0] == '0' &&
              newGame.gameIndex[4] == '0' &&
              newGame.gameIndex[8] == '0') || // Diagonal 1
          (newGame.gameIndex[2] == '0' &&
              newGame.gameIndex[4] == '0' &&
              newGame.gameIndex[6] == '0')) // Diagonal 2
      {
        await firestore.collection('games').doc(snap.data['roomCode']).update({
          'winner': snap.data['user1'],
        });
        return;
      }
      if ((newGame.gameIndex[0] == 'X' &&
              newGame.gameIndex[1] == 'X' &&
              newGame.gameIndex[2] == 'X') || // Row 1
          (newGame.gameIndex[3] == 'X' &&
              newGame.gameIndex[4] == 'X' &&
              newGame.gameIndex[5] == 'X') || // Row 2
          (newGame.gameIndex[6] == 'X' &&
              newGame.gameIndex[7] == 'X' &&
              newGame.gameIndex[8] == 'X') || // Row 3
          (newGame.gameIndex[0] == 'X' &&
              newGame.gameIndex[3] == 'X' &&
              newGame.gameIndex[6] == 'X') || // Column 1
          (newGame.gameIndex[1] == 'X' &&
              newGame.gameIndex[4] == 'X' &&
              newGame.gameIndex[7] == 'X') || // Column 2
          (newGame.gameIndex[2] == 'X' &&
              newGame.gameIndex[5] == 'X' &&
              newGame.gameIndex[8] == 'X') || // Column 3
          (newGame.gameIndex[0] == 'X' &&
              newGame.gameIndex[4] == 'X' &&
              newGame.gameIndex[8] == 'X') || // Diagonal 1
          (newGame.gameIndex[2] == 'X' &&
              newGame.gameIndex[4] == 'X' &&
              newGame.gameIndex[6] == 'X')) // Diagonal 2
      {
        await firestore.collection('games').doc(snap.data['roomCode']).update({
          'winner': snap.data['user2'],
        });
        return;
      }

      var turn;
      if (snap.data['turn'] == snap.data['user1']) {
        turn = snap.data['user2'];
      } else {
        turn = snap.data['user1'];
      }
      print('here at 3');
      var gameSnap = await firestore
          .collection('games')
          .doc(snap.data['roomCode'])
          .update({
        'turn': turn,
      });

      print('here at turn 4');
    } catch (e) {
      showSnackBar(
          context: context,
          content:
              'Something went wrong , while tapping on the board  , ${e.toString()}');
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }
}
