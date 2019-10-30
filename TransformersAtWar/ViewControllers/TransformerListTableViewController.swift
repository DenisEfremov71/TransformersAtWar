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
    
    // MARK: - view controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getAllTransformers { (transformers) in
            guard let transformers = transformers else {
                print("Error: no transformers returned")
                return
            }
            self.transformers = transformers
            self.tableView.reloadData()
        }
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - TransformerDetailsDelegate
    
    func setNewTransformer(transformer: Transformer) {
        transformers.append(transformer)
        tableView.reloadData()
    }
    
    func updateTransformer(id: Int, transformer: Transformer) {
        transformers[id] = transformer
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transformerCell", for: indexPath)
        
        if let transformerCell = cell as? TransformerCell {
            // Configure the cell...
            if transformers[indexPath.row].team == "A" {
                transformerCell.teamImage?.image = UIImage.init(named: "autobot")
            } else {
                transformerCell.teamImage?.image = UIImage.init(named: "decepticon")
            }
            transformerCell.lblName.text = transformers[indexPath.row].name
            transformerCell.lblOverallRating.text = "Overall rating: \(transformers[indexPath.row].overallRating)"
            transformerCell.lblAttributes.text = "Attributes: \(transformers[indexPath.row].strength), \(transformers[indexPath.row].intelligence), \(transformers[indexPath.row].speed), \(transformers[indexPath.row].endurance), \(transformers[indexPath.row].rank), \(transformers[indexPath.row].courage), \(transformers[indexPath.row].firepower), \(transformers[indexPath.row].skill)"
            transformerCell.accessibilityIdentifier = "transformerCell\(indexPath.row)"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = transformers[indexPath.row].id!
            let name = transformers[indexPath.row].name
            presenter.deleteTransformer(id: id) { (success) in
                if success {
                    let index = indexPath.row
                    self.presenter.realmManager.deleteTransformer(transformer: self.transformers[index])
                    self.transformers.remove(at: index)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    UiHelper.showAlert(for: self, with: "\(Constants.ErrorMessaages.failedToDelete) \(name)")
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        
        let buttonWageTheWar = UIButton()
        buttonWageTheWar.frame = CGRect(x: 20, y: 25, width: 130, height: 50)
        buttonWageTheWar.setTitle("Wage the War", for: .normal)
        buttonWageTheWar.setTitleColor(UIColor.white, for: .normal)
        buttonWageTheWar.backgroundColor = UIColor.init(red: 253.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        buttonWageTheWar.addTarget(self, action: #selector(wageTheWar), for: .touchUpInside)
        footerView.addSubview(buttonWageTheWar)
        
        // TODO: add constraints
        
        return footerView
    }
    
    @objc func wageTheWar() {
        if transformers.count == 0 {
            UiHelper.showAlert(for: self, with: "Please add transformers!")
            return
        }
        print("War is about to begin...")
        presenter.wageTheWar(transformers: transformers) { (result) in
            UiHelper.showAlert(for: self, with: result, completion: {
                // can add additional logic on the end of the war
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTransformerDetails", sender: "cellTransformer")
    }

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
