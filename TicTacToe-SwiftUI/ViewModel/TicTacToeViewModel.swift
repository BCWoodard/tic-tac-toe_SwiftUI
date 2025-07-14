//
//  TicTacToeViewModel.swift
//  TicTacToe-SwiftUI
//
//  Created by Brad Woodard on 7/14/25.
//

import SwiftUI

final class TicTacToeViewModel: ObservableObject {
    @Published var board = Array(repeating: "", count: 9)
    @Published var isCrossTurn = true
    @Published var showResultSheet = false
    @Published var resultText = ""
    @Published var resultImage: String? = nil

    func makeMove(at index: Int) {
        guard board[index].isEmpty else { return }
        board[index] = isCrossTurn ? "X" : "O"
        isCrossTurn.toggle()
        checkGameOver()
    }

    func resetGame() {
        board = Array(repeating: "", count: 9)
        isCrossTurn = true
        showResultSheet = false
    }

    func dismissResult() {
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

