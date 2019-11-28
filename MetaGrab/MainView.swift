import SwiftUI

// Entry point into view
struct MainView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        NavigationView {
            VStack {
                if self.userDataStore.isAuthenticated == false {
                    UserView()
                } else {
                    GameList().environmentObject(GameDataStore())
                }
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
