import "dart:io";

List<int> load(String boardStr) {
	// Just convert string of integer into list of integer.
	List<int> board = List.filled(81, 0);
	for (int i = 0; i < boardStr.length; i++) {
		board[i] = int.parse(boardStr[i]);
	}
	return board;
}
void viewBoard(List<int> board) {
	String lineSep = "+-------+-------+-------+";
	print(lineSep);
	String process(int v) => (v == 0 ? "_" : v.toString());
	String toPrint = "| " + process(board[0]) + " ";
	for (int i = 1; i < board.length; i++) {
		if (i % 9 == 0) {
			// Loaded a row of board.
			print(toPrint+"|");
			toPrint = "| ";
		} else if (i % 3 == 0) {
			toPrint = toPrint + "| ";
		}
		if (i % 27 == 0) {
			print(lineSep);
		}
		toPrint = toPrint + process(board[i]) + " ";
	}
	print(toPrint+"|");
	print(lineSep);
}
int firstZero(List<int> board) {
	for (int i = 0; i < board.length; i++) {
		if (board[i] == 0) {
			return i;
		}
	}
	return -1; // The board is probably solved... or invaid.
}
List<int> generateMove(List<int> board, int ind) {
	List<int> contain = List.generate(9, (i) => i+1);
	int r,c; // Calculate row and column of the ind.
	r = (ind/9).floor();
	c = (ind%9);

	// 3x3 window check.
	int offset = ((r/3).floor() * 3 * 9) + ((c/3).floor() * 3);
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			int v = board[i+offset+(j*9)];
			if (v != 0) {
				contain[v-1] = 0;
			}
		}
	}

	// Row and column check.
	for (int i = 0; i < 9; i++) {
		// row
		int v = board[r*9+i];
		if (v != 0) {
			contain[v-1] = 0;
		}
		// column
		v = board[(i*9)+c];
		if (v != 0) {
			contain[v-1] = 0;
		}
	}
	contain.removeWhere((v) => v == 0); // Remove all zeros and get all valid number.
	return contain; 
}

bool solve(List<int> board) {
	int ind = firstZero(board);
	if (ind == -1) {
		// The board is solved.
		print("Solved");
		viewBoard(board);
		return true; // Signal for all search to stop.
	}
	List<int> allMove = generateMove(board, ind);
	if (allMove.length == 0) {
		return false; // No more valid move. Backtrace.
	}
	board = [...board];
	for (int move in allMove) {
		board[ind] = move;
		bool isSolved = solve(board);
		if (isSolved) {
			return true; // Stop all search.
		}
	}
	return false;
}

void main() {
	//String sample = "530070000600195000098000060800060003400803001700020006060000280000419005000080079";
	String sample = "";
	for (int i = 0; i < 9; i++) {
		stdout.write("${i+1} > ");
		String row = stdin.readLineSync() as String;
		while(row.length != 9) {
			stdout.write("Length must be equal to 9\u001B[1A\u001B[1000D${i+1} > ");
			row = stdin.readLineSync() as String;
			stdout.write("                         \u001B[1000D");
		}
		sample = sample + row;
	}
	List<int> board = load(sample);
	viewBoard(board);
	solve(board);
}