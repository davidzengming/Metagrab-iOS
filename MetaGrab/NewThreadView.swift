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
    @State var content: String = ""
    var forumId: Int
    var flairs = ["Update", "Discussion", "Meme"]
    
    func submitThread() {
        self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: content)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            TextField("What do you want to say?", text: $title)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.leading, 50)
            .padding(.trailing, 50)
            
            Picker("Flair", selection: $flair) {
                ForEach(0 ..< flairs.count) { index in
                    Text(self.flairs[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 50)

            TextField("Expand your post in more detail.", text: $content)
            .frame(width: 300, height: 400)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .lineLimit(5)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.all, 50)
            .fixedSize()
            
            Button(action: submitThread) {
                Text("SUBMIT")
            }
            .padding(.all, 50)
            .background(Color.yellow)
            .cornerRadius(5)
            
        }.navigationBarTitle(Text("Create a New Thread"))
    }
}
