//
//  DropboxBrowserViewController.swift
//  MixCheck
//
//  Created by Dylan Lauzon on 2022-07-18.
//

import Foundation
import SwiftyDropbox

final class DropboxBrowserViewController : UIViewController {
    private var rows = Array<dbRow>()
    
    private lazy var tableView: UITableView = {
       let v = UITableView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.dataSource = self
        v.register(DropboxBrowserViewCell.self, forCellReuseIdentifier: "cell")
        v.estimatedRowHeight = 40
        v.rowHeight = UITableView.automaticDimension
        v.tableFooterView = UIView()
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArray()
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func populateArray() {
        if let client = DropboxClientsManager.authorizedClient {
            
            
            client.users.getCurrentAccount().response { response, error in
                    if let account = response {
                        print("Hello \(account.name.givenName)")
                    } else {
                        print(error!)
                    }
                }
            
            client.files.listFolder(path: "").response { response, error in
                    if let result = response {
                        print("Folder contents:")
                        for entry in result.entries {
                            let newRow : dbRow  = dbRow(type: String(describing: type(of:entry)), name: entry.name, metadata: entry)
                            print(newRow.type)
                            self.rows.append(newRow)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!)
                    }
                }
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
        
    
    


extension DropboxBrowserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DropboxBrowserViewCell
            else {
                return UITableViewCell()
            }
        
        cell.dbRow = rows[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let client = DropboxClientsManager.authorizedClient
        
        client?.files.listFolder(path: rows[indexPath.row].metadata.pathLower!).response { response, error in
                if let result = response {
                    let item = self.rows[indexPath.row]
                    self.rows = Array<dbRow>()
                    
                    if(item.metadata.pathLower != "")
                    {
                        let pathComponents = item.metadata.pathLower?.split(separator: "/")
                        var parentPath : String = ""
                        var i = 0
                        if(pathComponents!.count > 1) {
                            repeat {
                                parentPath += "/" + (pathComponents?[i])!
                                i += 1
                            } while ( i < pathComponents!.count - 1)
                        }
                        let previous = Files.Metadata.init(name: "Previous", pathLower: parentPath, pathDisplay: parentPath, parentSharedFolderId: "id", previewUrl: "nil")
                        let previousRow = dbRow(type: String(describing: (type(of: previous))), name: "Previous", metadata: previous)
                        
                        self.rows.append(previousRow)
                    }
                    
                    for entry in result.entries {
                        //populate table
                        let newRow : dbRow  = dbRow(type: String(describing: type(of:entry)), name: entry.name, metadata: entry)
                        print(newRow.type)
                        self.rows.append(newRow)
                        self.tableView.reloadData()
                    }
                } else {
                    print(error!)
                }
            }

    }
    
    
}


