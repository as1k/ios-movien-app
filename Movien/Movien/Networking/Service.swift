//
//  Service.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import Foundation

class Service {
    
    var session = URLSession.shared
    
    private func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Api.SCHEME
        components.host = Api.HOST
        components.path = Api.PATH + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        session.invalidateAndCancel()
        
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.API_KEY] = Api.KEY as AnyObject?
        
        
        let request = NSMutableURLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            func sendRetryError(_ error: String, retryAfter retry: Int) {
                print(error)
                let userInfo: [String : Any] = [NSLocalizedDescriptionKey : error, "Retry-After" : retry]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 429, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
        
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 429,
                    let retryString = httpResponse.allHeaderFields["Retry-After"] as? String,
                    let retry = Int(retryString) {
                    sendRetryError("Your request returned a status code of: \(String(describing: (response as? HTTPURLResponse)?.statusCode))", retryAfter: retry)
                } else {
                    sendError("Your request returned a status code of: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                }
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandlerForGET(data, nil)
        }
        task.resume()
        return task
    }
    
    func taskForGETImage(_ size: String, filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        let baseURL = URL(string: ImageKeys.IMAGE_BASE_URL)!
        let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code of: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandlerForImage(data, nil)
        }
        
        task.resume()
        
        return task
    }
    
    static func fetchMovie(with searchTerm: String, completion: @escaping ([Movie]?) -> Void) {
        let baseMovieURL = URL(string: "https://api.themoviedb.org/")
        guard let url = baseMovieURL?.appendingPathComponent("3").appendingPathComponent("search").appendingPathComponent("movie") else { completion(nil); return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Api.KEY)
        let searchTermQueryItem = URLQueryItem(name: "query", value: searchTerm)
        components?.queryItems = [apiKeyQueryItem, searchTermQueryItem]
        
        guard let requestURL = components?.url else { completion(nil) ; return }
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("There was an error \(error.localizedDescription)")
                completion (nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            
            do {
                let movieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                let movies = movieResults.results
                completion(movies)
            } catch {
                print("There was an error with searching: \(error.localizedDescription)")
                
                completion(nil)
                return
            }
            }.resume()
    }
    
    static func fetchFavorites(with accountId: Int, completion: @escaping ([Movie]?) -> Void) {
        let baseMovieURL = URL(string: "https://api.themoviedb.org/")
        guard let url = baseMovieURL?
            .appendingPathComponent("3")
            .appendingPathComponent("account")
            .appendingPathComponent(String(accountId))
            .appendingPathComponent("favorite")
            .appendingPathComponent("movies")
            else { completion(nil); return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Api.KEY)
        let sessionIdQueryItem = URLQueryItem(name: "session_id", value: Api.SESSION_ID)
        let languageQueryItem = URLQueryItem(name: "language", value: "en-US")
        components?.queryItems = [apiKeyQueryItem, sessionIdQueryItem, languageQueryItem]
        
        guard let requestURL = components?.url else { completion(nil) ; return }
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("There was an error \(error.localizedDescription)")
                completion (nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            
            do {
                let movieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                let movies = movieResults.results
                completion(movies)
            } catch {
                print("There was an error with searching: \(error.localizedDescription)")
                
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func fetchUser(completion: @escaping (User?) -> Void) {
        let baseMovieURL = URL(string: "https://api.themoviedb.org/")
        guard let url = baseMovieURL?.appendingPathComponent("3").appendingPathComponent("account")
            else { completion(nil); return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: Api.KEY)
        let sessionIdQueryItem = URLQueryItem(name: "session_id", value: Api.SESSION_ID)
        components?.queryItems = [apiKeyQueryItem, sessionIdQueryItem]
        
        guard let requestURL = components?.url else { completion(nil) ; return }
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("There was an error \(error.localizedDescription)")
                completion (nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            
            do {
                let userResult = try JSONDecoder().decode(User.self, from: data)
                let user = userResult
                completion(user)
            } catch {
                print("There was an error with fetching user: \(error.localizedDescription)")
                
                completion(nil)
                return
            }
        }.resume()
    }
    
    func getDataRequest(url:String, onCompletion:@escaping (Any)->()) {
        let path = "\(Api.BASE_URL)\(url)"
        if let url = URL(string: path) {
            print(url)
            URLSession.shared.dataTask(with: url) {
                (data, response,error) in
                
                guard let data = data, error == nil, response != nil else{
                    print("Something is wrong: \(String(describing: error?.localizedDescription))")
                    return
                }
                onCompletion(data)
                }.resume()
        }
        else {
            print("Unable to create URL")
        }
    }
    
    func movieDetail(movieID:Int, completion: @escaping (Movie)->()) {
        
        let getURL = "/movie/\(movieID)?api_key=\(Api.KEY)&language=en-US"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(Movie.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    func movieVideos(movieID:Int, completion: @escaping (VideoInfo)->()) {
        
        let getURL = "/movie/\(movieID)/videos?api_key=\(Api.KEY)&language=en-US"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(VideoInfo.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    func tvVideos(tvID:Int, completion: @escaping (VideoInfo)->()) {
        
        let getURL = "/tv/\(tvID)/videos?api_key=\(Api.KEY)&language=en-US"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(VideoInfo.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    func movieCredits(movieID:Int, completion: @escaping (Credits)->()) {
        
        let getURL = "/movie/\(movieID)/credits?api_key=\(Api.KEY)"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(Credits.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    func personDetails(person_id:Int, completion: @escaping (Person)->()) {
        
        let getURL = "/person/\(person_id)?api_key=\(Api.KEY)&language=en-US"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                let results = try JSONDecoder().decode(Person.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
    
    func personMovieCredits(personID:Int, completion: @escaping (PeopleCredits)->()) {
        
        let getURL = "/person/\(personID)/movie_credits?api_key=\(Api.KEY)&language=en-US"
        getDataRequest(url: getURL) { jsonData in
            do
            {
                
                let results = try JSONDecoder().decode(PeopleCredits.self, from: jsonData as! Data)
                completion(results)
            }
            catch
            {
                print("JSON Downloading Error!")
            }
        }
    }
    
     func smallImageURL(path:String)->URL?{
        if let url = URL(string: ImageKeys.PosterSizes.DETAIL_POSTER+path){
            return url
        }
        return nil
    }
    
     func bigImageURL(path:String)->URL?{
        if let url = URL(string: ImageKeys.PosterSizes.DETAIL_POSTER+path){
            return url
        }
        return nil
    }
    
    
     func youtubeThumb(path:String)->URL?{
        if let url = URL(string: Api.youtubeThumb+path+"/0.jpg"){
            return url
        }
        return nil
    }
    
    
     func youtubeURL(path:String)->URL?{
        if let url = URL(string: Api.youtubeLink+path){
            return url
        }
        return nil
    }
    
}
