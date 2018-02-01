//
//  DetailView.swift
//  Project_Thesaurus
//
//  Created by Johan Fornander on 2018-01-30.
//  Copyright © 2018 Johan Fornander. All rights reserved.
//

import UIKit


class DetailView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var word:String = ""
    var synonyms:[String] = []
    var currentIndex:Int = 0
    var updateDataBase: ((_ synonyms:[String]) -> ())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = editButtonItem
        headLabel.text = "Synonyms for the word " + word + ":"
    }

    

    // UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return synonyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell")
        cell?.textLabel?.text = synonyms[indexPath.row]
        cell?.detailTextLabel?.text = ""
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.initAddAlert(title: "Add new synonym for " + self.word, message: "")
            success(true)
        })
        addAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.currentIndex = indexPath.row
            self.initDeleteAlert(synonym: self.synonyms[indexPath.row])
            success(true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    
    // UIAlertController methods
    private func initAddAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.synonyms.append(field.text!)
                self.updateDataBase?(self.synonyms)
                self.tableView.reloadData()
            } else {
                return
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func initDeleteAlert(synonym: String){
        let alert = UIAlertController(title: "Do you want to delete the synonym " + synonym + "?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.synonyms = self.synonyms.filter() { $0 != self.synonyms[self.currentIndex]}
            self.updateDataBase?(self.synonyms)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("action canceled")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        initAddAlert(title: "Add new synonym for " + self.word, message: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
