//
//  ViewController.swift
//  Project_Thesaurus
//
//  Created by Johan Fornander on 2018-01-30.
//  Copyright © 2018 Johan Fornander. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let data:DataModel = DataModel()
    var unfilteredDictionary:[DictionaryItem] = []
    var currentDictionary:[DictionaryItem] = []
    var currentWord:String = ""
    var currentSynonyms:[String] = []
    var currentIndex:Int = 0
    let textAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.thin),NSAttributedStringKey.foregroundColor:UIColor(red:0.00, green:0.10, blue:0.57, alpha:1.0)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        currentDictionary = data.fetchData()
        unfilteredDictionary = data.fetchData()
        initNavigationBar()
    }
    
    private func initNavigationBar(){
        editButtonItem.setTitleTextAttributes(textAttributes, for: .normal)
        editButtonItem.title = "+"
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
    //GetWords()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.currentDictionary = self.unfilteredDictionary
            self.tableView.reloadData()
            return
        }
        let filteredDictionary = currentDictionary.filter { DictionaryItem -> Bool in
                DictionaryItem.word.lowercased().contains(searchText.lowercased())
        }
        //unfilteredDictionary = currentDictionary
        currentDictionary = filteredDictionary
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
    
    // UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        cell?.textLabel?.textColor = UIColor(red:0.00, green:0.10, blue:0.57, alpha:1.0)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.thin)
        cell?.textLabel?.text = currentDictionary[indexPath.row].word
        cell?.detailTextLabel?.text = ""
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentWord = currentDictionary[indexPath.row].word
        currentSynonyms = currentDictionary[indexPath.row].synonyms
        currentIndex = indexPath.row
        performSegue(withIdentifier: "detailview", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.currentWord = self.currentDictionary[indexPath.row].word
            self.currentIndex = indexPath.row
            self.initAddAlert(title: "Add a new word to the dictionary", message: "")
            success(true)
        })
        addAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.currentWord = self.currentDictionary[indexPath.row].word
            self.currentIndex = indexPath.row
            self.initDeleteAlert(word: self.currentDictionary[indexPath.row].word)
            success(true)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    
    // UIAlertController methods
     //AddSynonyms()
    private func initAddAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                let item:DictionaryItem = DictionaryItem(word: field.text!, synonyms: ["< add - delete >"])
                self.currentDictionary.append(item)
                self.unfilteredDictionary = self.currentDictionary
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
    
    private func initDeleteAlert(word: String){
        let alert = UIAlertController(title: "Do you want to delete the word " + word + "?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.currentDictionary.remove(at: self.currentIndex)
            self.unfilteredDictionary = self.currentDictionary
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("action canceled")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //GetSynonyms()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailview") {
            if let detailView = segue.destination as? DetailView {
                detailView.word = currentWord
                detailView.synonyms = currentSynonyms
                detailView.textAttributes = textAttributes
                detailView.updateDataBase = updateDataBase(_:)
                let backItem = UIBarButtonItem()
                backItem.title = "back"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        initAddAlert(title: "Add a new word to the dictionary", message: "")
    }
    
    func updateDataBase(_ synonyms:[String]) -> () {
        currentDictionary[currentIndex].synonyms = synonyms
        unfilteredDictionary = currentDictionary
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
