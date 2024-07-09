import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/home/repository/home_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String routeName = 'home-page';
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void createRoomForGame(String roomName, BuildContext context) {
    ref.read(homeRepositoryProvider).createRoom(roomName, context);
  }

  void joinRoomForGame(String roomName, BuildContext context) {
    ref.read(homeRepositoryProvider).joinGame(roomName, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, "Create Room"),
              const SizedBox(height: 20),
              _buildButton(context, "Join Room"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => label == "Create Room"
                ? _showDialogToCreateRoom(context, label)
                : _showDialogToJoinRoom(context, label),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Color.fromARGB(255, 19, 13, 20),
              shadowColor: Colors.blue,
              elevation: 15,
              overlayColor: const Color.fromARGB(255, 0, 118, 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                shadows: [
                  Shadow(color: Colors.white, blurRadius: 10),
                ],
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDialogToCreateRoom(BuildContext context, String action) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Enter ${action.split(' ')[0].toLowerCase()} name"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                createRoomForGame(_controller.text, context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showDialogToJoinRoom(BuildContext context, String action) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Enter ${action.split(' ')[0].toLowerCase()} name"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                joinRoomForGame(_controller.text, context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
