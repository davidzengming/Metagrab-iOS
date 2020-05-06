import SwiftUI

// Entry point into view
struct MainView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    
    @State var showImagePicker: Bool = false
    @State var textStorage: NSTextStorage = NSTextStorage(string: "")
    @State var text: String = ""
    
    var body: some View {
        VStack {
            if self.userDataStore.isAuthenticated == false {
                UserView()
            } else {
                GameHubView()
                    .environmentObject(GameDataStore())
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
