//
//  ImagePicker.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-11-26.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @Binding var image: Image?
    @Binding var data: Data?
    @Binding var currentImages: [UUID]
    @Binding var imagesDict: [UUID: Image]
    @Binding var dataDict: [UUID: Data]
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var data: Data?
        @Binding var currentImages: [UUID]
        @Binding var imagesDict: [UUID: Image]
        @Binding var dataDict: [UUID: Data]
        
        let maxNumImages = 3
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, data: Binding<Data?>, currentImages: Binding<[UUID]>, imagesDict: Binding<[UUID: Image]>, dataDict: Binding<[UUID: Data]>) {
            _presentationMode = presentationMode
            _image = image
            _data = data
            _currentImages = currentImages
            _imagesDict = imagesDict
            _dataDict = dataDict
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
                self.data = uiImage.pngData()
                
                if self.currentImages.count < self.maxNumImages {
                    let newImageId = UUID()
                    self.currentImages.append(newImageId)
                }
                self.presentationMode.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, data: $data, currentImages: $currentImages, imagesDict: $imagesDict, dataDict: $dataDict)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
