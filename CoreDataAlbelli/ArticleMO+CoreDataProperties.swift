//
//  ArticleMO+CoreDataProperties.swift
//  CoreDataAlbelli
//
//  Created by Pavle Mijatovic on 09/12/2020.
//
//

import Foundation
import CoreData


extension ArticleMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleMO> {
        return NSFetchRequest<ArticleMO>(entityName: "ArticleEntity")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var articleId: String?
    @NSManaged public var articleType: String?
    @NSManaged public var defaultNumberOfPages: Int64
    @NSManaged public var extras: Data?
    @NSManaged public var materials: Data?
    @NSManaged public var photoCoverSurplus: Double
    @NSManaged public var previewImageUrl: String?
    @NSManaged public var price: Double
    @NSManaged public var productTemplateUrl: String?
    @NSManaged public var size: Data?
    @NSManaged public var sizeDescription: String?
    @NSManaged public var spineCalculationType: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var vendorArticleId: String?
    @NSManaged public var visible: Int64

}

extension ArticleMO : Identifiable {
    func populate(withArticle article: Article) {
        self.articleDescription = article.description
        self.articleId = article.id
        self.articleType = article.articleType
        self.defaultNumberOfPages = Int64(article.defaultNumberOfPages ?? 0)
        self.extras = article.articleExtrasData
        self.materials = article.articleMaterialsData
        self.photoCoverSurplus = article.photoCoverSurplus ?? 0
        self.previewImageUrl = article.previewImageUrl
        self.price = article.price ?? 0
        self.productTemplateUrl = article.productTemplateUrl
        self.size = article.articleSizeData
        self.sizeDescription = article.sizeDescription
        self.spineCalculationType = article.spineCalculationType
        self.thumbnailUrl = article.thumbnailUrl
        self.title = article.title
        self.vendorArticleId = article.vendorArticleId
        self.visible = Int64(article.visible ?? 0)
    }
}
