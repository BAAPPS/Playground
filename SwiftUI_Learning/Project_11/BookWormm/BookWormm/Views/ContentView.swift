//
//  ContentView.swift
//  BookWormm
//
//  Created by D F on 7/1/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort:[
        SortDescriptor(\Book.title, order:.reverse),
        SortDescriptor(\Book.author, order:.reverse)
    ]) var books: [Book]
    
    @State private var showingAddScreen = false
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our query
            let book = books[offset]
            
            // delete it from the context
            modelContext.delete(book)
        }
    }
    
    func bookRatingColor(rating: Int) -> Color {
        switch rating {
        case 1: return .red          // Poor rating - urgent/warning
        case 2: return .orange       // Below average - caution
        case 3: return .yellow       // Average - neutral/warning but less urgent
        case 4: return .green        // Good rating - positive
        case 5: return .blue         // Excellent - calm and trustworthy
        default: return .gray        // Default/fallback color
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundColor(bookRatingColor(rating: book.rating))
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
        .onAppear {
            print("Loaded books: \(books.map(\.title))")
        }
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    
    let context = container.mainContext
    let sample = Book(title: "Test", author: "Author", genre: "Fantasy", review: "Great!", rating: 5)
    context.insert(sample)
    
    return ContentView()
        .modelContainer(container)
}
