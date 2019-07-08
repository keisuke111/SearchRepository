//
//  TableViewController.swift
//  SearchRepository
//
//  Created by 北邑圭佑 on 2019/07/08.
//  Copyright © 2019 北邑圭佑. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    @IBOutlet var repositoryTableView: UITableView!
    
    let semaphore = DispatchSemaphore(value: 0)
    
    var repositories = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.getRepository()
            DispatchQueue.main.async {
                self.repositoryTableView.reloadData()
            }
            print(self.repositories[0].stars)
        }
        
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        let repository = repositories[indexPath.row]
        
        cell.fullNameLabel.text = repository.fullName
        cell.descriptionLabel.text = repository.description
        cell.starsLabel.text = (repository.stars).description
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getRepository() {
        
        let requestUrl = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"
        
        Alamofire.request(requestUrl, method: .get)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)["items"]
                
                json.forEach { (_, json) in
                    let fullName: String = json["full_name"].string!
                    let description: String = json["description"].string!
                    let stars: Int = json["stargazers_count"].int!
                    let htmlUrl: String = json["html_url"].string!
                    
                    // 配列に格納
                    self.repositories.append(Repository(fullName, description, stars, htmlUrl))
                }
                
                self.semaphore.signal()
        }
        
        semaphore.wait()
        
    }

}
