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
//        print(articles)
        // Do any additional setup after loading the view.

        let articlesLo = articles!

//        PersistanceController.shared.save(article: articleOne) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }

        PersistanceController.shared.saverOrUpdate(articles: articlesLo) { (result) in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let status):
                print(status)
            }
        }

        print("")
    }
}
