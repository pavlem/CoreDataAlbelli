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

}
