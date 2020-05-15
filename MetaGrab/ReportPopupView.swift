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
    
    func dismissView() {
        if forumId != nil {
            self.gameDataStore.isReportPopupActiveByForumId[forumId!] = false
        } else {
            self.gameDataStore.isReportPopupActiveByThreadId[threadId!] = false
            self.gameDataStore.isLastClickedReportThreadInThreadViewByThreadId[threadId!] = false
        }
    }
    
    func submitReport() {
        if forumId != nil {
            self.gameDataStore.sendReportByThreadId(access: self.userDataStore.token!.access, threadId: self.gameDataStore.lastClickedReportThreadByForumId[forumId!]!, reason: reportReason)
        } else {
            if self.gameDataStore.isLastClickedReportThreadInThreadViewByThreadId[threadId!]! == true {
                self.gameDataStore.sendReportByThreadId(access: self.userDataStore.token!.access, threadId: threadId!, reason: reportReason)
            } else {
                self.gameDataStore.sendReportByCommentId(access: self.userDataStore.token!.access, commentId: self.gameDataStore.lastClickedReportCommentByThreadId[threadId!]!, reason: reportReason)
            }
        }
        
        self.dismissView()
    }
    
    var body: some View {
        GeometryReader { a in
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: "multiply")
                    .resizable()
                    .frame(width: a.size.height * 0.1, height: a.size.height * 0.1)
                        .foregroundColor(.white)
                        .onTapGesture {
                            self.dismissView()
                    }
                    Spacer()
                }
                .frame(width: a.size.width * 0.9, height: a.size.height * 0.1, alignment: .leading)
                .padding(.horizontal, a.size.width * 0.05)
                .padding(.vertical, a.size.height * 0.05)

                HStack {
                    Spacer()
                    Text("Submit a report")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                 
                TextField("Enter the reason", text: self.$reportReason)
                    .frame(width: a.size.width * 0.9)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                
                Button(action: self.submitReport) {
                    Text("Submit")
                    .padding(7)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                Spacer()
            }
        }
    }
}
