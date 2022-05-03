//
//  AuthManager.swift
//  Sprofil
//
//  Created by Tejas Gupta on 3/14/22.
//
import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID = "90f2b9d6661844559fa5a247e52a1e19"
        static let clientSecret = "5af27527459645d9bacbb6cbb4044eda"
//        let redirectURI = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://cnn.com/"
        static let scopes = "user-top-read" + "%20" + "user-library-read" + "%20" + "user-read-private" + "%20" + "user-library-read" + "%20" + "user-read-email"
    }
    
    // lazy var configuration = SPTConfiguration(clientID: Constants.clientID, redirectURL: Constants.redirectURL)
    
    private init() {}
    
    public var signInURL: URL? {
        // let string = ""
        let base = "https://accounts.spotify.com/authorize?"
        let string = "\(base)response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        
        return URL(string: string)
        
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    public var code: String? {
        return UserDefaults.standard.string(forKey: "auth_code")
    }
    
    public var userID: String? {
        return UserDefaults.standard.string(forKey: "user_id")
    }
    
    public var userEmail: String? {
        return UserDefaults.standard.string(forKey: "user_email")
    }
    
    public var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpiry: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var refreshNeeded: Bool {
        guard let expirationDate = tokenExpiry else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }

    public func exchangeCodeForToken(
            code: String,
            completion: @escaping ((Bool) -> Void)
        ) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }

        request.setValue("Basic \(base64String)",
                         forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                completion(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    
    public func unusedFunction(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        let group = DispatchGroup()
        
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                         value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  error == nil else {
                      completion(false)
                      return
                  }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                
                
                var myProfileID : String = "no_id"
                
                // get top tracks from last six months
                
                var track_req_medium = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=medium_term")!)
                track_req_medium.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                track_req_medium.httpMethod = "GET"
                track_req_medium.timeoutInterval = 30 // seconds
                var track_string = "no value"
                var trackTuples: [String: [String]] = [String: [String]]()
                var albumTuples: [String: [String]] = [String: [String]]()
                let track_task_medium = URLSession.shared.dataTask(with: track_req_medium) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    track_string = String(data: data, encoding: .utf8)!
                    FirebaseAPI2.uploadJSON(child: "trackJSON_medium", myJSON: track_string, user_id: myProfileID)
                    do {
                        let tracks = try JSONDecoder().decode(TopTracks.self, from: data)
                        for trackItem in tracks.items {
                            trackTuples[trackItem.id] = [trackItem.name, trackItem.album.images[0].url]
                            albumTuples[trackItem.album.id] = [trackItem.album.name, trackItem.album.images[0].url]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "trackTuplesMedium", artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadGeneralTuple(child: "albumTuplesMedium", artistInfo: albumTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadTrackInfoTuple(artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadAlbumInfoTuple(artistInfo: albumTuples, user_id: myProfileID)
                        print("UPLOADED TRACK INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                }
                
                // get top tracks from last month
                
                var track_req_short = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=short_term")!)
                track_req_short.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                track_req_short.httpMethod = "GET"
                track_req_short.timeoutInterval = 30 // seconds
                track_string = "no value"
                let track_task_short = URLSession.shared.dataTask(with: track_req_short) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    track_string = String(data: data, encoding: .utf8)!
                    FirebaseAPI2.uploadJSON(child: "trackJSON_short", myJSON: track_string, user_id: myProfileID)
                    do {
                        let tracks = try JSONDecoder().decode(TopTracks.self, from: data)
                        for trackItem in tracks.items {
                            trackTuples[trackItem.id] = [trackItem.name, trackItem.album.images[0].url]
                            albumTuples[trackItem.album.id] = [trackItem.album.name, trackItem.album.images[0].url]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "trackTuplesShort", artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadGeneralTuple(child: "albumTuplesShort", artistInfo: albumTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadTrackInfoTuple(artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadAlbumInfoTuple(artistInfo: albumTuples, user_id: myProfileID)
                        print("UPLOADED TRACK INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                }
                
                // get top tracks from lifetime
                
                var track_req_long = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/tracks?time_range=long_term")!)
                track_req_long.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                track_req_long.httpMethod = "GET"
                track_req_long.timeoutInterval = 30 // seconds
                track_string = "no value"
                let track_task_long = URLSession.shared.dataTask(with: track_req_long) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    track_string = String(data: data, encoding: .utf8)!
                    FirebaseAPI2.uploadJSON(child: "trackJSON_long", myJSON: track_string, user_id: myProfileID)
                    do {
                        let tracks = try JSONDecoder().decode(TopTracks.self, from: data)
                        for trackItem in tracks.items {
                            trackTuples[trackItem.id] = [trackItem.name, trackItem.album.images[0].url]
                            albumTuples[trackItem.album.id] = [trackItem.album.name, trackItem.album.images[0].url]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "trackTuplesLong", artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadGeneralTuple(child: "albumTuplesLong", artistInfo: albumTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadTrackInfoTuple(artistInfo: trackTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadAlbumInfoTuple(artistInfo: albumTuples, user_id: myProfileID)
                        print("UPLOADED TRACK INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                }
                                
                // get top artists for last six months
                
                var art_req = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=medium_term")!)
                art_req.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                art_req.httpMethod = "GET"
                art_req.timeoutInterval = 30 // seconds
                var art_string = "no value"
                var artistList: [String] = [String]()
                var artistImages: [String: String] = [String: String]()
                var artistTuples: [String: [String]] = [String:[String]]()
                let art_task = URLSession.shared.dataTask(with: art_req) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    art_string = String(data: data, encoding: .utf8)!
//                    art_string = art_string.replacingOccurrences(of: "\"", with: "\'")
                    FirebaseAPI2.uploadJSON(child: "artistJSON_medium", myJSON: art_string, user_id: myProfileID)
                    do {
                        let artists = try JSONDecoder().decode(TopArtists.self, from: data)
                        
//                        var imageList: [String: String] =
                        for artistItem in artists.items {
                            print(artistItem.id)
                            print(artistItem.name)
//                            artistList.append(artistItem.name)
                            print(artistItem.images?[0].url ?? "no url")
//                            artistImages[artistItem.name] = artistItem.images?[0].url
                            artistTuples[artistItem.id] = [artistItem.name, artistItem.images?[0].url ?? "no url"]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "artistTuplesMedium", artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfoTuple(artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfo(stringArray: artistList, imageArray: artistImages, user_id: "p_gupta")
                        print("UPLOADED ARTIST INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                    // ADD FUNCTION TO UPLOAD DATA AS RAW JSON STRING
//                    FirebaseAPI.shared.EditArtistJson(artistJson: String(data: data, encoding: .utf8), user_id: AuthManager.shared.userID)
                }
                
                // get top artists for last month
                
                var art_req_short = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=short_term")!)
                art_req_short.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                art_req_short.httpMethod = "GET"
                art_req_short.timeoutInterval = 30 // seconds
                let art_task_short = URLSession.shared.dataTask(with: art_req_short) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    art_string = String(data: data, encoding: .utf8)!
//                    art_string = art_string.replacingOccurrences(of: "\"", with: "\'")
                    FirebaseAPI2.uploadJSON(child: "artistJSON_short", myJSON: art_string, user_id: myProfileID)
                    do {
                        let artists = try JSONDecoder().decode(TopArtists.self, from: data)
                        
//                        var imageList: [String: String] =
                        for artistItem in artists.items {
                            print(artistItem.id)
                            print(artistItem.name)
//                            artistList.append(artistItem.name)
                            print(artistItem.images?[0].url ?? "no url")
//                            artistImages[artistItem.name] = artistItem.images?[0].url
                            artistTuples[artistItem.id] = [artistItem.name, artistItem.images?[0].url ?? "no url"]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "artistTuplesShort", artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfoTuple(artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfo(stringArray: artistList, imageArray: artistImages, user_id: "p_gupta")
                        print("UPLOADED ARTIST INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                    // ADD FUNCTION TO UPLOAD DATA AS RAW JSON STRING
//                    FirebaseAPI.shared.EditArtistJson(artistJson: String(data: data, encoding: .utf8), user_id: AuthManager.shared.userID)
                }
                
                // get top artists for lifetime
                
                var art_req_long = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/top/artists?time_range=long_term")!)
                art_req_long.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                art_req_long.httpMethod = "GET"
                art_req_long.timeoutInterval = 30 // seconds
                let art_task_long = URLSession.shared.dataTask(with: art_req_long) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    art_string = String(data: data, encoding: .utf8)!
//                    art_string = art_string.replacingOccurrences(of: "\"", with: "\'")
                    FirebaseAPI2.uploadJSON(child: "artistJSON_long", myJSON: art_string, user_id: myProfileID)
                    do {
                        let artists = try JSONDecoder().decode(TopArtists.self, from: data)
                        
//                        var imageList: [String: String] =
                        for artistItem in artists.items {
                            print(artistItem.id)
                            print(artistItem.name)
//                            artistList.append(artistItem.name)
                            print(artistItem.images?[0].url ?? "no url")
//                            artistImages[artistItem.name] = artistItem.images?[0].url
                            artistTuples[artistItem.id] = [artistItem.name, artistItem.images?[0].url ?? "no url"]
                        }
//                        FirebaseAPI2.UploadGeneralTuple(child: "artistTuplesLong", artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfoTuple(artistInfo: artistTuples, user_id: myProfileID)
//                        FirebaseAPI2.UploadArtistInfo(stringArray: artistList, imageArray: artistImages, user_id: "p_gupta")
                        print("UPLOADED ARTIST INFO")
                        group.leave()
                    } catch {
                        print(error)
                    }
                    // ADD FUNCTION TO UPLOAD DATA AS RAW JSON STRING
//                    FirebaseAPI.shared.EditArtistJson(artistJson: String(data: data, encoding: .utf8), user_id: AuthManager.shared.userID)
                }
                
                
                
                // get user ID
                var profile_req = URLRequest(url: URL(string: "https://api.spotify.com/v1/me")!)
                profile_req.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
                profile_req.httpMethod = "GET"
                profile_req.timeoutInterval = 30 // seconds
                let profile_task = URLSession.shared.dataTask(with: profile_req) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    do {
                        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                        print("USER ID: \(profile.id)")
                        UserDefaults.standard.setValue(profile.id, forKey: "user_id")
                        UserDefaults.standard.setValue(profile.email, forKey: "user_email")
                        myProfileID = profile.id.replacingOccurrences(of: ".", with: ",")
                        FirebaseAPI2.UploadEmail(user_id: myProfileID, user_email: profile.email)
                        group.enter()
                        track_task_medium.resume()
                        group.enter()
                        track_task_short.resume()
                        group.enter()
                        track_task_long.resume()
                        group.enter()
                        art_task.resume()
                        group.enter()
                        art_task_short.resume()
                        group.enter()
                        art_task_long.resume()
                    } catch {
                        print(error)
                    }
                    
                }
                profile_task.resume()
//                art_task.resume()
                
//                FirebaseAPI2.CreateNew(artistJson: art_string ?? "artists_default", tracksJson: track_string ?? "track_default", user_id: AuthManager.shared.userID ?? "optional_value")
                
                
                // if we want to send more specific information
//                APICaller.shared.getTopArtists { result in
//                    switch result {
//                    case .success(let artist_info):
//                        // functions to upload to firebase
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//                // get top tracks
//                APICaller.shared.getTopTracks { result in
//                    switch result {
//                    case .success(let track_info):
//                        // functions to upload to firebase
//                        break
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//////
//                print("CHECK POPULATED LISTS BEFORE UPLOAD")
//                print("TRACKS:")
//                for myItem in trackList {
//                    print(myItem)
//                }
//                print("ARTISTS:")
//                for myItem in artistList {
//                    print(myItem)
//                }
                group.notify(queue: DispatchQueue.main) {
                    print("ALL TASKS COMPLETED")
                    completion(true)
                }
                
                
//                self?.cacheToken(result: result)
//
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("SUCCESS: \(json)")
//                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
        
    }
    
    enum UserProfileError: Error {
        case failedToGetData
    }
    
//    public func getCurrentUserProfile(token: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
//        var baseRequest = URLRequest(url: URL(string: "https://api.spotify.com/v1/me")!)
//        baseRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        baseRequest.httpMethod = "GET"
//        baseRequest.timeoutInterval = 30 // seconds
//        let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
//            guard let data = data, error == nil else {
//                print("DATA ERROR")
//                completion(.failure(UserProfileError.failedToGetData))
//                return
//            }
//
//            do {
//                let result = try JSONDecoder().decode(UserProfile.self, from: data)
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("SUCCESS: \(json)")
//                print(result)
//                UserDefaults.standard.setValue(result.id,
//                                               forKey: "user_id")
//                UserDefaults.standard.setValue(result.email,
//                                               forKey: "user_email")
//                completion(.success(result))
//            }
//            catch {
//                print("WEIRD ERROR")
//                print(error.localizedDescription)
//                completion(.failure(UserProfileError.failedToGetData))
//            }
//        }
//        task.resume()
//    }
        
//
//    public func getCurrentUserProfile(token: String) -> UserProfile? {
//        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me")!)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//        request.timeoutInterval = 30 // seconds
//
//        var result : UserProfile
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            do {
//                result = try JSONDecoder().decode(UserProfile.self, from: data)
//            }
//            catch {
//                print(error.localizedDescription)
//                return
//            }
//        }
//        task.resume()
//        return result
//    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    private var onRefreshBlocks = [((String) -> Void)]() // prevents redundant refreshes
    
    /// Supplies valid token to be used with API calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            // Append the completion once the refreshing has completed
            onRefreshBlocks.append(completion)
            return
        }
        if refreshNeeded {
            // refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
         
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        
        guard refreshNeeded else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "refresh_token"),
            URLQueryItem(name: "refresh_token",
                         value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,
                  error == nil else {
                      completion(false)
                      return
                  }
                        
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                print("Successfully refreshed token")
                
                self?.cacheToken(result: result)
                
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(json)")
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
    }
    
}
