//
//  TopArtists.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/20/22.
//

import SwiftUI
import Firebase

struct TopArtistInfo {
    var imageURLs: [String]
    var detailedTitle: String
    var topGenres: [String]
    var followers: String
    var linkToSpot: String
    var popularity: String
    
    mutating func FillValues(imageURLs: [String], detailedTitle: String, topGenres: [String], followers: String, linkToSpot: String, popularity: String) {
        self.imageURLs = imageURLs
        self.detailedTitle = detailedTitle
        self.topGenres = topGenres
        self.followers = followers
        self.linkToSpot = linkToSpot
        self.popularity = popularity
    }
}

struct TopArtistsView: View {
    var firebase: FirebaseAPI
    @State var showDetailed: Bool = false
    var topArtists: [[String]] = []
    @State var infoDisplay: TopArtistInfo = TopArtistInfo(imageURLs: ["NULL"], detailedTitle: "NULL", topGenres: ["NULL"], followers: "NULL", linkToSpot: "NULL", popularity: "NULL")
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        topArtists = firebase.GetTopArtistInfo()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Artists").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topArtists, id: \.self){ info in
                        VStack() {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                                infoDisplay.FillValues(imageURLs: [info[1], info[2], info[3]], detailedTitle: info[0], topGenres: [info[6], info[7]], followers: info[5], linkToSpot: info[4], popularity: info[8])
                                showDetailed = true
                            }, label: {
                            AsyncImage(url: URL(string: info[1])) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            })
                                .sheet(isPresented: $showDetailed) {
                                    DetailedArtistView(imageURLs: $infoDisplay.imageURLs, detailedTitle: $infoDisplay.detailedTitle, topGenres: $infoDisplay.topGenres, followers: $infoDisplay.followers, linkToSpot: $infoDisplay.linkToSpot, popularity: $infoDisplay.popularity)
                                }
                            Text(info[0]).font(.callout)
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

struct OtherTopArtistsView: View {
    var firebase: FirebaseAPI
    @State var showDetailed: Bool = false
    var topArtists: [[String]] = []
    @State var infoDisplay: TopArtistInfo = TopArtistInfo(imageURLs: ["NULL"], detailedTitle: "NULL", topGenres: ["NULL"], followers: "NULL", linkToSpot: "NULL", popularity: "NULL")
    var profName: String
    
    init(firebase: FirebaseAPI, profName: String) {
        self.firebase = firebase
        self.profName = profName
        topArtists = firebase.GetOtherTopArtistInfo(userID: firebase.GetUserID(profName: profName))
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Artists").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(topArtists, id: \.self){ info in
                        GeometryReader { geometry in
                        VStack() {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()
                                showDetailed = true
                            }, label: {
                                // IN ORDER: NAME, IMAGE1URL, IMAGE2URL, IMAGE3URL, SPOTIFY_LINK, FOLLOWERS, GENRE1, GENRE2, POPULARITY
                                AsyncImage(url: URL(string: info[1])) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
                            })
                                .sheet(isPresented: $showDetailed) {
                                    DetailedArtistView(imageURLs: $infoDisplay.imageURLs, detailedTitle: $infoDisplay.detailedTitle, topGenres: $infoDisplay.topGenres, followers: $infoDisplay.followers, linkToSpot: $infoDisplay.linkToSpot, popularity: $infoDisplay.popularity)
                                }
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

struct TopArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        let firebase = FirebaseAPI()
        TopArtistsView(firebase: firebase)
    }
}
