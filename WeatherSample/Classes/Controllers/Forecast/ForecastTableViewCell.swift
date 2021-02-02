//
//  ForecastTableViewCell.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 02/02/21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak  var humidityLabel: UILabel!
    @IBOutlet weak  var visibilityLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak  var windLabel: UILabel!
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
