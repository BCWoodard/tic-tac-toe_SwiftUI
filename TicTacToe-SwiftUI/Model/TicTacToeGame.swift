//
//  TicTacToeGame.swift
//  TicTacToe-SwiftUI
//
//  Created by Brad Woodard on 7/14/25.
//

import Foundation

struct TicTacToeGame {
    private(set) var board: [String] = Array(repeating: "", count: 9)
    private(set) var isCrossTurn: Bool = true

    mutating func makeMove(at index: Int) {
        guard board[index].isEmpty else { return }
        board[index] = isCrossTurn ? "X" : "O"
        isCrossTurn.toggle()
    }

    mutating func reset() {
        board = Array(repeating: "", count: 9)
        isCrossTurn = true
    }

    func checkWinner() -> String? {
        let patterns = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        for pattern in patterns {
            let first = board[pattern[0]]
            if first != "" && pattern.allSatisfy({ board[$0] == first }) {
                return first
            }
        }
        return nil
    }

    var isDraw: Bool {
        return !board.contains("") && checkWinner() == nil
    }
}
