//
//  DetailMovieView.swift
//  MovieApp
//

//

import SwiftUI
import AVKit
import WebKit

struct DetailMovieView: View {
    @StateObject private var viewModel = DetailMovieViewModel()
    @StateObject  var homeViewModel :HomeViewModel = HomeViewModel()
    @State var movie: Movie?
    
    
    
    var body: some View {
        ScrollView{
            VStack(spacing:5){
                
                if let firstTrailer = viewModel.result.first(where: { $0.type.lowercased() == "trailer" })
                {
                    
                    YouTubeView(videoID: firstTrailer.key)
                        .frame(height: 300)
                    
                } else {
                    Text("Invalid video URL")
                }
                VStack{
                    
                    
                    Text(viewModel.movieById?.title ?? "")
                        .font(.headline)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.top,5)
                        .padding(.leading,10)
                        .bold()
                    HStack(spacing:4){
                        Text(formatMinutes(time: viewModel.movieById?.runtime ?? 0))
                        
                        
                        Text(".")
                        var genres = viewModel.movieById?.genres ?? []
                        
                        ForEach(genres, id: \.id) { genre in
                            
                            Text("\(genre.name),")
                            
                        }
                        
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],10)
                    
                    HStack(spacing:10){
                        Text("\(viewModel.movieById?.releaseDate ?? "")")
                            .font(.footnote)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        
                        Text(String(format: "%.1f", viewModel.movieById?.voteAverage ?? 7.0))
                        
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],10)
                    
                    Text(viewModel.movieById?.overview ?? "")
                        .font(.subheadline)
                        .padding([.leading],10)
                        .padding(.top,5)
                    
                    
                }
                
                Spacer()
                
            }
            .onAppear{
                viewModel.fetchMovies(id: movie?.id ?? 0)
                viewModel.fetchMoviesVideos(id: movie?.id ?? 0)
                
            }
            
            
        }
    }
    func formatMinutes(time:Int) -> String
    {
        if time != 0{
            let hours = time / 60
            let minutes = time % 60
            
            return "\(hours)h \(minutes)m"
        }
        return ""
    }
}
struct TrailerPlayView: View {
    var body: some View {
        VStack{
            
        }
    }
}

#Preview {
    DetailMovieView(homeViewModel: HomeViewModel(), movie: Movie(adult: Optional(false), backdropPath: Optional("/7QirCB1o80NEFpQGlQRZerZbQEp.jpg"), genreIds: Optional([10749, 18]), id: Optional(1156594), originalLanguage: Optional("es"), originalTitle: Optional("Culpa nuestra"), overview: Optional("Jenna and Lion\'s wedding brings about the long-awaited reunion between Noah and Nick after their breakup. Nick\'s inability to forgive Noah stands as an insurmountable barrier. He, heir to his grandfather\'s businesses, and she, starting her professional life, resist fueling a flame that\'s still alive. But now that their paths have crossed again, will love be stronger than resentment?"), popularity: Optional(532.1524), posterPath: Optional("/yzqHt4m1SeY9FbPrfZ0C2Hi9x1s.jpg"), releaseDate: Optional("2025-10-15"), title: Optional("Our Fault"), video: Optional(false), voteAverage: Optional(7.7), voteCount: Optional(372)))
}


