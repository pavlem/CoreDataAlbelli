// Class for encoding to JSON file meant for the JS which sets UI on the "Home" and "My projects" tab.

import Foundation

// MARK: - Article
struct Article: Codable {
    let id: String?
    let materials: [Material]?
    var description: String?
    let productTemplateUrl: String?
    let spineCalculationType: String?
    let previewImageUrl: String?
    let extras: Extras?
    let vendorArticleId: String?
    let photoCoverSurplus: Double?
    let thumbnailUrl: String?
    let title: String?
    let price: Double?
    let size: PageWidthAndHeight?
    let visible: Int?
    let articleType: String?
    let defaultNumberOfPages: Int?
    let sizeDescription: String?
}

extension Article {
    var articleExtrasData: Data? {
        return try? JSONEncoder().encode(self.extras)
    }

    var articleMaterialsData: Data? {
        return try? JSONEncoder().encode(self.materials)
    }

    var articleSizeData: Data? {
        return try? JSONEncoder().encode(self.size)
    }
}


extension Article {
    init (articleMO: ArticleMO) {

        self.id = articleMO.articleId
        self.materials = Article.getMaterials(from: articleMO.materials)
        self.description = articleMO.articleDescription
        self.productTemplateUrl = articleMO.productTemplateUrl
        self.spineCalculationType = articleMO.spineCalculationType
        self.previewImageUrl = articleMO.previewImageUrl
        self.extras = Article.getExtras(from: articleMO.extras)
        self.vendorArticleId = articleMO.vendorArticleId
        self.photoCoverSurplus = articleMO.photoCoverSurplus
        self.thumbnailUrl = articleMO.thumbnailUrl
        self.title = articleMO.title
        self.price = articleMO.price
        self.size = Article.getsize(from: articleMO.size)
        self.visible = Int(articleMO.visible)
        self.articleType = articleMO.articleType
        self.defaultNumberOfPages = Int(articleMO.defaultNumberOfPages)
        self.sizeDescription = articleMO.sizeDescription
    }

    static func getMaterials(from materialsData: Data?) -> [Material]? {
        guard let materialsData = materialsData else { return nil }

        let materials = try? JSONDecoder().decode([Material].self, from: (materialsData))
        return materials
    }

    static func getExtras(from extrasData: Data?) -> Extras? {
        guard let extrasData = extrasData else { return nil }

        let extras = try? JSONDecoder().decode(Extras.self, from: (extrasData))
        return extras
    }

    static func getsize(from pageSizeData: Data?) -> PageWidthAndHeight? {
        guard let pageSizeData = pageSizeData else { return nil }
        let pageSize = try? JSONDecoder().decode(PageWidthAndHeight.self, from: (pageSizeData))
        return pageSize
    }
}


// MARK: - Extras
struct Extras: Codable {
    let extraPages: ExtraPages?
    let premiumLayFlat: PremiumLayFlat?
    let paperStyles: PaperStyles?
    let printSize: PrintSize?
}

// MARK: - ExtraPages
struct ExtraPages: Codable {
    let id: String?
    let extraPagePrice: Double?
    let maxExtraPages, pageIncrement: Int?
}

// MARK: - PaperStyles
struct PaperStyles: Codable {
    let glossy, matte: PaperStylesInfo?
}

// MARK: PaperStylesInfo
struct PaperStylesInfo: Codable {
    let id: String?
    let title: String?
    let price: Double?
}

// MARK: - PremiumLayFlat
struct PremiumLayFlat: Codable {
    let id: String?
    let basePrice: Double?
    let extraPagePrice: Double?
}

// MARK: - PrintSize
struct PrintSize: Codable {
    let id: String?
    let sizes: [PrintSizeElement]?
}

// MARK: SizeElement
struct PrintSizeElement: Codable {
    var size: PrintSizeWidthAndHeight?
    let id: String?
    let title: String?
    let price: Double?
    let sizeDescription: String?
}

// MARK: PrintSizeWidthAndHeight
struct PrintSizeWidthAndHeight: Codable {
    let width: Double?
    let height: Double?
}

// MARK: PageWidthAndHeight
struct PageWidthAndHeight: Codable {
    let width: Double?
    let height: Double?
}

// MARK: MaterialJS
struct Material: Codable {
    let id: String?
    let quantity: Int?
}
