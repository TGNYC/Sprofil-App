//
//  ExploreView.swift
//  Sprofil
//
//  Created by Ben Shi on 4/17/22.
//

import Foundation
import SwiftUI

struct UserInfo: Identifiable {
    var userID: String
    var imageURL: String
    
    var id: String { imageURL }
}

struct ExploreView: View {
    @StateObject var firebase: FirebaseAPI = FirebaseAPI()
    var exploreInfo: [UserInfo] = []
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    init() {
        let info = firebase.GetExploreInfo()
        if (info.count > 0) {
            for obj in info {
                let newObj = obj as? [String] ?? []
                exploreInfo.append(UserInfo(userID: newObj[0] as String, imageURL: newObj[1] as String))
            }
        }
    }
    
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            NavigationView {
                ScrollView {
                    Text("Explore")
                        .font(.title)
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(exploreInfo) { info in
                            NavigationLink(destination: OtherProfileView(profName:"ameyav993")) {
                                AsyncImage(url: URL(string: info.imageURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
