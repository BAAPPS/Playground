//
//  FilteredPhotoViewModel.swift
//  SplashEdit
//
//  Created by D F on 7/20/25.
//

import Foundation
import Observation
import UIKit
import CoreImage
import Supabase

@Observable
class FilteredPhotoVM {
    private let client = SupabaseManager.shared.client
    private let context = CIContext()
    var filteredPhotos: [SupabaseFilteredModel] = []
    
    // Convert CIImage to JPEG Data
    func ciImageToJPEGData(_ ciImage: CIImage) -> Data? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("❌ Failed to create CGImage from CIImage")
            return nil
        }
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage.jpegData(compressionQuality: 0.8)
    }
    
    // Upload JPEG Data to Supabase storage and return public URL
    func uploadPublicFilteredImage(data: Data, fileName: String) async throws -> String {
        let bucket = client.storage.from("filtered-photos")
        
        // Check if file already exists
        let existingFiles = try await bucket.list()
        
        if existingFiles.contains(where: { $0.name == fileName }) {
            print("⚠️ File \(fileName) already exists, skipping upload.")
            
            // Return existing file public URL
            let baseURL = SupabaseManager.shared.url.absoluteString
            let publicURL = "\(baseURL)/storage/v1/object/public/filtered-photos/\(fileName)"
            return publicURL
        }
        
        // Upload new file
        let options = FileOptions(contentType: "image/jpeg")
        try await bucket.upload(fileName, data: data, options: options)
        
        // Return new file public URL
        let baseURL = SupabaseManager.shared.url.absoluteString
        let publicURL = "\(baseURL)/storage/v1/object/public/filtered-photos/\(fileName)"
        return publicURL
    }
    
    func fetchSignedURL(bucket: String, fileName: String, expiresIn: Int = 60) async throws -> String {
        guard let supabaseUrl = URL(string: SupabaseManager.shared.url.absoluteString) else {
            throw URLError(.badURL)
        }
        let apiKey = "YOUR SERVICE ROLE KEY HERE"
        
        let endpoint = supabaseUrl.appendingPathComponent("/storage/v1/object/sign/\(bucket)/\(fileName)")
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["expiresIn": expiresIn]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get signed URL"])
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        if let signedURL = json?["signedURL"] as? String {
            return signedURL
        } else {
            throw NSError(domain: "SupabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }
    }
    
    
    func uploadPrivateFilteredImage(data: Data, fileName: String, userID: UUID) async throws -> String {
        let bucketName = "filtered-photos"
        let bucket = client.storage.from(bucketName)
        
        // Check if file already exists
        let existingFiles = try await bucket.list()
        
        if existingFiles.contains(where: { $0.name == fileName }) {
            print("⚠️ File \(fileName) already exists, skipping upload.")
            
            // Generate signed URL for existing file
            return try await fetchSignedURL(bucket: bucketName, fileName: fileName)
        }
        
        let options = FileOptions(contentType: "image/jpeg",  metadata: ["user_id": AnyJSON.string(userID.uuidString)])
        try await bucket.upload(fileName, data: data, options: options)
        
        
        // Generate signed URL for new file
        return try await fetchSignedURL(bucket: bucketName, fileName: fileName)
    }
    
    
    func saveFilteredPhoto(
        ciImage: CIImage,
        likedPhotoID: UUID?,
        userID: UUID,
        photo: UnsplashPhotosModel,
        filterName: String,
        originalURL: String
    ) async throws {
        print("Entered saveFilteredPhoto")
        
        guard let imageData = ciImageToJPEGData(ciImage) else {
            print("❌ Failed to convert CIImage to JPEG Data")
            return
        }
        
        print("Image data conversion succeeded")
        print("Client current user id:", client.auth.currentUser?.id.uuidString ?? "No user")
        
        let safeFilterName = filterName.replacingOccurrences(of: " ", with: "_").lowercased()
        let prefix: String
        if let likedID = likedPhotoID {
            prefix = likedID.uuidString
        } else {
            prefix = "nolikedphoto_\(photo.id)_\(userID.uuidString)"
        }
        
        let fileName = "\(prefix)_\(safeFilterName).jpg"
        
        
        
        do {
            //            let privateFilteredURL = try await uploadPrivateFilteredImage(data: imageData, fileName: fileName, userID: userID)
            let filteredURL = try await uploadPublicFilteredImage(data: imageData, fileName: fileName)
            print("Image uploaded: \(filteredURL)")
            
            let filteredPhotoRecord = SupabaseFilteredModel(
                id: nil,
                liked_photo_id: likedPhotoID,
                created_user: userID,
                filtered_name: filterName,
                filtered_url: filteredURL,
                original_url: originalURL,
                created_at: nil
            )
            
            let response = try await client
                .from("filtered_photo")
                .insert(filteredPhotoRecord)
                .execute()
            
            print("🟢 Response from insert:", response)
            print("✅ Filtered photo saved to Supabase DB")
        } catch {
            print("❌ Error in saveFilteredPhoto: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchFilteredPhoto() async {
        guard let userId = client.auth.currentUser?.id else {
            print("User not logged in")
            return
        }
        
        do {
            let result: [SupabaseFilteredModel] = try await client
                .from("filtered_photo")
                .select()
                .eq("created_user", value: userId)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.filteredPhotos = result
            
            print(self.filteredPhotos)
            
        } catch {
            print("Error fetching liked photos: \(error)")
        }
    }
    
}
