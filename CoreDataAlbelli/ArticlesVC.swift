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
        var articleOne = articles!.first!

        // MARK: Create Articles
//        PersistanceController.shared.create(articles: articles!) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }

        // MARK: Save Article
//        PersistanceController.shared.create(article: articleOne) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }

//        MARK: Update Article
//        articleOne.description = "Paja Patak"
//        PersistanceController.shared.update(article: articleOne) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }
//

        // MARK: Create Or Update Article
//        PersistanceController.shared.create(article: articleOne) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }


        // MARK: Fetch Articles
//        PersistanceController.shared.fetchArticles { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let articles):
//                print(articles)
//            }
//        }

        // MARK: Fetch Article
//        PersistanceController.shared.fetchArticle(forArticleId: "PAP_130_COVER") { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let article):
//                print(article)
//            }
//        }

        // MARK: Purge All Articles
//        PersistanceController.shared.purgeAllArticles { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }

        // MARK: Filter Article
//        PersistanceController.shared.filterArticle(byDescription: "Perfect ver") { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let articles):
//                print(articles)
//            }
//        }

        // MARK: Delete Article
//        PersistanceController.shared.deleteArticle(byArticleId: "PAP_130") { (result) in
//            switch result {
//            case .failure(let err):
//                print(err)
//            case .success(let status):
//                print(status)
//            }
//        }
    }
}
