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
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var star: UILabel!
  @IBOutlet weak var filledStar: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
    
}
