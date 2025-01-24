//
//  ImageManager.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import UIKit

final class ImageManager {
    
    private func nameImagePath() -> String {
        guard let imagePath = String(Date.now.timeIntervalSince1970).split(separator: ".").first else { return UUID().uuidString }
        
        return String(imagePath)
    }
    
    func saveImage(_ image: UIImage) {
        
    }
    
    private func resizeImage(_ image: UIImage) -> UIImage? {
        return nil
    }
}
