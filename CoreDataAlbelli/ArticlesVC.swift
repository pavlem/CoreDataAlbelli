//
//  ArticlesVC.swift
//  CoreDataAlbelli
//
//  Created by Pavle Mijatovic on 09/12/2020.
//

import UIKit

class ArticlesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let stringPath = Bundle.main.path(forResource: "catalog", ofType: "json")
        let urlPath = URL(fileURLWithPath: stringPath!)
        let articlesData = try? Data(contentsOf: urlPath)
        let articles = try? JSONDecoder().decode([Article].self, from: articlesData!)
        print(articles)
        // Do any additional setup after loading the view.
    }
}
