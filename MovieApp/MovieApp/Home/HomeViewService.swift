//
//  HomeViewService.swift
//  MovieApp
//

//

import Foundation

class HomeViewService {
    
    // MARK: - Types
    
    
    // MARK: - Properties
    private let apiKey = "bf343286ac67437fb35c5a78ac827398"
    private let session: URLSession
    private let baseURL = "https://api.themoviedb.org/3"
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    //https://api.themoviedb.org/3/movie/popular?api_key=%7BAPI_KEY%7D
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)"
        
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
                
                var movieResponse = try decoder.decode(MovieResponse.self, from: data)
                var results = movieResponse.results ?? []
                
                completion(.success(results))
            } catch {
                
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
    // MARK: - Save/Load liked movies
    func saveLikedMovie(id: Int, isLiked: Bool) {
        
        var likedDict = UserDefaults.standard.dictionary(forKey: "likedMovies") as? [String: Bool] ?? [:]
        likedDict["\(id)"] = isLiked
        UserDefaults.standard.set(likedDict, forKey: "likedMovies")
    }

    func isMovieLiked(id: Int) -> Bool {
        let likedDict = UserDefaults.standard.dictionary(forKey: "likedMovies") as? [String: Bool]
        return likedDict?["\(id)"] ?? false
    }

    func fetchLikedDislikedMovies(movies: [Movie]) -> [Movie] {
        var updatedMovies = movies
        for i in 0..<updatedMovies.count {
            updatedMovies[i].isLikedBytheUser = isMovieLiked(id: updatedMovies[i].id ?? 0)
        }
        return updatedMovies
    }

}
