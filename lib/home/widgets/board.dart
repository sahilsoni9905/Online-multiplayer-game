import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/home/repository/home_repository.dart';

class TicTacToeBoard extends ConsumerStatefulWidget {
  TicTacToeBoard({Key? key, required this.userTurn, required this.snap})
      : super(key: key);
  AsyncSnapshot snap;
  String userTurn;

  @override
  ConsumerState<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends ConsumerState<TicTacToeBoard> {
  @override
  void initState() {
    super.initState();
  }

  void tapDetect(index) {
    ref.read(homeRepositoryProvider).tappedOnBoard(widget.snap, context, index);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => tapDetect(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(64, 255, 255, 255),
                ),
              ),
              child: Center(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    widget.snap.data['gameIndex'][index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 100,
                      shadows: [
                        Shadow(
                          blurRadius: 40,
                          color: Color.fromARGB(235, 255, 255, 255),
                        ),
                      ],
                    ),
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
