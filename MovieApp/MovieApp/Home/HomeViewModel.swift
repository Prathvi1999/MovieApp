//
//  HomeViewModel.swift
//  MovieApp
//

//

import Foundation

class HomeViewModel: ObservableObject {
       @Published var movies: [Movie] = []
       @Published var isLoading = false
       @Published var errorMessage: String?
       
       private let movieService = HomeViewService()
       
       func fetchMovies() {
           isLoading = true
           errorMessage = nil
           
           movieService.fetchPopularMovies { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   
                   switch result {
                   case .success(let movies):
                       self?.movies = self?.movieService.fetchLikedDislikedMovies(movies: movies) ?? movies
                      
                       
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                       print("Error fetching movies: \(error.localizedDescription)")
                   }
               }
           }
       }

    
    func setLikedDislikedMovieById(movieId: Int) {
          
     
            if let index = movies.firstIndex(where: { $0.id == movieId }) {
                movies[index].isLikedBytheUser?.toggle()
                movieService.saveLikedMovie(id: movieId, isLiked: movies[index].isLikedBytheUser ?? false)
            }
        }
    
   

    
}
