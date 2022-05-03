//
//  DataRetrieval.swift
//  Memorize
//
//  Created by Tejas Gupta on 5/2/22.
//

import Foundation

final class DataRetrieval {
    
    struct Constants {
        static let clientID = "90f2b9d6661844559fa5a247e52a1e19"
        static let clientSecret = "5af27527459645d9bacbb6cbb4044eda"
//        let redirectURI = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://cnn.com/"
        static let scopes = "user-top-read" + "%20" + "user-library-read" + "%20" + "user-read-private" + "%20" + "user-library-read" + "%20" + "user-read-email"
    }
    
    private static func uploadData(branch: String, userID: String, myURL: String, completion: @escaping ((Bool) -> Void)) {
        print("Attempting to go to \(myURL)")
        
        var request = URLRequest(url: URL(string: myURL)!)
        request.setValue("Bearer \(AuthManager.shared.accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.timeoutInterval = 30 // seconds
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { data, _, error in
            print("TASK COMPLETE")
            guard let data = data, error == nil else {
                print(error)
                return
            }
            let data_string = String(data: data, encoding: .utf8)!
            FirebaseAPI2.uploadJSON(child: branch, myJSON: data_string, user_id: userID)
            if (data_string.contains("external_urls")) {
                print("Data retrieved for branch \(branch)")
                completion(true)
            } else {
                print("No data for \(branch)")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                } catch {
                    print("No json")
                }
                completion(false)
            }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("Data of branch \(branch) successfully downloaded")
//                print(json)
//            FirebaseAPI2.uploadJSON(child: branch, myJSON: data_string, user_id: userID)
//                completion(true)
//            } catch {
//                print("No data for \(branch)")
//                completion(false)
//            }
        }
        task.resume()
    }
    
    public static func getUserID(completion: @escaping ((Bool) -> Void)) {
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
                let myProfileID = profile.id.replacingOccurrences(of: ".", with: ",")
                print("USER ID: \(myProfileID)")
                UserDefaults.standard.setValue(myProfileID, forKey: "user_id")
                UserDefaults.standard.setValue(profile.email, forKey: "user_email")
                FirebaseAPI2.UploadEmail(user_id: myProfileID, user_email: profile.email)
                completion(true)
            } catch {
                print(error)
            }
        }
        profile_task.resume()
    }
    
    public static func getData(completion: @escaping ((Bool) -> Void)) {
        print("Attempt to get data")
        let group = DispatchGroup()
        
        let myProfileID = AuthManager.shared.userID?.replacingOccurrences(of: ".", with: ",") ?? "p,gupta"
        
        var branches:[String:String] = [
            "trackJSON_medium":"https://api.spotify.com/v1/me/top/tracks?time_range=medium_term",
            "trackJSON_short":"https://api.spotify.com/v1/me/top/tracks?time_range=short_term",
            "trackJSON_long":"https://api.spotify.com/v1/me/top/tracks?time_range=long_term",
            "artistJSON_medium":"https://api.spotify.com/v1/me/top/artists?time_range=medium_term",
            "artistJSON_short":"https://api.spotify.com/v1/me/top/artists?time_range=short_term",
            "artistJSON_long":"https://api.spotify.com/v1/me/top/artists?time_range=long_term"
        ]
        
        var counter = 50
        
        print(branches)
        
        var currentThreads : [String] = []
        
        let lock = NSLock()
        
        while (counter > 0) {
//            print("Test")
            for (branch, myURL) in branches {
                if (currentThreads.contains(branch)) {
                    continue
                }
                print("Current branch: \(branch)")
                print("Current URL: \(myURL)")
                group.enter()
                currentThreads.append(branch)
                uploadData(branch: branch, userID: myProfileID, myURL: myURL) { result in
                    if (result) {
                        print("Data received for \(branch)")
                        lock.lock()
                        branches.removeValue(forKey: branch)
                        lock.unlock()
                        let index = currentThreads.firstIndex(of: branch)
                        currentThreads.remove(at: index!)
                    }
                    group.leave()
                }
            }
            
            lock.lock()
            if (branches.isEmpty) {
                lock.unlock()
                break
            } else {
                print(branches)
            }
            lock.unlock()
            
            counter = counter - 1
        }
        
        print("finished uploadData loop")

//        group.enter()
//        var success1 = false
//        var count1 = 0
//        do {
//            uploadData(branch: "trackJSON_medium", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/tracks?time_range=medium_term") { result in
//                if (result) {
//                    print("Uploaded Track 1")
//                    success1 = true
//                    group.leave()
//                }
//            }
//            count1 = count1 + 1
//            if (count1 > 10) {
//                success1 = true
//                group.leave()
//            }
//        } while (!success1)
//
//        group.enter()
//        var success2 = false
//        var count2 = 0
//        while (!success2) {
//            uploadData(branch: "trackJSON_short", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/tracks?time_range=short_term") {result in
//                if (result) {
//                    print("Uploaded Track 2")
//                    success2 = true
//                    group.leave()
//                }
//                count2 = count2 + 1
//                if (count2 > 10) {
//                    success2 = true
//                }
//            }
//        }
//
//        group.enter()
//        var success3 = false
//        var count3 = 0
//        while (!success3) {
//            uploadData(branch: "trackJSON_long", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/tracks?time_range=long_term") {result in
//                if (result) {
//                    print("Uploaded Track 3")
//                    success3 = true
//                    group.leave()
//                }
//                count3 = count3 + 1
//                if (count3 > 10) {
//                    success3 = true
//                }
//            }
//        }
//
//        group.enter()
//        var success4 = false
//        var count4 = 0
//        while (!success4) {
//            uploadData(branch: "artistJSON_medium", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/artists?time_range=medium_term") {result in
//                if (result) {
//                    print("Uploaded Track 4")
//                    success4 = true
//                    group.leave()
//                }
//                count4 = count4 + 1
//                if (count4 > 10) {
//                    success4 = true
//                }
//            }
//        }
//
//        group.enter()
//        var success5 = false
//        var count5 = 0
//        while (!success5) {
//            uploadData(branch: "artistJSON_short", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/artists?time_range=short_term") {result in
//                if (result) {
//                    print("Uploaded Track 5")
//                    success5 = true
//                    group.leave()
//                }
//                count5 = count5 + 1
//                if (count5 > 10) {
//                    success5 = true
//                }
//            }
//        }
//
//
//        group.enter()
//        var success6 = false
//        var count6 = 0
//        while (!success6) {
//            uploadData(branch: "artistJSON_long", userID: myProfileID, myURL: "https://api.spotify.com/v1/me/top/artists?time_range=long_term") {result in
//                if (result) {
//                    print("Uploaded Track 6")
//                    success5 = true
//                    group.leave()
//                }
//                count6 = count6 + 1
//                if (count6 > 10) {
//                    success6 = true
//                }
//            }
//        }
        
        group.notify(queue: DispatchQueue.global()) {
            print("Test Group Queue")
            completion(true)
            return
        }
    }
}
