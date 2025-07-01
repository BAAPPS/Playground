//
//  AddBookView.swift
//  BookWormm
//
//  Created by D F on 7/1/25.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    

    var body: some View {
        let safeTitle = title.isEmpty ? "Unknown Title" : title
        let safeAuthor = author.isEmpty ? "Unknown Author" : author
        let safeGenre = genre.isEmpty ? "Unknown Genre" : genre

        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(title: safeTitle, author: safeAuthor, genre: safeGenre, review: review, rating: rating, date: Date.now)
                        modelContext.insert(newBook)
                        
                     dismiss()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
        
    }
}

#Preview {
    AddBookView()
}
