//
//  DetailedView.swift
//  Sprofil
//
//  Created by Ben Shi on 4/6/22.
//

import SwiftUI

struct DetailedArtistView: View {
    // INSERT THINGS TO BE PASSED IN
    @Binding var imageURLs: [String]
    @Binding var detailedTitle: String
    @Binding var topGenres: [String]
    @Binding var followers: String
    @Binding var linkToSpot: String
    @Binding var popularity: String
    
    var body: some View {
        VStack{
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: imageURLs[0])) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
                .clipped()
                .padding(.top, 4)
            }
        }
        Text(detailedTitle)
            .font(.system(size: 20)
                    .bold())
            .padding(.top, 8)
        Text("Genres: " + topGenres[0] + ", " + topGenres[1])
            .padding()
        Text("Followers: " + followers)
            .padding()
        Text("Popularity Score: " + popularity)
            .padding()
        Link("Spotify Profile", destination: URL(string: linkToSpot)!)
            .padding()
    }
}

struct DetailedTrackView: View {
    // INSERT THINGS TO BE PASSED IN
    @Binding var trackName: String
    // For Each Artist: [Name, ExternalURL]
    @Binding var artistsInfo: [[String]]
    // For the Album: [Album Name, AlbumImgURL, ReleaseDate, NumTracks, LinkToSpot]
    @Binding var albumInfo: [String]
    // For the album artists: [Name, ExternalURL]
    @Binding var albumArtists: [String]
    @Binding var imageURL: String
    @Binding var duration: String
    @Binding var explicit: String
    @Binding var linkToSpot: String
    @Binding var popularity: String
    @Binding var previewURL: String
    
    var body: some View {
            ScrollView {
                HStack(spacing: 20) {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
                    .clipped()
                    .padding(.top, 4)
                }
                Text(trackName)
                    .font(.system(size: 20)
                            .bold())
                    .padding(.top, 8)
                Text("Duration: " + duration)
                    .padding()
                Text("Explicit: " + explicit)
                    .padding()
                Text("Popularity Score: " + popularity)
                    .padding()
                Link("Spotify Profile", destination: URL(string: linkToSpot)!)
                    .padding()
                Text("From Album: " + albumInfo[0])
                    .font(.system(size: 20)
                            .bold())
                    .padding(.top, 8)
                AsyncImage(url: URL(string: albumInfo[1])) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
                .clipped()
                .padding(.top, 4)
                Text("Release Date: " + albumInfo[2])
                    .padding()
                Text("Num Tracks: " + albumInfo[3])
                    .padding()
//                Link("Link To Album", destination: URL(string: albumInfo[4])!)
//                    .padding()
            }
        }
}

struct DetailedArtistView_Previews: PreviewProvider {
    static var previews: some View {
        Text("asdfa")
    }
}
