//
//  HomeVC.swift
//  The Movies App
//
//  Created by Hana Salsabila on 16/02/23.
//

import UIKit
import Network

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
    case Discover = 5
}

class HomeVC: UIViewController {
    
    let reachability = try! Reachability()
    
    private var randomTrendingMovies: Title?
    private var headerView: HomeHeaderView?
    
    let sectionTitles : [String] = ["Trending Movies", "Trending Tv Shows","Popular Movies", "Upcoming Movies", "Top Rated Movies", "Discover Movies"]
    
    private let homeTableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print ("Reachable via WiFi")
                } else if reachability.connection == .cellular {
                    print ("Reachable via Cellular")
                } else if reachability.connection == .unavailable {
                    print ("Unavailable")
                }
            }
            self.reachability.whenUnreachable = { _ in
                print ("Not reachable")
                let alert = UIAlertController(title: "No Connection.", message: "Your internet is unreachable. Please check your internet connection. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            }
            do {
                print("halo")
                try self.reachability.startNotifier()
            } catch {
                print ("Unable to start notifier")
            }
        }
    }
    deinit {
        reachability.stopNotifier()
    }
    
    func configureAll() {
        view.backgroundColor = .systemBackground

        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        configureNavBar()
        configureMainHeaderView()
        view.addSubview(homeTableView)
    }
    
    func configureMainHeaderView() {
        headerView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 600))
        homeTableView.tableHeaderView = headerView
        
        ApiCaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitles = titles.randomElement()
                self?.randomTrendingMovies = selectedTitles
                self?.headerView?.configure(with: TitleVM(titleName: selectedTitles?.original_name ?? selectedTitles?.original_title ?? "", posterURL: selectedTitles?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configureNavBar() {
        var image = UIImage(named: "tmdbLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            ApiCaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTvs.rawValue:
            ApiCaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Popular.rawValue:
            ApiCaller.shared.getPopularMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.UpcomingMovies.rawValue:
            ApiCaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.TopRated.rawValue:
            ApiCaller.shared.getTopRatedMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Discover.rawValue:
            ApiCaller.shared.getDiscoverMovies { results in
                DispatchQueue.main.async {
                    switch results {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return 420
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitleInfoVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = InfoDetailsVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
