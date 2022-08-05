//
//  DropboxBrowserViewCell.swift
//  MixCheck
//
//  Created by Dylan Lauzon on 2022-07-18.
//

import Foundation
import UIKit
import SwiftyDropbox

final class DropboxBrowserViewCell: UITableViewCell {
    var dbRow: dbRow? {
        didSet {
            if dbRow?.type == "FolderMetadata"{
                rowIcon.image = UIImage(systemName: "folder" )!
            } else if ((dbRow?.name.hasSuffix(".mp3")) == true) || (dbRow?.name.hasSuffix(".wav")) == true {
                rowIcon.image = UIImage(systemName: "music.note")
            } else if dbRow?.name == "Previous"{
                rowIcon.image = UIImage(systemName: "arrow.uturn.backward.square")
            } else {
                rowIcon.image = UIImage(systemName: "slash.circle")
            }
            
            rowName.text = dbRow?.name
            
        }
    }
    
    private lazy var rowIcon: UIImageView = {
       let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        return v
    }()
    
    private lazy var rowName: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        v.textColor = UIColor(named: "TitleColor")
        v.textAlignment = NSTextAlignment.left
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [rowIcon, rowName].forEach { (v) in
            contentView.addSubview(v)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        //album cover
        NSLayoutConstraint.activate([
            rowIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rowIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            rowIcon.widthAnchor.constraint(equalToConstant: 40),
            rowIcon.heightAnchor.constraint(equalToConstant: 40),
            rowIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // album name
        NSLayoutConstraint.activate([
            rowName.leadingAnchor.constraint(equalTo: rowIcon.trailingAnchor, constant: 16),
            rowName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: bounds.height/2 + 10),
            rowName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
    }
}
