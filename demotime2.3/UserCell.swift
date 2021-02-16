//
//  UserCell.swift
//  demotime2.2
//
//  Created by Kapil Dev on 15/02/21.
//
import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    let userImage = UIImageView()
    let userName = UILabel()
    let details = UILabel()
    let deleteButton = UIButton()
    var fname: String? = ""
    weak var delegate: UserCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.setBackgroundImage(UIImage(named: "removeImage"), for: .normal)
        details.textColor = UIColor.gray
        userName.font = UIFont.boldSystemFont(ofSize: 23)
        userName.textColor = UIColor(red: 100/256, green: 153/256, blue: 255/256, alpha: 1.0)
        
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        details.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(details)
        contentView.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            userImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            userName.heightAnchor.constraint(equalToConstant: 30),
            userName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20),
            userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        NSLayoutConstraint.activate([
            details.heightAnchor.constraint(equalToConstant: 20),
            details.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            details.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
            details.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20)
        ])
    }
    
    @objc func deleteButtonTapped() {
        if let userName = fname {
            self.delegate?.deleteTableViewCell(self, deleteButtonTappedFor: userName)
            print("delete button tapped from userCell")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol UserCellDelegate: AnyObject {
  func deleteTableViewCell(_ userCell: UserCell, deleteButtonTappedFor user: String)
}
