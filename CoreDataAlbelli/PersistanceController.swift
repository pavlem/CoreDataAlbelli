import UIKit
import CoreData


//fetchRequest.predicate = NSPredicate(format: "artId LIKE %@", "PAP_201_COVER")


enum PersistanceError: Error {
    case persistance(error: Error)
    case articleExists
    case articleDoesNotExists
    case noArticlesFound
//    case userDoesNotExist
//    case usersNotFetched
//    case userNotFound
//    case dbNotFound
//    case noUsersFound
}

enum PersistanceResult {
    case articlePersisted
    case articlesPersisted
    case articleUpdated
//    case userUpdated
//    case usersPersisted
//    case userDeleted
}


class PersistanceController {

    static var shared = PersistanceController()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ArticlesModel")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext(success: () -> Void, fail: (Error) -> Void) {
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

    static let articleEntityName = "ArticleEntity"

    // MARK: - API

        // MARK: Save Article
        // MARK: Update Article
        // MARK: Save Or Update Articles
        // MARK: Save Or Update Article
    // MARK: Fetch Articles
    // MARK: Fetch Article
    // MARK: Purge All Articles
    // MARK: Filter Article
    // MARK: Delete Article

    //================
    // MARK: Save Article
    func save(article: Article, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        let context = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: PersistanceController.articleEntityName, in: context)!

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
        fetchRequest.predicate = NSPredicate(format: "articleId LIKE %@", "\(article.id ?? "")")

        do {
            let results = try context.fetch(fetchRequest) as? [ArticleMO]

            guard results?.count == 0 else {
                cb(.failure(PersistanceError.articleExists))
                return
            }

            let newArticle = ArticleMO(entity: entity, insertInto: context)

            newArticle.articleDescription = article.description
            newArticle.articleId = article.id
            newArticle.articleType = article.articleType
            newArticle.defaultNumberOfPages = Int64(article.defaultNumberOfPages ?? 0)
            newArticle.extras = article.articleExtrasData
            newArticle.materials = article.articleMaterialsData
            newArticle.photoCoverSurplus = article.photoCoverSurplus ?? 0
            newArticle.previewImageUrl = article.previewImageUrl
            newArticle.price = article.price ?? 0
            newArticle.productTemplateUrl = article.productTemplateUrl
            newArticle.size = article.articleSizeData
            newArticle.sizeDescription = article.sizeDescription
            newArticle.spineCalculationType = article.spineCalculationType
            newArticle.thumbnailUrl = article.thumbnailUrl
            newArticle.title = article.title
            newArticle.vendorArticleId = article.vendorArticleId
            newArticle.visible = Int64(article.visible ?? 0)

        } catch {
            cb(.failure(PersistanceError.persistance(error: error)))
            return
        }

        saveContext {
            cb(.success(PersistanceResult.articlePersisted))
        } fail: { (error) in
            cb(.failure(PersistanceError.persistance(error: error)))
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

            guard results?.count != 0, let oldArticle = results?[0] else {
                cb(.failure(.articleDoesNotExists))
                return
            }

            oldArticle.articleDescription = article.description
            oldArticle.articleId = article.id
            oldArticle.articleType = article.articleType
            oldArticle.defaultNumberOfPages = Int64(article.defaultNumberOfPages ?? 0)
            oldArticle.extras = article.articleExtrasData
            oldArticle.materials = article.articleMaterialsData
            oldArticle.photoCoverSurplus = article.photoCoverSurplus ?? 0
            oldArticle.previewImageUrl = article.previewImageUrl
            oldArticle.price = article.price ?? 0
            oldArticle.productTemplateUrl = article.productTemplateUrl
            oldArticle.size = article.articleSizeData
            oldArticle.sizeDescription = article.sizeDescription
            oldArticle.spineCalculationType = article.spineCalculationType
            oldArticle.thumbnailUrl = article.thumbnailUrl
            oldArticle.title = article.title
            oldArticle.vendorArticleId = article.vendorArticleId
            oldArticle.visible = Int64(article.visible ?? 0)

        } catch {
            cb(.failure(PersistanceError.persistance(error: error)))
            return
        }

