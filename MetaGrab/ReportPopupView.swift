//
//  ReportPopupView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-05-12.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct ReportPopupView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore

    var forumId: Int?
    var threadId: Int?
    
    @State var reportReason: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter the reason for the report: ", text: self.$reportReason)
        }
    }
}
