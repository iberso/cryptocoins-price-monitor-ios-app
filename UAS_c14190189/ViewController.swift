//
//  ViewController.swift
//  UAS_c14190189
//
//  Created by Adakah? on 04/12/21.
//

import UIKit


struct StructCryptoCoin{
    var coinSymbol: String
    var coinName: String
    var coinImage: String
    var coinCurrentPrice: Double
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelLastRefresh: UILabel!
    var cryptoCoinData:[StructCryptoCoin] = []
    
    //fungsi pull Refresh pada table view
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl){
        fetchData()
        sender.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
        tableView.refreshControl = myRefreshControl
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! CustomTableViewCell
        
        cell.labelViewNomor.text = String(indexPath.row+1)
        cell.labelViewName.text = cryptoCoinData[indexPath.row].coinName + " ("+cryptoCoinData[indexPath.row].coinSymbol.uppercased() + ")"
        cell.labelViewPrice.text = "$" + String(cryptoCoinData[indexPath.row].coinCurrentPrice)

        if let url = URL(string: cryptoCoinData[indexPath.row].coinImage){
            cell.loadImage(from: url)
        }

        return cell
    }
    
    //fungsi mengambil data dari API
    func fetchData(){
        let dispacthGroup = DispatchGroup()
        let headers = [
            "x-rapidapi-host": "coingecko.p.rapidapi.com",
            "x-rapidapi-key": "612c535b69msh0fb42bc6fc38064p1a2acdjsndd96ac1b42f5"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://coingecko.p.rapidapi.com/coins/markets?vs_currency=usd&page=1&per_page=100&order=market_cap_desc")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        dispacthGroup.enter()
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
            }
            if let thisData = data{
                self.cryptoCoinData.removeAll()
                self.parseJSON(data: thisData)
            }
            dispacthGroup.leave()
        })
        dataTask.resume()
        
        dispacthGroup.notify(queue: DispatchQueue.main){
            let date = Date()
            let calender = Calendar.current
            let day: Int = calender.component(.day, from: date)
            let month: Int = calender.component(.month, from: date)
            let year: Int = calender.component(.year, from: date)
            let h: Int = calender.component(.hour, from: date)
            let m: Int = calender.component(.minute, from: date)
            let s: Int = calender.component(.second, from: date)
            
            let dataLastRefresh: String = "Last Fetch Data: " + String(day) + "-" + String(month) + "-" + String(year) + " " + String(h) + ":" + String(m) + ":" + String(s)
            
            print(dataLastRefresh)
            self.labelLastRefresh.text = dataLastRefresh
            self.tableView.reloadData()
        }
    }
    
    //fungsi parse data respon API
    func parseJSON(data: Data){
        let decoder = JSONDecoder()
        do{
            var cryptoCoins: [Coins]
                cryptoCoins = try decoder.decode([Coins].self, from: data)
                
            for coin in cryptoCoins{
                //print(coin.name)
                cryptoCoinData.append(StructCryptoCoin(coinSymbol: coin.symbol, coinName: coin.name, coinImage: coin.image, coinCurrentPrice: coin.current_price))
            }
        }catch{
            print("error")
        }
    }

}

struct Coins: Codable{
    var symbol: String
    var name: String
    var image: String
    var current_price: Double
}

