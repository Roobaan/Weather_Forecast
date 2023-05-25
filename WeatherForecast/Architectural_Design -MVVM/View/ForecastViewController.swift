//
//  ForecastViewController.swift
//  WeatherForecast
//
//  Created by Roobaan M T on 24/05/23.
//

import UIKit

class ForecastViewController: UIViewController {
    
    let weatherViewModel = WeatherViewModel()
    
    lazy var currentWeather = UIImageView()
    
    lazy var countryLabel = UILabel()
    
    lazy var currentDateLabel = UILabel()
    
    lazy var tableView = UITableView()
    
    var attributedText : NSMutableAttributedString?
    
    var attributedText1 : NSMutableAttributedString?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialUI()
        
        weatherViewModel.fetchForecast(city: "Chennai") { error in
            guard error == nil else{
                print("Error")
                return
            }
            DispatchQueue.main.async { [self] in
                self.tableView.reloadData()
                self.weatherViewModel.weatherResponse?.current?.condition?.loadImage(completion: { image in
                    if let image = image {
                        DispatchQueue.main.sync {
                            self.currentWeather.image = image
                        }
                    } else {
                        print("Failed to load image")
                    }
                })
       
                let inputString = ((self.weatherViewModel.weatherResponse?.location?.name)!)+", "+((self.weatherViewModel.weatherResponse?.location?.country)!)+"\n"+"\(self.weatherViewModel.weatherResponse?.current?.temp_c! ?? 0)\u{00B0}"
                attributedText = NSMutableAttributedString(string: inputString)
                let range = (inputString as NSString).range(of: "\n")
                self.attributedText!.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length:  range.location))
                self.attributedText!.addAttribute(.font, value: UIFont.systemFont(ofSize: 32, weight: .bold), range: NSRange(location: 0, length:  range.location))
                self.countryLabel.attributedText = attributedText
                
                let inputString1 = self.weatherViewModel.weatherResponse?.location?.localtime ?? ""
                self.attributedText1 = NSMutableAttributedString(string: inputString1)
                let range1 = (inputString1 as NSString).range(of: " ")
                attributedText1!.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length:  range1.location))
                self.currentDateLabel.attributedText = attributedText1
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            if size.width > size.height {
                self.landscapeUI()
            }
            else {
                self.setInitialUI()
            }
        }, completion: nil)
    }
    
    //MARK: - Landsscape view
    func landscapeUI(){
        currentWeather.frame = CGRect(x: 0, y: 0, width: view.frame.size.width * 0.4, height: view.frame.size.height  )
        currentWeather.contentMode = .scaleAspectFill
        view.addSubview(currentWeather)
        
        countryLabel.frame = CGRect(x: 0, y: 0, width: currentWeather.frame.size.width , height: currentWeather.frame.size.height * 0.8)
        countryLabel.font = .systemFont(ofSize: 80, weight: .light)
        countryLabel.textColor = UIColor.systemCyan
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.numberOfLines = 0
        countryLabel.textAlignment = .center
        countryLabel.attributedText = attributedText
        currentWeather.addSubview(countryLabel)
        
        currentDateLabel.frame = CGRect(x: 0, y: countryLabel.frame.maxY, width: currentWeather.frame.size.width , height: currentWeather.frame.size.height * 0.2)
        currentDateLabel.adjustsFontSizeToFitWidth = true
        
        currentDateLabel.font = .systemFont(ofSize: 32, weight: .light)
        currentDateLabel.textColor = UIColor.gray
        currentDateLabel.numberOfLines = 0
        currentDateLabel.textAlignment = .center
        currentDateLabel.attributedText = attributedText1

        currentWeather.addSubview(currentDateLabel)
        tableView.frame = CGRect(x: CGFloat(currentWeather.frame.maxX), y: 0, width: view.frame.size.width * 0.6, height: view.frame.size.height )
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        view.addSubview(tableView)
    }
    
    //MARK: - Initial view
    func setInitialUI(){
        // currentWeather initialization
        currentWeather.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.4)
        currentWeather.contentMode = .scaleAspectFill
        view.addSubview(currentWeather)
        
        // country label initialization
        countryLabel.frame = CGRect(x: 0, y: 0, width: currentWeather.frame.size.width, height: currentWeather.frame.size.height * 0.8)
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.font = .systemFont(ofSize: 80, weight: .light)
        countryLabel.textColor = UIColor.systemCyan
        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.numberOfLines = 0
        countryLabel.textAlignment = .center
        countryLabel.attributedText = attributedText
        currentWeather.addSubview(countryLabel)
        
        ///current date initialization
        currentDateLabel.frame = CGRect(x: 0, y: countryLabel.frame.maxY, width: currentWeather.frame.size.width, height: currentWeather.frame.size.height * 0.2)
        currentDateLabel.adjustsFontSizeToFitWidth = true
        currentDateLabel.attributedText = attributedText1
        currentDateLabel.font = .systemFont(ofSize: 32, weight: .light)
        currentDateLabel.textColor = UIColor.gray
        currentDateLabel.numberOfLines = 0
        currentDateLabel.textAlignment = .center
        currentWeather.addSubview(currentDateLabel)

        //table view initialization
        tableView.frame = CGRect(x: 0, y: CGFloat(currentWeather.frame.maxY), width: view.frame.size.width, height: view.frame.size.height * 0.6)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        view.addSubview(tableView)
    }
    
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.weatherResponse?.forecast?.forecastday?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.selectionStyle = .none

        let dict = weatherViewModel.weatherResponse?.forecast?.forecastday![indexPath.row]
        cell.dateLabel.text = dict?.date
        dict?.day?.condition?.loadImage { image in
            if let image = image {
                DispatchQueue.main.sync {
                    cell.weatherIcon.image = image
                }
            } else {
                print("Failed to load image")
            }
        }
        cell.maxTempLabel.text = String(dict?.day?.maxtemp_c ?? 0)+"\u{00B0}"
        cell.minTempLabel.text = String(dict?.day?.mintemp_c ?? 0)+"\u{00B0}"
       return cell
    }
    
    
}
