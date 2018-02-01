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
    //var clickedWord:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        headLabel.text = "Synonyms for the word " + word + ":"
        initSynonyms()
    }
    
    private func initSynonyms(){
        for synonym in synonyms {
            print(synonym)
            //synonymTextView.text = synonymTextView.text + "\u{2022}" + synonym + "\n"
        }
    }

    
    private func initAddAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                print(field.text!)
                //UserDefaults.standard.set(field.text, forKey: "userEmail")
                //UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "..."
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return synonyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell")
        cell?.textLabel?.text = synonyms[indexPath.row]
        cell?.detailTextLabel?.text = "-"
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //clickedWord = synonyms[indexPath.row]
        //initAlert(title: "Warning", message: "Do you want to remove the word " + self.clickedWord + "?")
    }
    
    
    

    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Add action ...")
            print(self.synonyms[indexPath.row])
            self.initAddAlert(title: "Add new synonym to " + self.word, message: "")
            success(true)
        })
        addAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Delete action ...")
            print(self.synonyms[indexPath.row])
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
     
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
