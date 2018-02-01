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
    
    var currentDictionary:[DictionaryItem] = []
    var currentWord:String = ""
    var currentSynonyms:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        fetchData()
    }
    
    

    
    func fetchData(){
        let data:DataModel = DataModel()
        currentDictionary = data.fetchData()
    }
    
    
    //GetWords();
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            fetchData()
            self.tableView.reloadData()
            return
        }
        let filteredArray = currentDictionary.filter { DictionaryItem -> Bool in
                DictionaryItem.word.lowercased().contains(searchText.lowercased())
        }
        currentDictionary = filteredArray
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        cell?.textLabel?.text = currentDictionary[indexPath.row].word
        cell?.detailTextLabel?.text = ">"
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentWord = currentDictionary[indexPath.row].word
        currentSynonyms = currentDictionary[indexPath.row].synonyms
        performSegue(withIdentifier: "detailview", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title:  "Add", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Added")
            success(true)
        })
        //closeAction.image = UIImage(named: "tick")
        //closeAction.backgroundColor = .purple
        
        return UISwipeActionsConfiguration(actions: [addAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailview") {
            if let detailView = segue.destination as? DetailView {
                detailView.word = currentWord
                detailView.synonyms = currentSynonyms
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

