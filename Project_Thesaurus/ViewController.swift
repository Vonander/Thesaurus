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
    var currentIndex:Int = 0
    var searching:Bool = false
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
    
    override func viewDidDisappear(_ animated: Bool) {
        currentDictionary = unfilteredDictionary
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.endEditing(true)
        searchBar.text = ""
    }
    
    private func initNavigationBar(){
        editButtonItem.setTitleTextAttributes(textAttributes, for: .normal)
        editButtonItem.title = "+"
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    
    //GetWords()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        guard !searchText.isEmpty else {
            searching = false
            self.currentDictionary = self.unfilteredDictionary
            self.tableView.reloadData()
            return
        }
        let filteredDictionary = currentDictionary.filter { DictionaryItem -> Bool in
                DictionaryItem.word.lowercased().contains(searchText.lowercased())
        }
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
        currentIndex = indexPath.row
        performSegue(withIdentifier: "detailview", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(searching){
            let emptyAction = UISwipeActionsConfiguration()
            return emptyAction
        }
        let addAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.currentIndex = indexPath.row
            self.initAddAlert(title: "Add a new word to the dictionary", message: "")
            success(true)
        })
        addAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(searching){
            let emptyAction = UISwipeActionsConfiguration()
            return emptyAction
        }
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.currentIndex = indexPath.row
            self.initDeleteAlert(word: self.currentDictionary[indexPath.row].word, id: self.currentDictionary[indexPath.row].id)
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
                let uuid = NSUUID().uuidString.lowercased()
                let item:DictionaryItem = DictionaryItem(word: field.text!, id: uuid, synonyms: ["< add - delete >"])
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
    
    private func initDeleteAlert(word: String, id: String){
        let alert = UIAlertController(title: "Do you want to delete the word " + word + "?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.removeItem(id: id)
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
                detailView.dictionaryItem = self.currentDictionary[currentIndex]
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
    
    func removeItem(id: String){
        if let index = currentDictionary.enumerated().filter( { $0.element.id == id }).map({ $0.offset }).first {
            currentDictionary.remove(at: index)
        }
        unfilteredDictionary = currentDictionary
        tableView.reloadData()
    }
    
    func updateDataBase(_ dictionaryItem:DictionaryItem) -> () {
        if let index = currentDictionary.enumerated().filter( { $0.element.id == dictionaryItem.id }).map({ $0.offset }).first {
            currentDictionary[index] = dictionaryItem
            unfilteredDictionary = currentDictionary
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
