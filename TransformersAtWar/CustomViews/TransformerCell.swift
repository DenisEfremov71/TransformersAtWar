//
//  Transformer.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-29.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import UIKit

class TransformerCell: UITableViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOverallRating: UILabel!
    @IBOutlet weak var lblAttributes: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
