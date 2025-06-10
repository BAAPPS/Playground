//
//  ContentView.swift
//  TicTacToe
//
//  Created by D F on 6/10/25.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}


struct imageAsset: View {
    var name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
        
    }
}

// Custom Container
struct Grid<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack{
            ForEach(0..<rows, id:\.self) { row in
                HStack() {
                    ForEach(0..<columns, id:\.self){ column in
                        content(row, column) // render each cell
                        
                    }
                }
            }
        }
    }
}

enum Users: String, CaseIterable{
    case player1 = "Player 1"
    case player2 = "Player 2"
}

enum Icons: String, CaseIterable{
    case x = "x-solid"
    case o = "o-solid"
}

struct ContentView: View {
    @State private var playerOneIcon: Icons = .x
    @State private var playerTwoIcon: Icons = .o
    @State private var selectedUser: Users = .player1
    @State private var selectedIcon: Icons = .x
    @State private var gridIcons:[[String?]] = Array(
        repeating: Array(repeating:nil, count: 3),
        count: 3
    )
    @State private var isWinner = false
    @State private var winnerPlayer: Users? = nil
    
    @State private var isDraw = false


    func resetGame() {
        gridIcons = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        selectedUser = .player1
        isWinner = false
        winnerPlayer = nil
        isDraw = false 
    }

    func handleCellTapped(row: Int, col:Int){
        guard gridIcons[row][col] == nil else { return }
        
        let currentIcon = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
        gridIcons[row][col] = currentIcon.rawValue
        
        if winner(row: row, col: col){
            winnerPlayer = selectedUser
            isWinner = true
        }
        else if isBoardFull() {
                isDraw = true
            }
        else{
            selectedUser = selectedUser == .player1 ? .player2 : .player1
        }
        
    }
    
    func isBoardFull() -> Bool{
        for row in gridIcons{
            for col in row{
                if col == nil {
                    return false
                }
            }
        }
        return true
    }
    func winner(row: Int, col: Int) -> Bool{
        
        guard let player = gridIcons[row][col] else { return false }
        
        let size = gridIcons.count
        
        // Directions to check (right, down, down-right, down-left)
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]
        
        for (dx, dy) in directions {
            var count = 1
            
            // Check forward direction
            var x = row + dx
            var y = col + dy
            
            while x >= 0 && x < size && y >= 0 && y < size && gridIcons[x][y] == player{
                count += 1
                x += dx
                y += dy
            }
            // Check backward direction
            x = row - dx
            y = col - dy
            
            while x >= 0 && x < size && y >= 0 && y < size && gridIcons[x][y] == player{
                count += 1
                x -= dx
                y -= dy
            }
            
            if count >= 3 {
                return true
            }
        }
        return false
        
    }
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.98, green: 0.98, blue: 0.98), location: 0.1),
                    .init(color: Color(red: 0.2, green: 0.92, blue: 0.95), location: 0.9),
                ],
                center: .center,
                startRadius: 100,
                endRadius: 800
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Tic Tac Toe")
                    .titleStyle()
                    .foregroundColor(.gray)
                    .background(Color(red: 0.51, green: 0.51, blue: 0.51, opacity: 0.1))
                Spacer()
                
                Form {
                    VStack {
                        Text("Who's First")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Picker("", selection: $selectedUser){
                            ForEach(Users.allCases, id: \.self){ user in
                                Text(user.rawValue)
                            }
                        }.pickerStyle(.segmented)
                    }.listRowBackground(Color.clear)
                    
                    
                    VStack{
                        Text("Choose Your Icon")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Picker("", selection:
                                Binding<Icons>(
                                    get:{
                                        selectedUser == .player1 ? playerOneIcon : playerTwoIcon
                                    },
                                    set:{
                                        newIcon in
                                        if selectedUser == .player1 {
                                            playerOneIcon = newIcon
                                            playerTwoIcon = Icons.allCases.first(where: {$0 != newIcon})!
                                        }else{
                                            playerTwoIcon = newIcon
                                            playerOneIcon = Icons.allCases.first(where: {$0 != newIcon})!
                                        }
                                    }
                                )
                               
                        ) {
                            ForEach(Icons.allCases, id: \.self) { icon in
                                Text(icon == .x ? "X": "O")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    
                    VStack {
                        HStack{
                            Text("Current Player:")
                                .font(.title3)
                            Text(selectedUser.rawValue)
                                .font(.title3)
                        }
                        HStack {
                            Text("\(selectedUser.rawValue) Icon:")
                                .font(.title3)
                            let currentIcon = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
                            imageAsset(name: currentIcon.rawValue)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)
                    .padding()
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
                
                ZStack{
                    imageAsset(name: "board")
                    Grid(rows: 3, columns: 3) { row, col in
                        Button(action: {
                            handleCellTapped(row: row, col: col)
                        }){
                            ZStack {
                                Color.clear
                                    .frame(width:100, height: 100)
                                    .contentShape(Rectangle())
                                
                                if let iconName = gridIcons[row][col]{
                                    imageAsset(name:iconName)
                                        .frame(width:24, height: 24)
                                }
                                
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        
        .alert("Game Over", isPresented: $isWinner, actions: {
            Button("OK") { resetGame() }
        }, message: {
            Text("\(winnerPlayer?.rawValue ?? "Player") wins!")
        })
        .alert("Draw", isPresented: $isDraw, actions: {
            Button("OK") { resetGame() }
        }, message: {
            Text("It's a draw!")
        })

    }
}

#Preview {
    ContentView()
}
