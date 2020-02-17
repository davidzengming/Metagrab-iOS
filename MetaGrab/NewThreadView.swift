//
//  NewThreadView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-09-03.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct NewThreadView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    @State var title: String = ""
    @State var flair = 0
    @State var content: NSTextStorage = NSTextStorage(string: "")

    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    @State var data: Data? = nil
    
    var forumId: Int
    var flairs = ["Update", "Discussion", "Meme"]
    var imageThread = ["Text", "Image"]
    let placeholder = Image(systemName: "photo")
    
    func submitThread() {
        self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: content, imageData: data)
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
                    ZStack {
                        self.image?.resizable()
                            .frame(width: 100, height: 100, alignment: .leading)
                        Button(action: {
                            withAnimation {
                                self.showImagePicker.toggle()
                            }
                        }) {
                            UploadDashPlaceholderButton()
                            .foregroundColor(Color.gray)
                            .frame(width: 100, height: 100, alignment: .leading)
                            .opacity(self.image == nil ? 1 : 0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: self.$showImagePicker) {
                        ImagePicker(image: self.$image, data: self.$data)
                    }
                    Spacer()
                }

                FancyPantsEditorView(newTextStorage: self.$content, isEditable: .constant(true), isNewContent: true, isThread: true, isFirstResponder: true)
                    .frame(minWidth: 0, maxWidth: a.size.width, minHeight: 0, maxHeight: a.size.height * 0.5, alignment: .leading)
                    .background(Color.white)
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
