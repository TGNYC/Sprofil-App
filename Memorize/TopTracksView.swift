//
//  TopTracks.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/20/22.
//

import SwiftUI

struct TopTracksView: View {
    var firebase: FirebaseAPI
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Tracks").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(firebase.GetTopTrackInfo(), id: \.self){ info in
                        GeometryReader { geometry in
                        VStack() {
                            AsyncImage(url: URL(string: info[1])) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            Text(info[0]).font(.callout)
                        }
                    }
                        .frame(width:80, height:125)
                    }
                }
            }
        }
        .padding()
        .padding(.horizontal, 5)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
        .background(.ultraThinMaterial)
        .cornerRadius(50)
    }
}

struct OtherTopTracksView: View {
    var firebase: FirebaseAPI
    var profName: String
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Tracks").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(firebase.GetOtherTopTrackInfo(userID: firebase.GetUserID(profName: profName)), id: \.self){ info in
                        GeometryReader { geometry in
                        VStack() {
                            AsyncImage(url: URL(string: info[1])) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            Text(info[0]).font(.callout)
                        }
                    }
                        .frame(width:80, height:125)
                    }
                }
            }
        }
        .padding()
        .padding(.horizontal, 5)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 20)
        .background(.ultraThinMaterial)
        .cornerRadius(50)
    }
}

struct TopTracksView_Previews: PreviewProvider {
    static var previews: some View {
        let firebase = FirebaseAPI()
        TopTracksView(firebase: firebase)
    }
}
