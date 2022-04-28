//
//  DetailedView.swift
//  Sprofil
//
//  Created by Ben Shi on 4/6/22.
//

import SwiftUI
import AVKit

struct DetailedArtistView: View {
    // INSERT THINGS TO BE PASSED IN
    @Binding var imageURLs: [String]
    @Binding var detailedTitle: String
    @Binding var topGenres: [String]
    @Binding var followers: String
    @Binding var linkToSpot: String
    @Binding var popularity: String
    
//    init() {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//    }
    
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
//        Text("Genres: " + topGenres[0] + ", " + topGenres[1])
            .padding()
        Text("Followers: " + followers)
            .padding()
        Text("Popularity Score: " + popularity + "/100")
            .padding()
        Link("Spotify Profile", destination: URL(string: linkToSpot)!)
            .padding()
    }
    
//    func addCommas() -> String {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        return numberFormatter.string(from: NSNumber(value:self))!
//    }
}

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
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
    @State var song = false
    @StateObject private var soundManager = SoundManager()
    
//    private var artistList: String {
//        if (artistsInfo.isEmpty) {
//            return ""
//        }
//        var list : String = artistsInfo[0][0]
//        if (artistsInfo.count > 1) {
//            ForEach(1..<artistsInfo.count) { i in
//                list = list + "," + artistsInfo[i][0]
//            }
//        }
//    }
    
    var body: some View {
//            ScrollView {
                HStack(spacing: 20) {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image.resizable()
                        .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 180, height: 180)
//                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
//                    .clipped()
//x                    .padding(.top, 4)
                }
                
                Text(trackName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
//                    .padding(.bottom, 5)
                    .lineSpacing(1)
//                    .font(.system(size: 20)
//                            .bold())
//                    .padding(.top, 8)
                HStack(spacing: 1) {
                    ForEach(artistsInfo, id: \.self){ info in
                        Text(info[0])
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                
                Group {
                    Text("From the album ")
                        .fontWeight(.light)
                    + Text(albumInfo[0])
                        .fontWeight(.regular)
                        .italic()
                }
                    .padding(.leading, 10)
                    .padding(.bottom, 5)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
        
//                Text("From ")
//                    .font(.title)
//                    .fontWeight(.light)
//
//                Text(albumInfo[0])
//                    .font(.title)
//                    .fontWeight(.regular)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack() {
                    Group {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.gray)
                            .overlay(
                                VStack() {
                                    Text("Duration:").bold()
                                    Text(duration)
                                }.font(.body)
                                    .foregroundColor(Color.white)
                            )
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.gray)
                            .overlay(
                                VStack() {
                                    Text("Popularity:").bold()
                                    Text(popularity + "/100")
                                }.font(.body)
                                    .foregroundColor(Color.white)
                            )
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.gray)
                            .overlay(
                                VStack() {
                                    Text("Release Date:").bold()
                                    Text(albumInfo[2])
                                }   .font(.body)
                                    .foregroundColor(Color.white)
                            )
                    }
                        .frame(maxWidth: .infinity)
//                        .border(Color.red)
//                        .background(Color.gray)
//                        .foregroundColor(Color.white)
//                        .font(.body)
                        .padding(1)
                        .cornerRadius(2)
                    
                }
        
        HStack() {
            Image(systemName: song ? "pause.circle.fill": "play.circle.fill")
                .font(.system(size: 50))
//                        .font(.title)
                .foregroundColor(Color.green)
                .padding(.trailing)
                .onTapGesture {
                    soundManager.playSound(sound: previewURL)
                    song.toggle()
                    if song {
                        soundManager.audioPlayer?.play()
                    } else {
                        soundManager.audioPlayer?.pause()
                    }
                }
            
            Link(destination: URL(string: linkToSpot)!) {
                Text("View in Spotify")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .padding(10)
            }
        }
                
//                HStack() {
//                    Text("Listen to a Sample: ")
//                        .font(.title)
//
//                    Image(systemName: song ? "pause.circle.fill": "play.circle.fill")
//                        .font(.system(size: 50))
////                        .font(.title)
//                        .foregroundColor(Color.green)
//                        .padding(.trailing)
//                        .onTapGesture {
//                            soundManager.playSound(sound: previewURL)
//                            song.toggle()
//                            if song {
//                                soundManager.audioPlayer?.play()
//                            } else {
//                                soundManager.audioPlayer?.pause()
//                            }
//                        }
//
//                }
//
//                Link(destination: URL(string: linkToSpot)!) {
//                    Text("View Track in Spotify")
//                        .fontWeight(.bold)
//                        .font(.title)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(40)
//                        .padding(10)
//                }
                
                
                
//                Text("Explicit: " + explicit)
//                    .padding()
//                Text("Popularity Score: " + popularity)
//                    .padding()
//                Link("Spotify Profile", destination: URL(string: linkToSpot)!)
//                    .padding()
                
//                Group {
//                Text("From Album: " + albumInfo[0])
//                    .font(.system(size: 20)
//                            .bold())
//                    .padding(.top, 8)
//                AsyncImage(url: URL(string: albumInfo[1])) { image in
//                    image.resizable()
//                } placeholder: {
//                    Color.gray
//                }
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 180, height: 180)
//                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 30,height: 30)))
//                .clipped()
//                .padding(.top, 4)
//
//                Text("Release Date: " + albumInfo[2])
//                    .padding()
//                Text("Num Tracks: " + albumInfo[3])
//                    .padding()
//                Link("Spotify Profile", destination: URL(string: linkToSpot)!)
//                    .padding()
//                }
            }
//        }
}

struct DetailedArtistView_Previews: PreviewProvider {
    static var previews: some View {
        Text("asdfa")
    }
}
