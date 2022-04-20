//
//  APICaller.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/14/22.
//

import Foundation
import SwiftUI


final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
//    public init() {
//        print("ACCESS TOKEN from APICaller")
//        print(AuthManager.shared.accessToken!)
//
//        getCurrentUserProfile { result in
//            switch result {
//            case .success(let profile):
//                self.setUserID(result: profile)
//                self.myProfile = profile
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//        print("FINISH PROFILE GETTING AND SETTING")
//        print(myProfile?.display_name)
//
//        getTopArtists(timeFrame: 1)  { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let artists):
//                    self?.myTopArtists = artists
//                    if artists.items.count > 0 {
//                        self?.artistList = artists.items
//                    } else {
//                        self?.artistList = [Artist]()
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//
//        getTopTracks(timeFrame: 1) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let tracks):
//                    self?.myTopTracks = tracks
//                    if tracks.items.count > 0 {
//                        self?.trackList = tracks.items
//                    } else {
//                        self?.trackList = [Track]()
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
//        getTopArtists { result in
//            switch result {
//            case .success(let artists):
//                self.myTopArtists = artists
//                if artists.items.count > 0 {
//                    self.artistList = artists.items
//                } else {
//                    self.artistList = [Artist]()
//                }
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        print("FINISH ARTISTS GETTING AND SETTING")
//        print(myTopArtists?.total ?? <#default value#>)
//
////        getTopTracks { result in
////            switch result {
////            case .success(let tracks):
////                self.myTopTracks = tracks
////                if tracks.items.count > 0 {
////                    self.trackList = tracks.items
////                    for trackItem in self.trackList {
////                        print(trackItem.name)
////                    }
////                    print(self.trackList.count)
////                } else {
////                    self.trackList = [Track]()
////                }
////                break
////            case .failure(let error):
////                print(error)
////            }
////        }
//
//        print("FINISH TRACKS GETTING AND SETTING")
//        print(myTopTracks?.href)
//
//        print("MY TRACKS:")
//        print("NUMBER OF TRACKS: \(self.trackList.count)")
//        trackList.forEach {
//            print($0.name)
//        }
//
//        print("MY ARTISTS:")
//        print("NUMBER OF TRACKS: \(self.artistList.count)")
//        artistList.forEach {
//            print($0.name)
//        }
//    }
    
    /// Spotify User ID
    public var userID: String? {
        return UserDefaults.standard.string(forKey: "user_id")
    }
    
    public var trackList: [Track] = [Track]()
    public var artistList: [Artist] = [Artist]()
    public var myProfile: UserProfile?
    public var myTopTracks: TopTracks?
    public var myTopArtists: TopArtists?
    
    /// Caches Token into UserDefaults
    private func setUserID(result: UserProfile) {
        UserDefaults.standard.setValue(result.id, forKey: "user_id")
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getTopArtists(timeFrame: Int, completion: @escaping (Result<TopArtists, Error>) -> Void) {
        var timeAddendum: String = "?time_range=medium_term"
        if (timeFrame == 0) {
            timeAddendum = "?time_range=short_term"
        } else if (timeFrame == 1) {
            timeAddendum = "?time_range=medium_term"
        } else {
            timeAddendum = "?time_range=long_term"
        }
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/top/artists" + timeAddendum), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(TopArtists.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Top Artist Parse failure: \(error)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getTopTracks(timeFrame: Int, completion: @escaping (Result<TopTracks, Error>) -> Void) {
        var timeAddendum: String = "?time_range=medium_term"
        if (timeFrame == 0) {
            timeAddendum = "?time_range=short_term"
        } else if (timeFrame == 1) {
            timeAddendum = "?time_range=medium_term"
        } else {
            timeAddendum = "?time_range=long_term"
        }
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/top/tracks" + timeAddendum), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
//                print("TOP TRACKS:")
//                print(String(data: data, encoding: .utf8)!)
                do {
                    let result = try JSONDecoder().decode(TopTracks.self, from: data)
//                    let JSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                    print(JSON)
                    completion(.success(result))
                } catch {
                    print("Top Track Parse failure: \(error)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
            createRequest(
                with: URL(string: Constants.baseAPIURL + "/me"),
                type: .GET
            ) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        completion(.success(profile))
                    } catch {
                        print("Profile Parse failure: \(error)")
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }

    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30 // seconds
            completion(request)
        }
    }
}