        saveContext {
            cb(.success(PersistanceResult.articleUpdated))
        } fail: { (error) in
            cb(.failure(PersistanceError.persistance(error: error)))
        }
    }

    // MARK: Save Or Update Articles
    func saverOrUpdate(articles: [Article], cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {

        for article in articles {
            saveOrUpdate(article: article) { (result) in
                switch result {
                case .failure(let err):
                    cb(.failure(err))
                    return
                case .success(_):
                    print("saverOrUpdate success")
                }
            }
        }

        cb(.success(PersistanceResult.articlesPersisted))
    }

    // MARK: Save Or Update Article
    func saveOrUpdate(article: Article, cb: ((Result<PersistanceResult, PersistanceError>) -> Void)) {
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







//    func fetchArticles(cb: ((Result<[Article], PersistanceError>) -> Void)) {
//
//        let context = persistentContainer.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceController.articleEntityName)
//        request.returnsObjectsAsFaults = false
//
//        do {
//            // NSManagedObject property approach
//
//            guard let resultsArticles = try context.fetch(request) as? [ArticleMO], resultsArticles.count > 0 else {
//                cb(.failure(.noArticlesFound))
//                return
//            }
//
//            var articles = [Article]()
//
//            for articleMO in resultsArticles {
//
//                let materials = try? JSONDecoder().decode([Material].self, from: articleMO.mat ?? Data())
//
//
//
//                let article = Article(id: <#T##String?#>, materials: <#T##[Material]?#>, description: <#T##String?#>, productTemplateUrl: <#T##String?#>, spineCalculationType: <#T##String?#>, previewImageUrl: <#T##String?#>, extras: <#T##Extras?#>, vendorArticleId: <#T##String?#>, photoCoverSurplus: <#T##Double?#>, thumbnailUrl: <#T##String?#>, title: <#T##String?#>, price: <#T##Double?#>, size: <#T##PageWidthAndHeight?#>, visible: <#T##Int?#>, articleType: <#T##String?#>, defaultNumberOfPages: <#T##Int?#>, sizeDescription: <#T##String?#>)
//
//
//
//
//
//                let pets = try? JSONDecoder().decode([Pet].self, from: userCD.pets ?? Data())
//
//                let userModel = UserModel(
//                    id: userCD.userId ?? "",
//                    username: userCD.username,
//                    password: userCD.password,
//                    age: userCD.age,
//                    pets: pets
//                )
//                print(userCD.username ?? "")
//                users.append(userModel)
//            }
//
//            cb(.success(users))
//
//            // KVO
//    //        let result = try context.fetch(request)
//    //        for data in result as! [NSManagedObject] {
//    //           print(data.value(forKey: "username") as! String)
//    //        }
//
//        } catch {
//            print("fetchUsers Failed: \(error)")
//            cb(.failure(PerError.persistance(error: error)))
//        }
//    }
//
//    func fetchUser(forId userId: String, cb: ((Result<UserModel, PerError>) -> Void)) {
//
//        let context = persistentContainer.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceHelper.userEntityName)
//        request.predicate = NSPredicate(format: "userId = %@", userId)
//        request.returnsObjectsAsFaults = false
//
//        do {
//            let result = try context.fetch(request)
//            guard result.count != 0 else { // At least one was returned
//                cb(.failure(PerError.userNotFound))
//                return
//            }
//
//            // NSManagedObject property approach
//            let userCD = result[0] as! UserCD
//            print(userCD.username ?? "")
//
//            let pets = try? JSONDecoder().decode([Pet].self, from: userCD.pets ?? Data())
//
//            let userModel = UserModel(
//                id: userCD.userId ?? "",
//                username: userCD.username,
//                password: userCD.password,
//                age: userCD.age,
//                pets: pets
//            )
//
//            cb(.success(userModel))
//
//            // KVO
//    //        for data in result as! [NSManagedObject] {
//    //           print(data.value(forKey: "username") as! String)
//    //        }
//        } catch {
//            cb(.failure(PerError.persistance(error: error)))
//        }
//    }
//
//    func dropDB(cb: @escaping ((Result<(), PerError>) -> Void)) {
//
//        let datamodelName = "CoreDataDemo"
//        let storeType = "sqlite"
//
//        let url: URL = {
//            let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("\(datamodelName).\(storeType)")
//
//            if FileManager.default.fileExists(atPath: url.path) == false {
//                cb(.failure(PerError.dbNotFound))
//            }
//            return url
//        }()
//
//        func loadStores() {
//            persistentContainer.loadPersistentStores(completionHandler: { (nsPersistentStoreDescription, error) in
//                if let error = error {
//                    cb(.failure(PerError.persistance(error: error)))
//                }
//            })
//        }
//
//        func deleteAndRebuild() {
//            try! persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: storeType, options: nil)
//
//            loadStores()
//        }
//
//        deleteAndRebuild()
//        cb(.success(()))
//    }
//
//    func filter(by userName: String, cb: ((Result<[UserModel], PerError>) -> Void)) {
//
//        let context = persistentContainer.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceHelper.userEntityName)
//        request.predicate = NSPredicate(format: "username contains %@", userName)
//        request.returnsObjectsAsFaults = false
//
//        do {
//            guard let result = try context.fetch(request) as? [UserCD], result.count != 0 else {
//                cb(.failure(.noUsersFound))
//                return
//            }
//
//            var usersLo = [UserModel]()
//
//            for userCD in result {
//
//                let pets = try? JSONDecoder().decode([Pet].self, from: userCD.pets ?? Data())
//
//                let userModel = UserModel(
//                    id: userCD.userId ?? "",
//                    username: userCD.username,
//                    password: userCD.password,
//                    age: userCD.age,
//                    pets: pets
//                )
//
//                usersLo.append(userModel)
//            }
//
//            cb(.success(usersLo))
//
//            // KVO
//    //        for data in result as! [NSManagedObject] {
//    //           print(data.value(forKey: "username") as! String)
//    //        }
//        } catch {
//            cb(.failure(PerError.persistance(error: error)))
//        }
//    }
//
//    func deleteUser(userId: String, cb: ((Result<PerResult, PerError>) -> Void)) {
//
//        let context = persistentContainer.viewContext
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistanceHelper.userEntityName)
//        request.predicate = NSPredicate(format: "userId = %@", userId)
//        request.returnsObjectsAsFaults = false
//
//        do {
//            let result = try context.fetch(request)
//
//            guard result.count != 0 else {
//                cb(.failure(.userDoesNotExist))
//                return
//            }
//
//            for object in result {
//                context.delete(object as! NSManagedObject)
//            }
//
//            // KVO
//    //        for data in result as! [NSManagedObject] {
//    //           print(data.value(forKey: "username") as! String)
//    //        }
//        } catch {
//            cb(.failure(PerError.persistance(error: error)))
//        }
//
//        saveContext {
//            cb(.success(.userDeleted))
//        } fail: { (error) in
//            cb(.failure(PerError.persistance(error: error)))
//        }
//    }
}
