//
//  GIFsContainerViewController.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import UIKit

/// The possible states this view controller can be in
enum GIFsContainerViewControllerState {
    /// the view is not displaying any searched GIFs
    case empty
    /// API is being accessed to retrieve GIFs
    case searching
    /// The retrieved GIFs are being viewed
    case viewingResults(query: String, GIFs: [GIF])
}

/// Container View Controller that displays searched GIFs. When viewing search results, has a `GIFsCollectionViewController` as its child View Controller
class GIFsContainerViewController: UIViewController {
    
    // MARK: - outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - instance properties
    /// Allows easy configuration of a `UISearchBar` in the navigation item
    var searchController: UISearchController!
    
    /// The current state which updates the UI when changed
    var gifsContainerViewControllerState = GIFsContainerViewControllerState.empty {
        didSet {
            DispatchQueue.main.async {
                self.configureForState()
            }
        }
    }
    
    /// Interacts with the Giphy API. In a larger app, this may be configured via Dependency Injection
    lazy var giphyAPIController = GiphyAPIController()
    
    // MARK: - generated properties
    /// Displays the GIFs in the `viewingResults` state
    var childGIFsCollectionViewController: GIFsCollectionViewController? { children.first as? GIFsCollectionViewController }
    
    // MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - private methods
    /// Updates UI after a state change
    private func configureForState() {
        var animateActivityIndicator = false
        var resultGIFs: [GIF]?
        
        switch gifsContainerViewControllerState {
        case .empty:
            break
            
        case .searching:
            animateActivityIndicator = true
            
        case .viewingResults(_, let GIFs):
            resultGIFs = GIFs
        }
        
        animateActivityIndicator ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        if let resultGIFs = resultGIFs {
            configureGIFsCollectionViewController(with: resultGIFs)
        } else {
            removeGIFsCollectionViewController()
        }
    }
    
    /// Adds a child view controller to display GIFs
    /// - Parameter GIFs: the GIFs to display
    private func configureGIFsCollectionViewController(with GIFs: [GIF]) {
        guard let GIFsCollectionViewController = storyboard?.instantiateViewController(identifier: UIStoryboard.GIFsCollectionViewControllerStoryboardID) as? GIFsCollectionViewController else { return }
        
        addChild(GIFsCollectionViewController)
        view.insertSubview(GIFsCollectionViewController.view, at: 0)
        GIFsCollectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        GIFsCollectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        GIFsCollectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        GIFsCollectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        GIFsCollectionViewController.didMove(toParent: self)
        
        GIFsCollectionViewController.GIFs = GIFs
    }
    
    /// Removes a child view controller if it exists. On each subsequent search, a new child VC is instantiated
    private func removeGIFsCollectionViewController() {
        guard let childGIFsCollectionViewController = childGIFsCollectionViewController else { return }
        childGIFsCollectionViewController.willMove(toParent: nil)
        childGIFsCollectionViewController.view.removeFromSuperview()
        childGIFsCollectionViewController.removeFromParent()
    }
}

// MARK: - UISearchBarDelegate extension
extension GIFsContainerViewController: UISearchBarDelegate {
    /// Performs the Search on the Gipjy API
    /// - Parameter searchBar: the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true)
        
        guard let query = searchBar.text else { return }
        gifsContainerViewControllerState = .searching
        giphyAPIController.searchGIFs(query: query) { result in
            switch result {
            case .success(let GIFs):
                self.gifsContainerViewControllerState = .viewingResults(query: query, GIFs: GIFs)
                
            case .failure(let error):
                self.gifsContainerViewControllerState = .empty
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    /// Updates the state if the user clears the query
    /// - Parameters:
    ///   - searchBar: the search bar
    ///   - searchText: the new search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch gifsContainerViewControllerState {
        case .viewingResults(let query, _):
            if query != searchText {
                gifsContainerViewControllerState = .empty
            }
        default:
            break
        }
    }
}

