//
//  ContentView.swift
//  ConnectFour
//
//  Created by D F on 6/12/25.
//

import SwiftUI

struct Title:ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .padding()
            .background(Color(red: 0.0, green: 0.34, blue: 0.72, opacity: 0.8))
            .clipShape(.rect)
            .cornerRadius(10)
            .textCase(.uppercase)
            .foregroundColor(.white)
    }
}

struct SubHeadline:ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72, opacity: 0.8))
    }
}


extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func subHeadLineStyle() -> some View {
        modifier(SubHeadline())
    }
}


struct ImageAsset: View {
    var name: String
    var body: some View{
        Image(name)
            .resizable()
            .scaledToFit()
    }
}


enum Users: String, CaseIterable {
    case player1 = "Player 1"
    case player2 = "Player 2"
}

enum Icons: String, CaseIterable {
    case red = "redCoin"
    case yellow = "yellowCoin"
}

import SwiftUI

struct BoardGrid<Content: View>: View {
    let rows: Int
    let columns: Int
    let width: CGFloat
    let height: CGFloat
    let content: (Int, Int) -> Content
    
    var body: some View {
        let cellWidth = width / CGFloat(columns)
        let cellHeight = height / CGFloat(rows)
        
        let gridItems = Array(repeating: GridItem(.fixed(cellWidth)), count: columns)
        
        LazyVGrid(columns: gridItems, spacing: 0) {
            ForEach(0..<rows * columns, id: \.self) { index in
                let row = index / columns
                let column = index % columns
                content(row, column)
                    .padding(4)
                    .frame(width: cellWidth, height: cellHeight)
            }
        }
        .frame(width: width, height: height)
    }
}


struct ContentView: View {
    
    static let MAX_ROWS = 6
    static let MAX_COLUMNS = 7
    
    @State private var playerOneIcon: Icons = .red
    @State private var playerTwoIcon: Icons =  .yellow
    @State private var selectedIcon: Icons = .red
    @State private var selectedUser: Users = .player1
    @State private var selectedIconForPicker: Icons = .red
    @State private var gridIcons:[[String?]] = Array(
        repeating:Array(repeating:nil, count: ContentView.MAX_COLUMNS) // columns
        ,
        count:ContentView.MAX_ROWS // rows
    )
    
    
    @State private var isWinner = false
    @State private var winningUser: Users? = nil
    @State private var isDraw = false
    
    
    
