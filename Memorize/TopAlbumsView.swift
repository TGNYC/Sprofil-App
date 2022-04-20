//
//  TopAlbumsView.swift
//  Sprofil
//
//  Created by Ben Shi on 4/5/22.
//

import SwiftUI

struct TopAlbumsView: View {
    var firebase: FirebaseAPI
    @State var showDetailed: Bool = false
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Albums").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(firebase.GetTopAlbumInfo(), id: \.self){ info in
                        GeometryReader { geometry in
                        VStack() {
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
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
                                    //DetailedView()
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

struct OtherTopAlbumsView: View {
    var firebase: FirebaseAPI
    var profName: String
    @State var showDetailed: Bool = false
    var body: some View {
        VStack(alignment: .center) {
            Text("Top Albums").font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(firebase.GetOtherTopAlbumInfo(userID: firebase.GetUserID(profName: profName)), id: \.self){ info in
                        GeometryReader { geometry in
                        VStack() {
                            Button(action: {
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
                                    //DetailedView()
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

struct TopAlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        let firebase = FirebaseAPI()
        TopAlbumsView(firebase: firebase)
    }
}
