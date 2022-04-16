//
//  OtherProfileView.swift
//  Sprofil
//
//  Created by Ben Shi on 3/31/22.
//

import SwiftUI

struct OtherProfileView: View {
    @StateObject var firebase = FirebaseAPI()
    let profName: String
    
    init(profName: String) {
        self.profName = profName
    }
    
    let gradient = Gradient(colors: [.orange, .purple])
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            VStack {
                OtherProfTitleView(firebase: firebase, profName: profName)
                ScrollView {
                    if firebase.GetOtherWidgetStatus(widgetName: "TopArtists", userID: firebase.GetUserID(profName: profName)) {
                    OtherTopArtistsView(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopTracks", userID: firebase.GetUserID(profName: profName)) {
                        OtherTopTracksView(firebase: firebase, profName: profName)
                    }
                    if firebase.GetOtherWidgetStatus(widgetName: "TopAlbums", userID: firebase.GetUserID(profName: profName)) {
                        OtherTopAlbumsView(firebase: firebase, profName: profName)
                    }
                }
                Spacer()
            }
            .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        }
    }
}

struct OtherProfTitleView: View {
    let firebase : FirebaseAPI
    let profName : String
    var body: some View {
        VStack {
            Image("Drake")
             .resizable()
             .aspectRatio(contentMode: .fill)
             .frame(width: 180, height: 180)
             .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
             .clipped()
             .padding(.top, 4)
            Text(profName)
                .font(.system(size: 20)
                        .bold())
                .foregroundColor(.white)
                .padding(.top, 8)
        }
    }
}

struct OtherProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OtherProfileView(profName: "SDLFKSJDF:LK")
    }
}
