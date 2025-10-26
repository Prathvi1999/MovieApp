//
//  DetailMovieViewModel.swift
//  MovieApp
//

//

import Foundation
class DetailMovieViewModel: ObservableObject {
    @Published var result: [Video] = []
    @Published var movieById: MovieDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let movieService = DetailMovieService()
    
    
    func fetchMoviesVideos(id:Int) {
        isLoading = true
        errorMessage = nil
        
        movieService.fetchMovieVideoById(id: id,completion: { result in
            
            DispatchQueue.main.async {
                // self?.isLoading = false
                
                switch result {
                case .success(let videos):
                    
                    let youtubeVideos = videos.filter { $0.site.lowercased() == "youtube" }
                    
                    self.result = youtubeVideos
                    
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    
                }
            }
        })
    }
    
    func fetchMovies(id:Int) {
        isLoading = true
        errorMessage = nil
        
        movieService.fetchDetailMovieById(id: id,completion: { result in
            
            DispatchQueue.main.async {
                
                
                switch result {
                case .success(let videos):
                    
                    
                    
                    self.movieById = videos
                    
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
        })
    }
}
