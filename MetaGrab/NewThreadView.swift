//
//  NewThreadView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-09-03.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct IdentifiableImageContainer: Identifiable {
    var id = UUID()
    var image: Image?
    var arrayIndex: Int
}

struct NewThreadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    @State var title: String = ""
    @State var flair = 0
    @State var content: NSTextStorage = NSTextStorage(string: "")
    
    @State var showImagePicker = false
    @State var imagesDict: [UUID: Image] = [:]
    @State var dataDict: [UUID: Data] = [:]
    @State var imagesArray: [UUID] = [UUID()]
    @State var clickedImageIndex : Int?
    
    var forumId: Int
    var flairs = ["Update", "Discussion", "Meme"]
    var imageThread = ["Text", "Image"]
    let placeholder = Image(systemName: "photo")
    
    func submitThread() {
        self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: content, imageData: dataDict, imagesArray: imagesArray)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        GeometryReader { a in
            VStack {
                TextField("Add a title! (Optional)", text: self.$title)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                
                HStack {
                    ForEach(self.imagesArray, id: \.self) { id in
                        ZStack {
                            if self.imagesDict[id] != nil {
                                self.imagesDict[id]!.resizable()
                                    .frame(width: 100, height: 100, alignment: .leading)
                            }
                            Button(action: {
                                self.clickedImageIndex = self.imagesArray.firstIndex(of: id)!
                                withAnimation {
                                    self.showImagePicker.toggle()
                                }
                            }) {
                                UploadDashPlaceholderButton()
                                    .foregroundColor(Color.gray)
                                    .frame(width: 100, height: 100, alignment: .leading)
                                    .opacity(self.imagesDict[id] != nil ? 0.5 : 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    Spacer()
                }
                .sheet(isPresented: self.$showImagePicker) {
                    ImagePicker(image: self.$imagesDict[self.imagesArray[self.clickedImageIndex!]], data: self.$dataDict[self.imagesArray[self.clickedImageIndex!]], currentImages: self.$imagesArray, imagesDict: self.$imagesDict, dataDict: self.$dataDict)
                }
                .padding(.horizontal, 20)
                
                FancyPantsEditorView(newTextStorage: self.$content, isEditable: .constant(true), isNewContent: true, isThread: true, isFirstResponder: true)
                    .frame(minWidth: 0, maxWidth: a.size.width, minHeight: 0, maxHeight: a.size.height * 0.5, alignment: .leading)
                    .cornerRadius(5, corners: [.bottomLeft, .bottomRight, .topLeft, .topRight])
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                )
                    .padding(.vertical, 25)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(Text("Post to \(self.gameDataStore.games[self.forumId]!.name)"))
            .navigationBarItems(trailing: Button(action: self.submitThread) {
                Text("Submit")
            })
        }
    }
}
