//
//  AuctionItemCell.swift
//  SandPointAuction
//
//  Created by Cameron Klein on 1/3/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class AuctionItemCell: UITableViewCell {
  
  @IBOutlet weak var cornerSquare: UIView!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var numberLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
    
}
