//
//  FilterPhotoView.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit


struct FilterPhotoView: View {
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) var requestReview
    
    @Bindable var authVM: SupabaseAuthViewModel
    
    @State private var viewModel = FilteredPhotoVM()
    
    
    let photo:UnsplashPhotosModel
    
    @State private var processedUIImage: UIImage?
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 1.0
    
    let context = CIContext()
    
    var hasImage: Bool {
        processedImage != nil
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys
            .contains(kCIInputIntensityKey) {
            currentFilter
                .setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys
            .contains(kCIInputRadiusKey) {
            currentFilter
                .setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys
            .contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedUIImage = uiImage
        processedImage = Image(uiImage: uiImage)
    }
    
    
    
    func loadURLImage() async {
        Task {
            guard let url = URL(string: photo.urls.regular) else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let inputUIImage = UIImage(data: data) else { return }
                
                let beginImage = CIImage(image: inputUIImage)
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                applyProcessing()
            } catch {
                print(
                    "Failed to load image from URL:",
                    error.localizedDescription
                )
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    @MainActor func setFilter(_ filter: CIFilter) async {
        currentFilter = filter
        await loadURLImage()
        
        filterCount += 1
        
        if filterCount >= 10 {
            requestReview()
        }
    }
    
    @MainActor
    func saveFilteredImage() async {
        guard let uiImage = processedUIImage,
              let ciImage = CIImage(image: uiImage) else {
            print("No image to save")
            return
        }

        guard let userID = authVM.currentUser?.id else {
            print("No authenticated user ID")
            return
        }

        var likedPhotoID: UUID? = nil

        do {
            likedPhotoID = try await PhotoViewModel().fetchLikedPhotoID(userId: userID, unsplashID: photo.id)

            print("Current supabase auth user:", authVM.currentUser?.id.uuidString ?? "No user")
            print("created_user to insert:", userID.uuidString)
            
            try await viewModel.saveFilteredPhoto(
                ciImage: ciImage,
                likedPhotoID: likedPhotoID, // Pass nil if not liked
                userID: userID,
                photo: photo,
                filterName: currentFilter.name,
                originalURL: photo.urls.regular
            )

            print("✅ Image saved to Supabase")

        } catch {
            print("❌ Failed to save: \(error.localizedDescription)")
        }
    }

    
    
    var body: some View {
        ScrollView {
            VStack(spacing:16) {
                if let processedImage {
                    processedImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            HStack {
                                Spacer()
                                VStack{
                                    Button(action: {
                                        dismiss()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.white)
                                            .background(
                                                Color.black.opacity(0.6)
                                            )
                                            .clipShape(Circle())
                                    }
                                    .padding()
                                    .padding(.trailing, 10)
                                    .offset(y: 40)
                                    Spacer()
                                }
                            }
                        )
                } else {
                    ContentUnavailableView(
                        "No Picture",
                        systemImage: "photo.badge.plus"
                    )
                }
            }
            .onAppear {
                Task{
                    await loadURLImage()
                }
            }
            
            Spacer()
            
            Group{
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of:filterIntensity, applyProcessing)
                        .disabled(!hasImage)
                }
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius, in: 0...200)
                        .onChange(of: filterRadius, applyProcessing)
                        .disabled(processedImage == nil)
                }
                
                HStack {
                    Text("Scale")
                    Slider(value: $filterScale, in: 0...10)
                        .onChange(of: filterScale, applyProcessing)
                        .disabled(processedImage == nil)
                }
                
                HStack {
                    Button("Change Filter", action:changeFilter)
                        .disabled(!hasImage)
                    
                    Spacer()
                    if processedImage != nil {
                        Button("Save") {
                            Task{
                                await saveFilteredImage()
                                dismiss()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    
                }
                
            }
            .padding()
            
        }
        .confirmationDialog("Select a filter", isPresented: $showingFilters) {
            Button("Crystallize") { Task { await setFilter(CIFilter.crystallize()) } }
            Button("Edges") { Task { await setFilter(CIFilter.edges()) } }
            Button("Gaussian Blur") { Task { await setFilter(CIFilter.gaussianBlur()) } }
            Button("Pixellate") { Task { await setFilter(CIFilter.pixellate()) } }
            Button("Sepia Tone") { Task { await setFilter(CIFilter.sepiaTone()) } }
            Button("Unsharp Mask") { Task { await setFilter(CIFilter.unsharpMask()) } }
            Button("Vignette") { Task { await setFilter(CIFilter.vignette()) } }
            Button("Bloom") { Task { await setFilter(CIFilter.bloom()) } }
            Button("Color Invert") { Task { await setFilter(CIFilter.colorInvert()) } }
            Button("Color Monochrome") { Task { await setFilter(CIFilter.colorMonochrome()) } }
            
            Button("Cancel", role: .cancel) { }
        }
        
        .ignoresSafeArea(edges:.top)
    }
}

#Preview {
    return FilterPhotoView(authVM: SupabaseAuthViewModel(), photo: MockData.mockPhoto)
}
