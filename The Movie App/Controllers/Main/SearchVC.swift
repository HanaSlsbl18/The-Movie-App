//
//  SearchVC.swift
//  The Movies App
//
//  Created by Hana Salsabila on 16/02/23.
//

import UIKit

class SearchVC: UIViewController {
    
    private var titles : [Title] = [Title]()

    private let searchTableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tv
    }()
    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a Movie or Tv Shows"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: nil)
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    private func fetchDiscoverMovies() {
        ApiCaller.shared.getDiscoverMovies(with: 1) { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }

}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for:  indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleVM(titleName: title.original_name ?? title.original_title ?? "Unknwon name", posterURL: title.poster_path ?? "")
        cell.configure (with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        ApiCaller.shared.getTrailer(with: "\(titleName) trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let viewModel = TitleInfoVM(id: title.id, title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "", media: title.media_type ?? "", releaseData: title.release_date ?? "", voteRating: title.vote_average)
                    let vc = InfoPreviewVC()
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchVC: UISearchResultsUpdating, SearchResultsVCDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsVC else {
            return
        }
        
        resultController.delegate = self
        
        ApiCaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func searchResultsVCDidTapItem(_ viewModel: TitleInfoVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = InfoPreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
