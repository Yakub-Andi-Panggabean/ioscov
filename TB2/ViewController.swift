//
//  ViewController.swift
//  TB2
//
//  Created by OVO on 07/12/20.
//  Copyright © 2020 yakub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtTotalCase: UILabel!
    @IBOutlet weak var txtDeathCase: UILabel!
    @IBOutlet weak var txtCuredCase: UILabel!
    @IBOutlet weak var txtTreatedCase: UILabel!
    @IBOutlet weak var txtLastUpdate: UILabel!
    @IBOutlet weak var lastUpdatedDate: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let conf=ConfigAccessor.parseConfig()
        self.createHttpRequest(dns: conf.covidDns, path: conf.pathIndonesia)
    }
    
    
    func createHttpRequest(dns:String,path:String){
        let  url=URL(string:dns+path)!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let response=try!decoder.decode(ResponseCasesData.self,from :data)
            print(response)
            DispatchQueue.main.async {
                self.setComponent(casesData: response)
            }
            }.resume()
    }
    
    func setComponent(casesData: ResponseCasesData){
        let recovered=casesData.recovered.value
        let deaths=casesData.deaths.value
        let confirmed=casesData.confirmed.value
        let treated=confirmed-(deaths+recovered)
        txtCuredCase.text=String(recovered)
        txtDeathCase.text=String(deaths)
        txtTotalCase.text=String(confirmed)
        txtTreatedCase.text=String(treated)
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "EEEE, MMM d, yyyy"
        let formatter2 = DateFormatter()
        formatter2.timeStyle = .medium
        lastUpdatedDate.text=formatter1.string(from: casesData.lastUpdate)
        txtLastUpdate.text=formatter2.string(from: casesData.lastUpdate)
    }
    
    struct CasesData:Decodable {
        let value: Int
        let detail: URL
    }
    
    struct ResponseCasesData:Decodable {
        let confirmed: CasesData
        let recovered :CasesData
        let deaths: CasesData
        let lastUpdate: Date
    }
    
    
}

