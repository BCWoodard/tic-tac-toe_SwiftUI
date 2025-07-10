//
//  ContentView.swift
//  TicTacToe-SwiftUI
//
//  Created by Brad Woodard on 7/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var board: [String] = Array(repeating: "", count: 9)
    @State private var isCrossTurn = true
    @State private var showResultSheet = false
    @State private var resultText: String = ""
    @State private var resultImage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 8) {
                Text("Let's Play")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Tic-Tac-Toe")
                    .font(.system(size: 40, weight: .bold))
            }

            ZStack {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 10), count: 3), spacing: 10) {
                    ForEach(0..<9) { index in
                        Button(action: {
                            if board[index].isEmpty {
                                board[index] = isCrossTurn ? "X" : "O"
                                isCrossTurn.toggle()
                                checkGameOver()
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(board[index].isEmpty ? Color.gray : Color.white)
                                    .frame(width: 100, height: 100)
                                Text(board[index])
                                    .font(.system(size: 80, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .disabled(!board[index].isEmpty)
                    }
                }

                GeometryReader { geometry in
                    let totalSize: CGFloat = 320
                    let spacing: CGFloat = 10
                    let cellSize: CGFloat = 100

                    Path { path in
                        // Vertical lines
                        for i in 1..<3 {
                            let x = CGFloat(i) * cellSize + CGFloat(i - 1) * spacing
                            path.move(to: CGPoint(x: x + spacing / 2, y: 0))
                            path.addLine(to: CGPoint(x: x + spacing / 2, y: totalSize))
                        }
                        // Horizontal lines
                        for i in 1..<3 {
                            let y = CGFloat(i) * cellSize + CGFloat(i - 1) * spacing
                            path.move(to: CGPoint(x: 0, y: y + spacing / 2))
                            path.addLine(to: CGPoint(x: totalSize, y: y + spacing / 2))
                        }
                    }
                    .stroke(Color.black, lineWidth: 2)
                }
                .frame(width: 320, height: 320)
            }

            Spacer()

            Button("Play Again") {
                board = Array(repeating: "", count: 9)
                isCrossTurn = true
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
            )
            .padding(.horizontal, 24)

            Spacer()
        }
        .sheet(isPresented: $showResultSheet) {
            VStack {
                if let imageName = resultImage {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                }
                Text(resultText)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                Group {
                    ForEach([
                        ("Play Again", {
                            board = Array(repeating: "", count: 9)
                            isCrossTurn = true
                            showResultSheet = false
                        }),
                        ("Show the Board", {
                            showResultSheet = false
                        })
                    ], id: \.0) { title, action in
                        Button(title, action: action)
                            .frame(width: 240, height: 46, alignment: .center)
                            .background(title == "Play Again" ? Color.accentColor : Color.gray.opacity(0.4))
                            .foregroundColor(title == "Play Again" ? Color.white : Color.black)
                            .cornerRadius(10)
                    }
                }
            }
            .presentationDetents([.fraction(0.40)])
        }
    }
    
    private func checkGameOver() {
        let winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [2, 4, 6]             // diagonals
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

#Preview {
    ContentView()
}
