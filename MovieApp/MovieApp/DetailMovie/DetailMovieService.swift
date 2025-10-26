//
//  DetailMovieService.swift
//  MovieApp
//

//

import Foundation
class DetailMovieService {
    
    // MARK: - Types
    
    
    // MARK: - Properties
    private let apiKey = "bf343286ac67437fb35c5a78ac827398"
    private let session: URLSession
    private let baseURL = "https://api.themoviedb.org/3"
    
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchMovieVideoById(id:Int,endPoint:String = "",completion: @escaping (Result<[Video], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(id)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Here2")
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                
                completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            
            do {
                
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieResponse = try decoder.decode(VideoResponse.self, from: data)
                completion(.success(movieResponse.results ?? []))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func fetchDetailMovieById(id:Int,completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let urlString = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                
                completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            
            do {
                
                
                
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieResponse = try decoder.decode(MovieDetails.self, from: data)
                completion(.success(movieResponse))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

