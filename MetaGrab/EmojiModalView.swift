//
//  EmojiModalView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-30.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct EmojiModalView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            Text("Emojis")
                .padding()
            
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(self.gameDataStore.emojiArray, id: \.self) { emojiName in
                            Image(uiImage: self.gameDataStore.emojis[emojiName]!)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    
                                    self.showModal.toggle()
                            }
                        }
                    }
                }
            }
            
            Button("Dismiss") {
                self.showModal.toggle()
            }
        }
    }
}
