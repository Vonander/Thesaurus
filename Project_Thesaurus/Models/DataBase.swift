//
//  DataBase.swift
//  Project_Thesaurus
//
//  Created by Johan Fornander on 2018-01-30.
//  Copyright © 2018 Johan Fornander. All rights reserved.
//

import Foundation

struct DictionaryItem {
    var word: String
    var synonyms: [String]
}

class DataModel {
    
    var database = [
        [
            "word": "sten",
            "synonyms": [
                "berg","bergmaterial","grus","klippa","block","bumling","ädelsten","juvel","kärna"
            ]
        ],
        [
            "word": "sax",
            "synonyms": [
                "klippverktyg","skräddarsax","kökssax","nagelsax","sekatör","trädgårdssax"
            ]
        ],
        [
            "word": "påse",
            "synonyms": [
                "kasse","liten säck","säck","väska"
            ]
        ]
    ]
    
    func fetchData() -> [DictionaryItem]{
        var dictionaryItems:[DictionaryItem] = []
        for word in database {
            let item:DictionaryItem = DictionaryItem(word: word["word"] as! String, synonyms: word["synonyms"] as! [String])
            dictionaryItems.append(item)
        }
        return dictionaryItems
    }
    
}
