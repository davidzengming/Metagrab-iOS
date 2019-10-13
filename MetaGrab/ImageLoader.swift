//
//  ImageLoader.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    let objectWillChange = PassthroughSubject<ImageLoader?, Never>()
    var downloadedImage: UIImage?
    
    func load(url: String) {
        if self.downloadedImage != nil {
            return
        }
        
        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.objectWillChange.send(nil)
                }
                return
            }
            
            self.downloadedImage = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
        }.resume()
    }
}
