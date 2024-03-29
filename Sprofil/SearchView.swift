//
//  SearchView.swift
//  Sprofil (iOS)
//
//  Created by Ben Shi on 3/11/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject var firebase = FirebaseAPI()
    @State var text = ""
    var body: some View {
        if firebase.loading {
            LoadingView()
        }
        else {
            NavigationView {
                List {
                    ForEach(firebase.GetNameList().filter { $0.localizedCaseInsensitiveContains(text)}, id: \.self) { item in
                        NavigationLink(destination: OtherProfileView(profName: item)) {
                            HStack(alignment: .top, spacing: 12) {
                                AsyncImage(url: URL(string: firebase.GetOtherProfPic(profName: item))) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 44, height: 44)
                                .background(Color("Background"))
                                .mask(Circle())
                                VStack {
                                    Text(item).bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(firebase.GetOtherBio(userID: firebase.GetUserID(profName: item)))
                                        .font(.footnote)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 4)
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .searchable(text: $text, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Type Username Here"))
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
