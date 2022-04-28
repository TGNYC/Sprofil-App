//
//  ExploreView.swift
//  Sprofil
//
//  Created by Ben Shi on 4/17/22.
//

import Foundation
import SwiftUI

struct ExploreView: View {
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]

    private var colors: [Color] = [.yellow, .purple, .green]

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            Text("Explore")
                .font(.title)
//            HStack() {
//                Button(action: {
//                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                    impactMed.impactOccurred()
//                    showDetailed = true
//                }, label: {
//                AsyncImage(url: URL(string: info[1])) { image in
//                    image.resizable()
//                } placeholder: {
//                    Color.gray
//                }
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 90, height: 90)
//                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15,height: 15)))
//                })
//            }
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach((0...9999), id: \.self) {
                    Image(systemName: symbols[$0 % symbols.count])
                        .font(.system(size: 30))
                        .frame(width: 50, height: 50)
                        .background(colors[$0 % colors.count])
                        .cornerRadius(10)
//                        .onTapGesture {
//                            NavigationLink("Other Profile View", destination: OtherProfileView(profName: "p,gupta"))
//                        }
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
