//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Валерий on 25.02.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let MostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(MostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
