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
    @State var flair: String = ""
    @State var content: String = ""
    var forumId: Int
    
    func submitThread() {
        self.gameDataStore.submitThread(access:self.userDataStore.token!.access, forumId: forumId, title: title, flair: flair, content: content)
        self.presentationMode.value.dismiss()
    }
    
    var body: some View {
        VStack {
            Text("Title")
            TextField("title", text: $title)
            .autocapitalization(.none)
            
            Text("Flair - Pick 1 of meme, update, or discussion")
            TextField("flair", text: $flair)
            .autocapitalization(.none)
            
            Text("Content")
            TextField("content", text: $content)
            .frame(width: 300, height: 500)
            .autocapitalization(.none)
            .lineLimit(5)
            
            Button(action: submitThread) {
                Text("Submit post")
            }
        }.navigationBarTitle(Text("Post a new thread"))
    }
}
