//
//  TransformerListTableViewController.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import UIKit

class TransformerListTableViewController: UITableViewController, TransformerDetailsDelegate {
    
    var presenter = TransformerListPresenter()
    var transformers = [Transformer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        presenter.getAllTransformers { (transformers) in
            guard let transformers = transformers else {
                print("Error: no transformers returned")
                return
            }
            self.transformers = transformers
            self.tableView.reloadData()
        }
        //presenter.getTransformer(id: "-LsCxYiU3dR0VNnhD9Vo")
        //print("JWT Token: \(KeychainHelper.getAllSparkToken() ?? "no token")")
        
        self.title = "Transformers at War"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransformer))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func addTransformer() {
        if tableView.isEditing {
            return
        }
        performSegue(withIdentifier: "showTransformerDetails", sender: "addButton")
    }
    
    // MARK: TransformerDetailsDelegate
    
    func setNewTransformer(transformer: Transformer) {
        transformers.append(transformer)
        tableView.reloadData()
    }
    
    func updateTransformer(id: Int, transformer: Transformer) {
        transformers[id] = transformer
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transformers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTransformer", for: indexPath)

        // Configure the cell...
        if transformers[indexPath.row].team == "A" {
            cell.imageView?.image = UIImage.init(named: "autobot")
        } else {
            cell.imageView?.image = UIImage.init(named: "decepticon")
        }
        cell.textLabel?.text = transformers[indexPath.row].name
        cell.detailTextLabel?.text = "Overall rating: \(transformers[indexPath.row].overallRating)"

        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTransformerDetails", sender: "cellTransformer")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = transformers[indexPath.row].id!
            let name = transformers[indexPath.row].name
            presenter.deleteTransformer(id: id) { (success) in
                if success {
                    self.transformers.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    UiHelper.showAlert(for: self, with: "\(Constants.ErrorMessaages.failedToDelete) \(name)")
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TransformerDetailsViewController
        vc.delegate = self
        if (sender as! String) == "addButton" {
            vc.mode = .add
        } else if (sender as! String) == "cellTransformer" {
            let id = tableView.indexPathForSelectedRow?.row
            vc.mode = .edit
            vc.arrayId = id
            vc.transformer = transformers[id!]
        }
    }

}
