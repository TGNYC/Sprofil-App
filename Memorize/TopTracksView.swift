//
//  TopTracks.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/20/22.
//

import SwiftUI

struct TopTrackInfo: Identifiable {
    var trackName: String
    // For Each Artist: [Name, ExternalURL]
    var artistsInfo: [[String]]
    // For the Album: [Album Name, AlbumImgURL, ReleaseDate, NumTracks, LinkToSpot]
    var albumInfo: [String]
    // For the album artists: [Name, ExternalURL]
    var albumArtists: [String]
    var imageURL: String
    var duration: String
    var explicit: String
    var linkToSpot: String
    var popularity: String
    var previewURL: String
    var id: String { trackName }
    
    init(info: [Any]) {
        self.trackName = info[0] as? String ?? "NULL"
        self.artistsInfo = info[1] as? [[String]] ?? []
        self.albumInfo = info[2] as? [String] ?? []
        self.albumArtists = info[3] as? [String] ?? []
        self.imageURL = info[4] as? String ?? "NULL"
        print(imageURL)
        self.duration = info[5] as? String ?? "NULL"
        self.explicit = info[6] as? String ?? "NULL"
        self.linkToSpot = info[7] as? String ?? "NULL"
        self.popularity = info[8] as? String ?? "NULL"
        self.previewURL = info[9] as? String ?? "NULL"
    }
    
    mutating func FillValues(info: [Any]) {
        self.trackName = info[0] as? String ?? "NULL"
        self.artistsInfo = info[1] as? [[String]] ?? []
        self.albumInfo = info[2] as? [String] ?? []
        self.albumArtists = info[3] as? [String] ?? []
        self.imageURL = info[4] as? String ?? "NULL"
        print(imageURL)
        self.duration = info[5] as? String ?? "NULL"
        self.explicit = info[6] as? String ?? "NULL"
        self.linkToSpot = info[7] as? String ?? "NULL"
        self.popularity = info[8] as? String ?? "NULL"
        self.previewURL = info[9] as? String ?? "NULL"
    }
}

struct TopTracksView: View {
    var firebase: FirebaseAPI
    @State var showDetailed: Bool = false
    var topTracks: [TopTrackInfo] = []
    @State var infoDisplay: TopTrackInfo = TopTrackInfo(info: ["NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL"])
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        let info = firebase.GetTopTrackInfo()
        for obj in info {
            topTracks.append(TopTrackInfo(info: obj))
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Tracks").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topTracks) { info in
                        VStack() {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                                infoDisplay = info
                                showDetailed = true
                            }, label: {
                                AsyncImage(url: URL(string: info.imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            })
                                .sheet(isPresented: $showDetailed) {
                                    DetailedTrackView(trackName: $infoDisplay.trackName, artistsInfo: $infoDisplay.artistsInfo, albumInfo: $infoDisplay.albumInfo, albumArtists: $infoDisplay.albumArtists, imageURL: $infoDisplay.imageURL, duration: $infoDisplay.duration, explicit: $infoDisplay.explicit, linkToSpot: $infoDisplay.linkToSpot, popularity: $infoDisplay.popularity, previewURL: $infoDisplay.previewURL)
                                }
                            Text(info.trackName).font(.callout)
                        }
                    }
                        .frame(width:80, height:125)
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
    @State var showDetailed: Bool = false
    var topTracks: [TopTrackInfo] = []
    @State var infoDisplay: TopTrackInfo = TopTrackInfo(info: ["NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL"])
    var profName: String
    
    init(firebase: FirebaseAPI, profName: String) {
        self.firebase = firebase
        self.profName = profName
        let info = firebase.GetOtherTopTrackInfo(userID: firebase.GetUserID(profName: profName))
        for obj in info {
            topTracks.append(TopTrackInfo(info: obj))
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Tracks").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topTracks){ info in
                        GeometryReader { geometry in
                        VStack() {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                infoDisplay = info
                                showDetailed = true
                            }, label: {
                                AsyncImage(url: URL(string: info.imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            })
                                .sheet(isPresented: $showDetailed) {
                                    DetailedTrackView(trackName: $infoDisplay.trackName, artistsInfo: $infoDisplay.artistsInfo, albumInfo: $infoDisplay.albumInfo, albumArtists: $infoDisplay.albumArtists, imageURL: $infoDisplay.imageURL, duration: $infoDisplay.duration, explicit: $infoDisplay.explicit, linkToSpot: $infoDisplay.linkToSpot, popularity: $infoDisplay.popularity, previewURL: $infoDisplay.previewURL)
                                }
                            Text(info.trackName).font(.callout)
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
