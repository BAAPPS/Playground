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
    
    @Bindable var authVM: SupabaseAuthViewModel
    
    @State private var selectedTab:ProfileTab = .liked
    
    @State private var showProfileSetting = false
    
    @State var photoVM = PhotoViewModel()
    
    @State var filteredVM = FilteredPhotoVM()
    
    
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
                    if selectedTab == .liked {
                        ForEach(photoVM.likedPhotos, id: \.id) { photo in
                            AsyncImageLoader(urlString: photo.original_url)
                        }
                    } else {
                        ForEach(filteredVM.filteredPhotos, id: \.id) { filtered in
                            AsyncImageLoader(urlString: filtered.filtered_url)
                        }
                    }
                    
                }
                .padding(.horizontal)
            }
            
        }
        .navigationTitle(authVM.currentUser?.username ?? "Unknown User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    Task{
                        await authVM.logout()
                    }
                } label:{
                    Image(systemName: "door.left.hand.open")                        .foregroundColor(Color(hex:"#5f8d98"))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Button{
                    showProfileSetting.toggle()
                } label:{
                    Image(systemName:"gearshape.fill")
                        .foregroundColor(Color(hex:"#5f8d98"))
                }
            }
        }
        .task {
            await photoVM.fetchLikedPhoto()
            await filteredVM.fetchFilteredPhoto()
        }
        
        .sheet(isPresented: $showProfileSetting){
            ProflleSettingView(authVM: authVM, showProfileSetting: $showProfileSetting)
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
