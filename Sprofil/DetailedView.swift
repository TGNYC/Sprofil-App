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
    
    func ProcessFollowerString(followers: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:Int(followers) ?? 0))
        return formattedNumber ?? "0"
    }
    
    func DetermineColor() -> Color {
        let num = Int(popularity) ?? 0
        if num >= 85 {
            return Color.green
        }
        else if num >= 70 {
            return Color.yellow
        }
        else if num >= 55 {
            return Color.orange
        }
        else if num >= 40 {
            return Color.red
        }
        else {
            return Color.gray
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: imageURLs[0])) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(1, contentMode: .fill)
        }
        Text(detailedTitle)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.green)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        //                    .padding(.bottom, 5)
            .lineSpacing(1)
        VStack() {
            Group {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(DetermineColor())
                    .overlay(
                        HStack() {
                            Text("Followers:").bold()
                            Text(followers)
                        }.font(.body)
                            .foregroundColor(Color.white)
                    )
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(DetermineColor())
                    .overlay(
                        HStack() {
                            Text("Popularity:").bold()
                            Text(popularity + "/100")
                        }.font(.body)
                            .foregroundColor(Color.white)
                    )
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(DetermineColor())
                    .overlay(
                        HStack() {
                            Text("Top Genres:").bold()
                            ForEach(topGenres, id: \.self){ genre in
                                if genre != "NULL" {
                                    Text(genre)
                                }
                                else {
                                    Text("N/A")
                                }
                            }
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
    
    func DetermineColor() -> Color {
        let num = Int(popularity) ?? 0
        if num >= 85 {
            return Color.green
        }
        else if num >= 70 {
            return Color.yellow
        }
        else if num >= 55 {
            return Color.orange
        }
        else if num >= 40 {
            return Color.red
        }
        else {
            return Color.gray
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .aspectRatio(1, contentMode: .fill)
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
                    .fill(DetermineColor())
                    .overlay(
                        VStack() {
                            Text("Duration:").bold()
                            Text(duration)
                        }.font(.body)
                            .foregroundColor(Color.white)
                    )
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(DetermineColor())
                    .overlay(
                        VStack() {
                            Text("Popularity:").bold()
                            Text(popularity + "/100")
                        }.font(.body)
                            .foregroundColor(Color.white)
                    )
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(DetermineColor())
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
    }
}

struct DetailedArtistView_Previews: PreviewProvider {
    static var previews: some View {
        Text("asdfa")
    }
}
