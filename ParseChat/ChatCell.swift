//
//  ChatCell.swift
//  ParseChat
//
//  Created by Francisco Hernanedez on 10/2/18.
//  Copyright © 2018 Francisco Hernanedz. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
