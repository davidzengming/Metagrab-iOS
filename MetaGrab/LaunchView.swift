//
//  LaunchView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        MainView().environmentObject(UserDataStore())
    }
}