    func countMatches(row:Int, col: Int, dr: Int, dc:Int, icon:String) -> Int{
        var r = row + dr
        var c = col + dc
        
        var matchCount = 0
        
        let size = gridIcons.count
        
        
        while r >= 0 && r < size && c >= 0 && c < size && c < gridIcons[0].count {
            if gridIcons[r][c] == icon {
                matchCount += 1
            } else{
                break
            }
            r += dr
            c += dc
        }
        
        return matchCount
    }
    
    
    func checkWinner(row: Int, col: Int, icon:String) ->Bool{
        let directions = [(0, 1),   // Right →
                          (1, 0),   // Down ↓
                          (1, 1),   // Down-Right ↘
                          (1, -1)]  // Down-Left ↙
        
        for (dr, dc) in directions{
            var count = 1
            
            // Check in the positive direction
            count += countMatches(row: row, col: col, dr: dr, dc: dc, icon: icon)
            // Check in the negative direction
            count += countMatches(row: row, col: col, dr: -dr, dc: -dc, icon: icon)
            
            if count >= 4 {
                return true
            }
        }
        return false
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
    
    
    func handleCellTapped(row:Int, col:Int) {
        for r in (0..<ContentView.MAX_ROWS).reversed(){
            if gridIcons[r][col] == nil
            {
                let currentCoin = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
                gridIcons[r][col] = currentCoin.rawValue
                
                // Check if the current move causes a win
                if checkWinner(row: r, col: col, icon: currentCoin.rawValue) {
                    winningUser = selectedUser // or any other logic to handle the win
                    isWinner = true
                    print("Winner is \(selectedUser)")
                }
                else if isBoardFull(){
                    isDraw = true
                }
                else{
                    selectedUser = selectedUser == .player1 ? .player2 : .player1
                }
                
                return
            }
            
            
        }
    }
    
    
    func updateIcons(newIcon: Icons) {
        if selectedUser == .player1 {
            playerOneIcon = newIcon
            playerTwoIcon = Icons.allCases.first(where: { $0 != newIcon })!
        } else {
            playerTwoIcon = newIcon
            playerOneIcon = Icons.allCases.first(where: { $0 != newIcon })!
        }
    }
    
    
    func resetGame(){
        isDraw = false
        isWinner = false
        winningUser = nil
        selectedUser = .player1
        gridIcons = Array(
            repeating:Array(repeating:nil, count: ContentView.MAX_COLUMNS)
            ,
            count:ContentView.MAX_ROWS
        )
        
    }
    
    
    private var selectedBinding: Binding<Icons> {
        Binding<Icons>(
            get: {
                selectedUser == .player1 ? playerOneIcon : playerTwoIcon
            },
            set: { newIcon in
                updateIcons(newIcon: newIcon)
            }
        )
    }
    
    var body: some View {
        ZStack {
            RadialGradient( stops: [
                .init(color: Color(red: 0.76, green: 0.9, blue: 0.95), location: 0.1),
                .init(color: Color(red: 0.0, green: 0.34, blue: 0.72), location: 0.5)
            ], center: .bottom, startRadius: 200, endRadius: 3000)
            .ignoresSafeArea()
            
            VStack{
                Text("Connect 4")
                    .titleStyle()
                    .padding(.top, 20)
                
                Spacer()
                
                Form {
                    VStack(alignment: .leading){
                        Text("Who Is Going First?")
                            .subHeadLineStyle()
                            .frame(maxWidth:.infinity, alignment: .center)
                        Picker("", selection: $selectedUser){
                            ForEach(Users.allCases, id:\.self){ user in
                                Text(user.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.clear)
                    
                    VStack{
                        Text("Choose Your Icon")
                            .subHeadLineStyle()
                            .frame(maxWidth:.infinity, alignment: .center)
                            .padding(.top, 10)
                        
                        
                        Picker("", selection: selectedBinding) {
                            ForEach(Icons.allCases, id: \.self) { icon in
                                HStack(spacing: 12) {
                                    ImageAsset(name: icon.rawValue)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(icon == .red ? "Red" : "Yellow")
                                        .subHeadLineStyle()
                                        .frame(width: 60, alignment: .center)
                                }
                                .frame(width: 140, alignment: .center)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                        
                        
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text("Current Player:")
                                    .font(.title3)
                                Text(selectedUser.rawValue)
                                    .font(.title3)
                                    .foregroundColor(Color(red: 0.0, green: 0.34, blue: 0.72))
                            }
                            HStack {
                                Text("\(selectedUser.rawValue) Icon:")
                                    .font(.title3)
                                let currentIcon = selectedUser == .player1 ? playerOneIcon : playerTwoIcon
                                ImageAsset(name: currentIcon.rawValue)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .frame(maxWidth:.infinity, maxHeight: .infinity, alignment:.leading)
                        .listRowBackground(Color.clear)
                        .padding()
                        
                    }
                    .listRowBackground(Color.clear)
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
                
                ZStack {
                    ImageAsset(name: "board")
                        .frame(width: 300, height: 300)
                    
                    BoardGrid(rows: ContentView.MAX_ROWS, columns: ContentView.MAX_COLUMNS, width:240, height: 255) { row, col in
                        Button(action: {
                            print("Tapped on: \(row),\(col)")
                            handleCellTapped(row: row, col: col)
                        }) {
                            Color.clear
                            if let iconName = gridIcons[row][col]{
                                ImageAsset(name: iconName)
                                    .frame(width:39, height: 39)
                                    .offset(x:-4, y:-6)
                            }
                        }
                    }
                    .offset(y:6)
                }
                
            }
        }
        
        .alert("Game Over", isPresented: $isWinner, actions: {
            Button("OK") { resetGame() }
        }, message: {
            Text("\(winningUser?.rawValue ?? "Player") wins!")
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
