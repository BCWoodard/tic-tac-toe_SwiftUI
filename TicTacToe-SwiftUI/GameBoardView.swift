//
//  GameBoardView.swift
//  TicTacToe-SwiftUI
//
//  Created by Brad Woodard on 7/10/25.
//

import SwiftUI

struct GameBoardView: View {
    @StateObject private var viewModel = TicTacToeViewModel()

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
                            viewModel.makeMove(at: index)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(viewModel.board[index].isEmpty ? Color.gray : Color.white)
                                    .frame(width: 100, height: 100)
                                Text(viewModel.board[index])
                                    .font(.system(size: 80, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .disabled(!viewModel.board[index].isEmpty)
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
                viewModel.resetGame()
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
        .sheet(isPresented: $viewModel.showResultSheet) {
            VStack {
                if let imageName = viewModel.resultImage {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                }
                Text(viewModel.resultText)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                Group {
                    ForEach([
                        ("Play Again", {
                            viewModel.resetGame()
                        }),
                        ("Show the Board", {
                            viewModel.dismissResult()
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
}

#Preview {
    GameBoardView()
}
