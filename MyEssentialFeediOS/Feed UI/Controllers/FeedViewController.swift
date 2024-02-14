//
//  FeedViewController.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 06/12/23.
//


//OS 15 Update
//On iOS 15+, the cell lifecycle behavior changed. For performance reasons, when the cell is removed from the table view and quickly added back (e.g., by scrolling up and down fast), the data source may not recreate the cell anymore using the cellForRow method if there's a cached cell for that IndexPath.
//
//If there’s a cached cell for that IndexPath, it'll just call willDisplayCell to avoid recreating a cell that’s already cached. This is more performant. However, we cancel requests on didEndDisplayingCell and only load them again if cellForRow is called. In this scenario, there's a possibility of the cached cell becoming visible again and never displaying an image until cellForRow is called after scrolling the table up and down again.
//
//So on iOS 15+, if we cancel any resource loading on didEndDisplayingCell, we must load/reload those resources on willDisplayCell.

import UIKit
import MyEssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}


public protocol CellController {
    func view(in tableView: UITableView) -> UITableViewCell
    func preload()
    func cancelLoad()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {

    
    var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    public var delegate: FeedViewControllerDelegate?
    
    @IBOutlet private(set) public var errorView: ErrorView?
    
    private var loadingControllers = [IndexPath: CellController]()

    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }

    
    
    
    // convenience initializer becase we don't need any custom initialization (in this way we don't need to implement UIViewController's required initializer)
//    convenience init(refreshController: FeedRefreshViewController) {
//        self.init()
//        self.refreshController = refreshController
//
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        

//        refreshControl = refreshController?.view
        
        
        onViewIsAppearing = { vc in // guarantee that load logic run only once, because othervise onViewIsAppearing could be called more than once
            
            self.refresh()
            vc.onViewIsAppearing = nil
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    override public func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    
    
    
    @IBAction private func refresh() {
        
        delegate?.didRequestFeedRefresh()
    }
    
    
    
    public func display(_ cellControllers: [CellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }
    
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in

            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
//        indexPaths.forEach { indexPath in
//            cancelTask(forRowAt: indexPath)
//        }
        // short
        indexPaths.forEach(cancelCellControllerLoad)

    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
        
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {

//        cellController(forRowAt: indexPath).cancelLoad()
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}
