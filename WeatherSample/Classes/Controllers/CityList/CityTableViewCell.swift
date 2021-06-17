//
//  CityTableViewCell.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak  var weatherImage: UIImageView!
    @IBOutlet weak  var cityName: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
