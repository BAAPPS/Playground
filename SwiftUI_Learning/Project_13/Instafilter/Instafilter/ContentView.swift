//
//  ContentView.swift
//  Instafilter
//
//  Created by D F on 7/14/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit

struct ContentView: View {
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
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

    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }

    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }

    
    func changeFilter() {
        showingFilters = true
    }

   @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1

        if filterCount >= 10 {
            requestReview()
        }
    }


    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                    }
                }
                .onChange(of: selectedItem, loadImage)

                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of:filterIntensity, applyProcessing)
                        .disabled(!hasImage)
                }
                .padding(.vertical)
                
                HStack {
                    Text("Radius")
                    Slider(value: $filterRadius, in: 0...200)
                        .onChange(of: filterRadius, applyProcessing)
                        .disabled(processedImage == nil)
                }
                .padding(.vertical)

                HStack {
                    Text("Scale")
                    Slider(value: $filterScale, in: 0...10)
                        .onChange(of: filterScale, applyProcessing)
                        .disabled(processedImage == nil)
                }
                .padding(.vertical)

                
                HStack {
                    Button("Change Filter", action:changeFilter)
                        .disabled(!hasImage)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }

                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Color Invert") { setFilter(CIFilter.colorInvert()) }
                Button("Color Monochrome") { setFilter(CIFilter.colorMonochrome()) }

                Button("Cancel", role: .cancel) { }

            }
        }
    }
}

#Preview {
    ContentView()
}
