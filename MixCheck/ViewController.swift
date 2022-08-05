//
//  ViewController.swift
//  MixCheck
//
//  Created by Dylan Lauzon on 2022-07-14.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {
    
    private let albums = Album.get()
    
    private lazy var tableView: UITableView = {
       let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.dataSource = self
        v.register(AlbumTableViewCell.self, forCellReuseIdentifier: "cell")
        v.estimatedRowHeight = 132
        v.rowHeight = UITableView.automaticDimension
        v.tableFooterView = UIView()
        
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        title = "GoodRef"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(dropbox), imageName: "dropbox-logo")

        
        //self.navigationController?.navigationItem.rightBarButtonItem = doneItem
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dropbox() {
        
        if let client = DropboxClientsManager.authorizedClient {            
            let vc = DropboxBrowserViewController()
            present(vc, animated: true, completion: nil)
        } else {
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.content.write", "files.metadata.read", "files.content.read"], includeGrantedScopes: true)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: self,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
                )
        }
        }
        
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumTableViewCell
            else {
                return UITableViewCell()
            }
        
        cell.album = albums[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MusicPlayerViewController(album: albums[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        present(vc, animated: true, completion: nil)
    }
}

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true

        return menuBarItem
    }
}
