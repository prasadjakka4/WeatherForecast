//
//  WeatherDataCell.swift
//  WeatherForecastApp
//
//  Created by Prasad Jakka on 9/5/24.
//

import UIKit

class WeatherDataCell: UITableViewCell {

    @IBOutlet weak private var tempLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var humiditylabel: UILabel!
    @IBOutlet weak private var windLabel: UILabel!
    @IBOutlet weak private var pressureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(model: WeatherDataModel) {
        self.descriptionLabel.text = model.description
        self.tempLabel.text = "\(model.temparature) \(AppStrings.UNIT_K)"
        self.humiditylabel.text = model.humidity
        self.pressureLabel.text = model.pressure
        self.windLabel.text = model.windSpeed
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
