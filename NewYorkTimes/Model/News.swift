import Foundation

struct News : Codable {
    
    var status : String?
    var copyRight : String?
    var numResults : Int?
    var results : [Results]?
    
    private enum CodingKeys: String, CodingKey {
        case status, results
        case copyRight = "copyright"
        case numResults = "num_results"
    }
}

struct Results : Codable {
    var url : String?
    var adxKeywords : String?
    var column : String?
    var section : String?
    var byline : String?
    var type : String?
    var title : String?
    var abstract : String?
    var publishedDate : String?
    var source : String?
    var id : Int? 
    var test : [String]?
    var assetId : Int?
    var views : Int?
    var media : [Media]?
    
    private enum CodingKeys : String, CodingKey {
        case url, column , section , byline , type , title , abstract , source , id , views , media
        case adxKeywords = "adx_keywords"
        case publishedDate = "published_date"
        case assetId = "asset_id"
    }
    
    
}

struct Media : Codable {
    
    var type : String?
    var subType : String?
    var caption : String?
    var copyRight : String?
    var approvedForSyndication : Int?
    var mediaMetaData : [MediaMetaData]?
    
    private enum CodingKeys: String, CodingKey {
        case type, caption
        case subType = "subtype"
        case copyRight = "copyright"
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetaData = "media-metadata"
    }
    
    
}

struct MediaMetaData : Codable {
    
    var url : String?
    var format : String?
    var height : Int?
    var width : Int?
    
}


