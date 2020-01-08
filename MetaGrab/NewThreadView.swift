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
    @State var content: NSMutableString = ""
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    @State var data: Data? = nil
    @State var isImageThread = 0
    
    @State var isBold = false
    @State var isNumberedBulletList = false
    @State var didChangeBold = false
    @State var didChangeNumberedBulletList = false
    
    var forumId: Int
    var flairs = ["Update", "Discussion", "Meme"]
    var imageThread = ["Text", "Image"]
    let placeholder = Image(systemName: "photo")
    
    func submitThread() {
        if isImageThread == 0 {
            self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: content as String, imageData: nil)
        } else {
            self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: "", imageData: data)
        }

        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            TextField("What do you want to say?", text: $title)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.top, 30)
            .padding(.leading, 50)
            .padding(.trailing, 50)
            .padding(.bottom, 20)
            
            Picker("Flair", selection: $flair) {
                ForEach(0 ..< flairs.count) { index in
                    Text(self.flairs[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 50)
            
            Picker("Image", selection: $isImageThread) {
                ForEach(0 ..< imageThread.count) { index in
                    Text(self.imageThread[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 50)
            
            if self.isImageThread == 0 {
                VStack {
                    FancyPantsEditorBarView(isBold: $isBold, isNumberedBulletList: $isNumberedBulletList, didChangeBold: $didChangeBold, didChangeNumberedBulletList: $didChangeNumberedBulletList)
                    TextView(
                        text: $content,
                        isBold: $isBold,
                        isNumberedBulletList: $isNumberedBulletList,
                        didChangeBold: $didChangeBold,
                        didChangeNumberedBulletList: $didChangeNumberedBulletList,
                        textStorage: NSTextStorage()
                    )
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                             .stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal, 50)
                }
            } else {
                ZStack {
                    image?.resizable()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    Button(action: {
                        withAnimation {
                            self.showImagePicker.toggle()
                        }
                    }) {
                        self.placeholder
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .cornerRadius(5)
                        .opacity(self.image == nil ? 1 : 0)
                    }
                }
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 5)
                         .stroke(Color.black, lineWidth: 1))
                .padding(.horizontal, 50)
                
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: self.$image, data: self.$data)
                }
            }
            
            Button(action: submitThread) {
                Text("SUBMIT")
                    .font(.headline)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            }
            .background(Color.yellow)
            .cornerRadius(10)
            .padding(.all, 50)
        }
        .background(Image(uiImage: UIImage(named: "background")!).resizable(resizingMode: .tile))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text("Create a New Thread"))
    }
}
