import Foundation
import CoreData
import UIKit

extension AllNews {

class func createOrFetch(model:Results) -> AllNews? {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequset: NSFetchRequest<AllNews> = AllNews.fetchRequest()
    fetchRequset.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: false)]
    fetchRequset.predicate = NSPredicate.init(format: "id == %@", model.id?.description ?? "")
    
    var item:AllNews?
    
    if let fetchedItem = try? context.fetch(fetchRequset).first, fetchedItem != nil {
        item = fetchedItem
    }
    else {
        item = AllNews(context: context)
    }
    
    item?.id = model.id?.description
    item?.author = model.byline
    item?.body = model.abstract
    item?.title = model.title
    item?.url = model.url
    item?.publishedDate = model.publishedDate
    
    for media in model.media!{
    item?.newsMedia = AllMedia.createOrFetchMedia(model: media)
    }
    
    try? context.save()
    return item
}

class func createorFetch(models:[Results]) -> [AllNews]? {
    
    var array = [AllNews]()
    if models.count > 0 {
        for model in models {
            let object = AllNews.createOrFetch(model: model)
            array.append(object ?? AllNews())
        }
    }
    
    return array
}
    
    
}

extension AllMedia {
    
    class func createOrFetchMedia(model : Media) -> AllMedia? {
        
        var results : Results?
        var item : AllMedia?
        
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequset: NSFetchRequest<AllMedia> = AllMedia.fetchRequest()
        fetchRequset.sortDescriptors = [NSSortDescriptor.init(key: "newsId", ascending: false)]
        fetchRequset.predicate = NSPredicate.init(format: "newsId == %@", results?.id?.description ?? "")
        
        if let fetchedItem = try? context.fetch(fetchRequset).first , fetchedItem != nil {
            item = fetchedItem
        } else {
            item = AllMedia(context: context)
        }
        
        item?.newsId = results?.id!.description
        item?.caption = model.caption
        item?.type = model.type
        item?.copyRight = model.copyRight
        
        for metaData in model.mediaMetaData!{
            item?.mediaMetaData = AllMetaData.createOrFetchMetaData(model: metaData)
        }
        
        try? context.save()
        
        return item!
    }
    
    class func createorFetchMedia(models:[Media]) -> [AllMedia]? {
        
        var array = [AllMedia]()
        if models.count > 0 {
            for model in models {
                let object = AllMedia.createOrFetchMedia(model: model)
                array.append(object ?? AllMedia())
            }
        }
        
        return array
    }
    
    

}

extension AllMetaData {
    
    class func createOrFetchMetaData(model : MediaMetaData) -> AllMetaData? {
        
        var media : AllMedia?
        var item : AllMetaData?
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequset: NSFetchRequest<AllMetaData> = AllMetaData.fetchRequest()
        fetchRequset.sortDescriptors = [NSSortDescriptor.init(key: "newsId", ascending: false)]
        fetchRequset.predicate = NSPredicate.init(format: "newsId == %@", media?.newsId?.description ?? "")
        
        if let fetchedItem = try? context.fetch(fetchRequset).first , fetchedItem != nil {
            item = fetchedItem
        } else {
            item = AllMetaData(context: context)
        }
        
        item?.url = model.url
        item?.format = model.format
        item?.height = model.height?.description
        item?.width = model.width?.description
        item?.newsId = media?.newsId
        
        
        try? context.save()
        
        return item!
    }
    
    class func createorFetchMetaData(models:[MediaMetaData]) -> [AllMetaData]? {
        
        var array = [AllMetaData]()
        if models.count > 0 {
            for model in models {
                let object = AllMetaData.createOrFetchMetaData(model: model)
                array.append(object ?? AllMetaData())
            }
        }
        
        return array
    }
}
