//
//  FavoriteGenreView.swift
//  Memorize
//
//  Created by Ben Shi on 4/27/22.
//

import SwiftUI

struct FavoriteGenreView: View {
    var firebase: FirebaseAPI
    var topGenres: [String] = []
    var topGenreScores: [String] = []
    
    init(firebase: FirebaseAPI) {
        self.firebase = firebase
        topGenres = firebase.GetTopGenres()
        print(topGenres)
        let topGenreScoresInt = firebase.GetTopGenresScores()
        for num in topGenreScoresInt {
            topGenreScores.append(String(num))
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Favorite Genres")
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            HStack {
                if (topGenres.count >= 3 && topGenreScores.count >= 3) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                    VStack {
                        Text(topGenres[1])
                        Text("Score: " + topGenreScores[1])
                    }
                    VStack {
                        Text(topGenres[2])
                        Text("Score: " + topGenreScores[2])
                    }
                } else if (topGenres.count >= 2 && topGenreScores.count >= 2) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                    VStack {
                        Text(topGenres[1])
                        Text("Score: " + topGenreScores[1])
                    }
                } else if (topGenres.count >= 1 && topGenreScores.count >= 1) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                } else {
                    Text("You have no top genres.")
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

struct OtherFavoriteGenreView: View {
    var firebase: FirebaseAPI
    var topGenres: [String] = []
    var topGenreScores: [String] = []
    var profName: String
    
    init(firebase: FirebaseAPI, profName: String) {
        self.firebase = firebase
        self.profName = profName
        topGenres = firebase.GetOtherTopGenres(userID: firebase.GetUserID(profName: profName))
        print(topGenres)
        let topGenreScoresInt = firebase.GetTopGenresScores()
        for num in topGenreScoresInt {
            topGenreScores.append(String(num))
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Favorite Genres")
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            HStack {
                if (topGenres.count >= 3 && topGenreScores.count >= 3) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                    VStack {
                        Text(topGenres[1])
                        Text("Score: " + topGenreScores[1])
                    }
                    VStack {
                        Text(topGenres[2])
                        Text("Score: " + topGenreScores[2])
                    }
                } else if (topGenres.count >= 2 && topGenreScores.count >= 2) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                    VStack {
                        Text(topGenres[1])
                        Text("Score: " + topGenreScores[1])
                    }
                } else if (topGenres.count >= 1 && topGenreScores.count >= 1) {
                    VStack {
                        Text(topGenres[0])
                        Text("Score: " + topGenreScores[0])
                    }
                } else {
                    Text("You have no top genres.")
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
