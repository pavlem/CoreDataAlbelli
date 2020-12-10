import UIKit
import CoreData

enum PersistanceError: Error {
    case persistance(error: Error)
    case articleAlreadyExists
    case articleDoesNotExist
    case articlesDoNotExist
    case dbNotFound
    case noFilteringMatches
}

enum PersistanceResult {
    case created
    case updated
    case deleted
}

class PersistanceController {

    // MARK: - API
    static var shared = PersistanceController()

    // MARK: Save Article
    func save(article: Article, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: PersistanceController.articleEntityName, in: context)!

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
        fetchRequest.predicate = NSPredicate(format: "articleId LIKE %@", "\(article.id ?? "")")

        do {
            let results = try context.fetch(fetchRequest) as? [ArticleMO]

            guard results?.count == 0 else {
                cb(.failure(PersistanceError.articleAlreadyExists))
                return
            }

            let newArticleMO = ArticleMO(entity: entity, insertInto: context)
            newArticleMO.populate(withArticle: article)

        } catch {
            cb(.failure(.persistance(error: error)))
            return
        }

        saveContext {
            cb(.success(.created))
        } fail: { (error) in
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: Update Article
    func update(article: Article, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: PersistanceController.articleEntityName, in: context)!

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
        fetchRequest.predicate = NSPredicate(format: "articleId LIKE %@", "\(article.id ?? "")")

        do {
            let results = try context.fetch(fetchRequest) as? [ArticleMO]

            guard results?.count != 0, let oldArticleMO = results?[0] else {
                cb(.failure(.articleDoesNotExist))
                return
            }

            oldArticleMO.populate(withArticle: article)

        } catch {
            cb(.failure(.persistance(error: error)))
            return
        }

        saveContext {
            cb(.success(.updated))
        } fail: { (error) in
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: Create Articles
    func create(articles: [Article], cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        for article in articles {
            createOrUpdate(article: article) { (result) in
                switch result {
                case .failure(let err):
                    cb(.failure(err))
                    return
                case .success(_):
                    print("saverOrUpdate success")
                }
            }
        }

        cb(.success(.created))
    }

    // MARK: Create Or Update Article
    func createOrUpdate(article: Article, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: PersistanceController.articleEntityName, in: context)!

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)

        let articleId = article.id!
        fetchRequest.predicate = NSPredicate(format: "articleId LIKE %@", "\(articleId)")

        do {
            let results = try context.fetch(fetchRequest) as? [ArticleMO]

            guard results?.count != 0 else {

                save(article: article) { (result) in
                    cb(result)
                }
                return
            }

            update(article: article) { (result) in
                cb(result)
            }

        } catch {
            cb(.failure(PersistanceError.persistance(error: error)))
        }
    }

    func fetchArticles(cb: ((Result<[Article], PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceController.articleEntityName)
        request.returnsObjectsAsFaults = false

        do {
            guard let resultsArticles = try context.fetch(request) as? [ArticleMO], resultsArticles.count > 0 else {
                cb(.failure(.articlesDoNotExist))
                return
            }

            let articles = resultsArticles.map { Article(articleMO: $0) }
            cb(.success(articles))
        } catch {
            print("fetchUsers Failed: \(error)")
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: Fetch Article
    func fetchArticle(forArticleId articleId: String, cb: ((Result<Article, PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceController.articleEntityName)
        request.predicate = NSPredicate(format: "articleId LIKE %@", "\(articleId)")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            guard result.count != 0, let articleMO = result[0] as? ArticleMO else { // At least one was returned
                cb(.failure(.articleDoesNotExist))
                return
            }

            let article = Article(articleMO: articleMO)
            cb(.success(article))

        } catch {
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: Purge All Articles
    func purgeAllArticles(cb: @escaping ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        let datamodelName = "ArticlesModel"
        let storeType = "sqlite"

        let url: URL = {
            let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("\(datamodelName).\(storeType)")

            if FileManager.default.fileExists(atPath: url.path) == false {
                cb(.failure(.dbNotFound))
            }
            return url
        }()

        func loadStores() {
            persistentContainer.loadPersistentStores(completionHandler: { (nsPersistentStoreDescription, error) in
                if let error = error {
                    cb(.failure(.persistance(error: error)))
                }
            })
        }

        func deleteAndRebuild() {
            try! persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeType, options: nil)

            loadStores()
        }

        deleteAndRebuild()
        cb(.success(.deleted))
    }

    // MARK: Filter Article
    func filterArticle(byDescription description: String, cb: ((Result<[Article], PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceController.articleEntityName)

        request.predicate = NSPredicate(format: "articleDescription contains %@", description)
        request.returnsObjectsAsFaults = false

        do {
            guard let result = try context.fetch(request) as? [ArticleMO], result.count != 0 else {
                cb(.failure(.noFilteringMatches))
                return
            }

            let articles = result.map { Article(articleMO: $0) }
            cb(.success(articles))

        } catch {
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: Delete Article
    func deleteArticle(byArticleId articleId: String, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceController.articleEntityName)
        request.predicate = NSPredicate(format: "articleId LIKE %@", "\(articleId)")

        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)

            guard result.count != 0 else {
                cb(.failure(.articleDoesNotExist))
                return
            }

            for object in result {
                context.delete(object as! NSManagedObject)
            }

        } catch {
            cb(.failure(.persistance(error: error)))
        }

        saveContext {
            cb(.success(.deleted))
        } fail: { (error) in
            cb(.failure(.persistance(error: error)))
        }
    }

    // MARK: - Properties
    // MARK: Core Data stack
    private static let articleEntityName = "ArticleEntity"
    private let modelName = "ArticlesModel"

    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    private func saveContext(success: () -> Void, fail: (Error) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                success()
            } catch {
                fail(error)
            }
        }
    }
}
