//
//  TableViewController.swift
//  SearchRepository
//
//  Created by 北邑圭佑 on 2019/07/08.
//  Copyright © 2019 北邑圭佑. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var repositoryTableView: UITableView!
    
    // 遷移先のvcに渡す変数
    var giveData: String = ""
    
    var repositories = [Repository]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.repositories = GetRepositories().getRepository()
            DispatchQueue.main.async {
                self.repositoryTableView.reloadData()
            }
        }
        
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
    }
    
    // MARK: - Search Bar Delegate
    
    // cancel button tap
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 空検索を弾く
        guard searchBar.text != "" else {
            return
        }
        
        let query = searchBar.text!
        
        DispatchQueue.global().async {
            self.repositories = GetRepositories().getRepository(language: query)
            DispatchQueue.main.async {
                self.repositoryTableView.reloadData()
            }
        }
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // セルの数を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    // 各セルの要素を指定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell  else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        
        let repository = repositories[indexPath.row]
        
        cell.fullNameLabel.text = repository.fullName
        cell.descriptionLabel.text = repository.description
        cell.starsLabel.text = "☆ " + (repository.stars).description
        
        return cell
    }
    
    // セルが押された時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        giveData = repositories[indexPath.item].htmlUrl
        
        // 遷移
        performSegue(withIdentifier: "Segue", sender: nil)
    }
    
    // Header Size
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // Header View
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Search Bar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "language"
        searchBar.showsCancelButton = true
        searchBar.showsSearchResultsButton = true
        
        return searchBar
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let vc = segue.destination as! ViewController
            
            vc.data = giveData
        }
    }
}
