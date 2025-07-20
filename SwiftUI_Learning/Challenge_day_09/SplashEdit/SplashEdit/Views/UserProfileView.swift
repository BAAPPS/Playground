//
//  UserProfileView.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import SwiftUI

enum ProfileTab: String, CaseIterable, Identifiable {
    case liked = "Liked"
    case filtered = "Filtered"
    
    var id: String { rawValue }
}

struct UserProfileView: View {
    
    var authVM: SupabaseAuthViewModel
    
    @State private var selectedTab:ProfileTab = .liked
    
    @State var photoVM = PhotoViewModel()
    
    func photosForSelectedTab() -> [PhotoModel] {
          switch selectedTab {
          case .liked:
              return photoVM.likedPhotos
          case .filtered:
              return [] // later implement filtered photos
          }
      }
    
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            VStack(spacing: 4) {
                Text("Photos you’ve interacted with")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } .padding(.top)
            
            Picker("Tab", selection: $selectedTab) {
                ForEach(ProfileTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Spacer()
            
            ScrollView{
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing:10) {
                    ForEach(photosForSelectedTab(), id:\.id){photo in
                        AsyncImageLoader(urlString: photo.original_url)
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .navigationTitle(authVM.currentUser?.username ?? "Unknown User")
        .navigationBarTitleDisplayMode(.inline)
        .task{
            await photoVM.fetchLikedPhoto()
        }
    }
}

#Preview {
    let vm = SupabaseAuthViewModel()
    vm.currentUser = SupabaseUsersModel(id: UUID(), username: "MockUser", created_at: Date())
    return  NavigationView {
        UserProfileView(authVM: vm)
    }
}
