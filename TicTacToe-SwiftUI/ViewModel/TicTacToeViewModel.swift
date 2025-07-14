//
//  TicTacToeViewModel.swift
//  TicTacToe-SwiftUI
//
//  Created by Brad Woodard on 7/14/25.
//

import Foundation

final class TicTacToeViewModel: ObservableObject {
    @Published private var game = TicTacToeGame()
    @Published var showResultSheet = false
    @Published var resultText = ""
    @Published var resultImage: String? = nil
    
    var board: [String] {
        game.board
    }

    var isCrossTurn: Bool {
        game.isCrossTurn
    }

    func makeMove(at index: Int) {
        game.makeMove(at: index)
        if let winner = game.checkWinner() {
            resultText = "The winner is: \n\(winner)!"
            resultImage = nil
            showResultSheet = true
        } else if game.isDraw {
            resultText = "There is no winner."
            resultImage = "sad_trombone"
            showResultSheet = true
        }
    }

    func resetGame() {
        game.reset()
        showResultSheet = false
    }

    func dismissGameResult() {
        showResultSheet = false
    }

    func checkGameOver() {
        let winPatterns = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        for pattern in winPatterns {
            let first = board[pattern[0]]
            if first != "" && pattern.allSatisfy({ board[$0] == first }) {
                resultText = "The winner is:\n\(first)"
                resultImage = nil
                showResultSheet = true
                return
            }
        }
        if !board.contains("") {
            resultText = "There is no winner."
            resultImage = "sad_trombone"
            showResultSheet = true
        }
    }
}

