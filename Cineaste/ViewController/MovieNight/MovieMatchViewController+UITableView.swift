//
//  MovieMatchViewController+UITableView.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension MovieMatchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesWithNumber.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieMatchCell = tableView.dequeueCell(identifier: MovieMatchCell.identifier)

        let movieWithNumber = filteredMoviesWithNumber[indexPath.row]
        if showAllTogetherMovies {
            cell.configure(
                with: movieWithNumber.movie,
                numberOfMatches: movieWithNumber.number,
                amountOfPeople: totalNumberOfPeople,
                delegate: self
            )
        } else {
            cell.configure(
                with: movieWithNumber.movie,
                delegate: self
            )
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearbyMovie = filteredMoviesWithNumber[indexPath.row].movie

        store.dispatch(SelectionAction.select(movie: Movie(id: nearbyMovie.id)))

        let movieDetailVC = MovieDetailViewController.instantiate()
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath
            else { return }
        let id = indexPath.row

        let nearbyMovie = filteredMoviesWithNumber[id].movie
        let movie = Movie(with: nearbyMovie)

        animator.addCompletion {
            store.dispatch(SelectionAction.select(movie: movie))
            let detailVC = MovieDetailViewController.instantiate()
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @available(iOS 13.0, *)
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let nearbyMovie = filteredMoviesWithNumber[indexPath.row].movie
        let movie = ownMovies.first { $0.id == nearbyMovie.id } ?? Movie(with: nearbyMovie)

        let configuration = UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                store.dispatch(SelectionAction.select(movie: movie))
                let detailVC = MovieDetailViewController.instantiate()
                detailVC.hidesBottomBarWhenPushed = true
                return detailVC
            }, actionProvider: { _ in
            let actions = ContextMenu.actions(
                for: movie,
                watchState: movie.currentWatchState,
                presenter: self
            )
            return UIMenu(title: "", image: nil, identifier: nil, children: actions)
            }
        )

        return configuration
    }
}