//
//  HomeView.swift
//  MovieApp
//

//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    
    var body: some View {
        ZStack{
            ScrollView{
               
                    HeaderSection()
                    
                CarouselView(viewModel: viewModel)
                TrendingMovies(viewModel: viewModel)
                
            }
           
        }
        .task {
            if viewModel.movies.isEmpty {
                
                viewModel.fetchMovies()
            }
        }
    }
  
}

// MARK: - Subviews

struct HeaderSection : View{
   
    @State var showAlert = false
    @State var showMessage = ("","")
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(greetingMessage())
                .foregroundColor(.gray)
            HStack{
                Text("Hema")
                    .font(.headline)
                
                
                
                
            }
            .padding(.top,2)
            Text("Top rated movies")
                .bold()
            
            
        }
        .frame(maxWidth:.infinity,alignment: .topLeading)
        .padding()
    }
    
           
    func greetingMessage() -> String
    {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
           case 5..<12:
               return "Good Morning"
           case 12..<17:
               return "Good Afternoon"
           case 17..<22:
               return "Good Evening"
           default:
               return "Good Night"
           }
    }
}
               
struct CarouselView: View {
    @State var selection = 0
    @ObservedObject var viewModel: HomeViewModel
    let timer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
    var top4Movies: [Movie] {
        Array(viewModel.movies.sorted { $0.voteAverage ?? 0.0 > $1.voteAverage ?? 0.0 }.prefix(4))
    }
    
    let horizontalSpacing: CGFloat = 15
    private let cardWidth = UIScreen.main.bounds.width - 30
    
    var body: some View {
        
        TabView(selection: $selection) {
            ForEach(top4Movies.indices, id: \.self) { index in
                NavigationLink{
                    DetailMovieView(movie: top4Movies[index])
                }
                label:{
                    ZStack(alignment: .bottomLeading) {
                        
                        AsyncImage(url: top4Movies[index].fullBackdropURL) { phase in
                            Group {
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: cardWidth, height: 180)
                                        .clipped()
                                } else if phase.error != nil {
                                    Color.gray
                                        .frame(width: cardWidth, height: 180)
                                        .overlay(
                                            Image(systemName: "xmark.octagon")
                                                .foregroundColor(.red)
                                        )
                                } else {
                                    ProgressView()
                                        .frame(width: cardWidth, height: 180)
                                }
                            }
                        }
                        
                        
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .cornerRadius(10)
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(top4Movies[index].title ?? "Unknown Title")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                                
                                Text(String(format: "%.1f", top4Movies[index].voteAverage ?? 0.0))
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                               
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: cardWidth, height: 180)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .tag(index)
                    .padding(.horizontal, horizontalSpacing)
            }
            }
        }
        .frame(height: 180)
    
        
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onReceive(timer) { _ in
            withAnimation {
                self.selection = (self.selection + 1) % max(1, self.top4Movies.count)
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
struct TrendingMovies : View{
    @ObservedObject var viewModel: HomeViewModel
    var top4Movies: [Movie] {
        viewModel.movies
    }
    let columns : [GridItem] = [
        GridItem(.flexible(),spacing: 20,alignment: nil),
        GridItem(.flexible(),spacing: 20,alignment: nil)
    ]
   
    var body: some View {
        
        VStack{
            HStack{
                Text("Popular movies")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding([.leading,.top],15)
                    .bold()
                Spacer()
               
                
            }
            
            
            
           
            LazyVGrid(columns: columns,alignment: .center,
                      spacing: 20,pinnedViews: []) {
                
                
                ForEach(top4Movies, id: \.self) { index in
                    NavigationLink{
                        DetailMovieView(movie: index)
                    }label:{
                        ZStack(alignment: .topLeading){
                            AsyncImage(url: index.fullPosterURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                   
                                    
                                    
                                    
                                }
                                else if phase.error != nil {
                                    Image(systemName: "xmark.octagon")
                                        .resizable()
                                    
                                        .foregroundColor(.red)
                                }
                                else{
                                    ProgressView()
                                }
                                
                            }
                            .frame(height: 199)
                            .cornerRadius(10)
                            Button {
                                viewModel.setLikedDislikedMovieById(movieId: index.id ?? 0)
                            } label: {
                                
                                Image(systemName: "heart.fill")
                                    .foregroundColor(index.isLikedBytheUser ?? false ? .pink : .white)
                                    .bold()
                                    .padding([.top,.leading],10)
                            }

                            
                            VStack(){
                                Text(index.title ?? "Unknown movie")
                                    .foregroundColor(.white)
                                    .font(.footnote)
                                    .bold()
                                
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                    
                                    Text(String(format: "%.1f", index.voteAverage ?? 0.0))
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity,alignment: .leading)
                               
                                
                            }
                            
                            
                            .frame(maxHeight: .infinity, alignment: .bottomLeading)
                            .padding([.bottom,.leading],10)
                            
                        }
                    }
                    
                }
            }
                      .padding(20)
            
//            Button {
//                
//            } label: {
//                Text("More")
//                    .padding()
//                    .frame(width: 150, height: 60)
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    
//            }
//            .padding(.bottom)

                 
        }
        }
    }

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
