//
//  getRepositories.swift
//  SearchRepository
//
//  Created by 北邑圭佑 on 2019/07/10.
//  Copyright © 2019 北邑圭佑. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetRepositories {
    
    func getRepository(language: String = "swift") -> [Repository] {
        
        let requestUrl = "https://api.github.com/search/repositories"
        let params = [
            "q": "language:" + language,
            "sort": "stars",
            "order": "desc"
        ]
        
        var repositories = [Repository]()
        let semaphore = DispatchSemaphore(value: 0)
        
        Alamofire.request(requestUrl, method: .get, parameters: params)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)["items"]
                
                json.forEach { (_, json) in
                    let fullName: String = json["full_name"].string!
                    
                    var description = json["description"].string
                    if description == nil {
                        description = " "
                    }
                    let stars: Int = json["stargazers_count"].int!
                    let htmlUrl: String = json["html_url"].string!
                    
                    // 配列に格納
                    repositories.append(Repository(fullName: fullName, description: description!, stars: stars, htmlUrl: htmlUrl))
                }
                
                // 検索結果が0件の時にアラートを表示
                if repositories.count == 0 {
                    let alert = UIAlertController(title: "" ,message: "0 results", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    TableViewController().present(alert, animated: true, completion: nil)
                }
                
                semaphore.signal()
        }
        
        semaphore.wait()
        return repositories
    }
}
