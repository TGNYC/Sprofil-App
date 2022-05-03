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
    let gradient = Gradient(colors: [Color("Rose"), Color("Anna")])
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            NavigationView {
                ScrollView {
                    Text("Explore")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Each of the images below represents a Sprofil User obsessed with that Artist. Click on the image to find out who!")
                        .padding()
                        .foregroundColor(.white)
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(firebase.GetExploreInfo()) { info in
                            NavigationLink(destination: OtherProfileView(profName:firebase.GetOtherProfName(userID: info.userID))) {
                                AsyncImage(url: URL(string: info.imageURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .font(.system(size: 30))
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
                            }
                        }
                    }
                }
                .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
