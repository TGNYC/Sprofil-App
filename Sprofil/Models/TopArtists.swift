//
//  TopArtists.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/22/22.
//

import Foundation


struct TopArtists: Codable {
    let href: URL
    let items: [Artist]
    let limit: Int
    let next: URL?
    let offset: Int
    let previous: URL?
    let total: Int
}


//{
//    href = "https://api.spotify.com/v1/me/top/artists";
//    items =     (
//                {
//            "external_urls" =             {
//                spotify = "https://open.spotify.com/artist/0tLjWOxzh42O8gr0nFzv45";
//            };
//            followers =             {
//                href = "<null>";
//                total = 64595;
//            };
//            genres =             (
//                ghazal,
//                "hindustani classical",
//                "hindustani vocal",
//                "indian classical",
//                khayal,
//                "marathi traditional"
//            );
//            href = "https://api.spotify.com/v1/artists/0tLjWOxzh42O8gr0nFzv45";
//            id = 0tLjWOxzh42O8gr0nFzv45;
//            images =             (
//                                {
//                    height = 640;
//                    url = "https://i.scdn.co/image/ab67616d0000b2734bd17f4c4f9162864a6eaba3";
//                    width = 640;
//                },
//                                {
//                    height = 300;
//                    url = "https://i.scdn.co/image/ab67616d00001e024bd17f4c4f9162864a6eaba3";
//                    width = 300;
//                },
//                                {
//                    height = 64;
//                    url = "https://i.scdn.co/image/ab67616d000048514bd17f4c4f9162864a6eaba3";
//                    width = 64;
//                }
//            );
//            name = "Kishori Amonkar";
//            popularity = 25;
//            type = artist;
//            uri = "spotify:artist:0tLjWOxzh42O8gr0nFzv45";
//        }
//    );
//    limit = 20;
//    next = "<null>";
//    offset = 0;
//    previous = "<null>";
//    total = 1;
//}



//{
//  "href": "https://api.spotify.com/v1/me/shows?offset=0&limit=20\n",
//  "items": [
//    {}
//  ],
//  "limit": 20,
//  "next": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
//  "offset": 0,
//  "previous": "https://api.spotify.com/v1/me/shows?offset=1&limit=1",
//  "total": 4
//}
