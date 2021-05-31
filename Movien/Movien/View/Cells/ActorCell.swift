//
//  ActorCell.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import UIKit

class ActorCell: UICollectionViewCell {
    
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        imageView.makeRounded()
    }
}

