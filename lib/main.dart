import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        hintColor: Colors.black,
      ),
      home: PlayerSelectionScreen(),
    );
  }
}

class PlayerSelectionScreen extends StatefulWidget {
  @override
  _PlayerSelectionScreenState createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  String playerASymbol = 'X';
  String playerBSymbol = 'O';

  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToeScreen(
          playerASymbol: playerASymbol,
          playerBSymbol: playerBSymbol,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Symbols',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player A, select your symbol:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: playerASymbol,
                items: ['X', 'O'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      playerASymbol = newValue;
                      playerBSymbol = (newValue == 'X') ? 'O' : 'X';
                    });
                  }
                },
                dropdownColor: Colors.black,
              ),
              SizedBox(height: 30),
              Text(
                'Player B symbol: $playerBSymbol',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Start Game',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  final String playerASymbol;
  final String playerBSymbol;

  TicTacToeScreen({required this.playerASymbol, required this.playerBSymbol});

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(
    3,
    (index) => List.generate(3, (index) => ''),
  );
  bool isPlayerATurn = true;
  String winner = '';

  // Handle cell tap
  void handleTap(int row, int col) {
    if (board[row][col] == '' && winner == '') {
      setState(() {
        board[row][col] = isPlayerATurn ? widget.playerASymbol : widget.playerBSymbol;
        isPlayerATurn = !isPlayerATurn;
        winner = checkWinner();
      });
    }
  }

  // Check for a winner
  String checkWinner() {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != '') {
        return board[i][0] == widget.playerASymbol ? 'Player A' : 'Player B';
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != '') {
        return board[0][i] == widget.playerASymbol ? 'Player A' : 'Player B';
      }
    }
    // Check diagonals
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != '') {
      return board[0][0] == widget.playerASymbol ? 'Player A' : 'Player B';
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != '') {
      return board[0][2] == widget.playerASymbol ? 'Player A' : 'Player B';
    }
    // Check for draw
    if (board.every((row) => row.every((cell) => cell != ''))) {
      return 'Draw';
    }
    return '';
  }

  // Reset the game
  void resetGame() {
    setState(() {
      board = List.generate(
        3,
        (index) => List.generate(3, (index) => ''),
      );
      isPlayerATurn = true;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the board
          for (int row = 0; row < 3; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int col = 0; col < 3; col++)
                  GestureDetector(
                    onTap: () => handleTap(row, col),
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          SizedBox(height: 20),
          // Display the winner or draw message
          if (winner.isNotEmpty)
            Text(
              winner == 'Draw' ? 'It\'s a draw!' : '$winner wins!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          SizedBox(height: 20),
          // Reset button
          ElevatedButton(
            onPressed: resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Reset Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
