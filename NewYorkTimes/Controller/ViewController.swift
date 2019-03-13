import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import CoreData

class ViewController: UIViewController , NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var newsTableView: UITableView!
    let baseUrl = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/"
    let apiKey = ["api-key" : "Rk6GfVjL9XA3A5ipo7bjr2fNh80CpeA5"]
    
    private let refreshControl = UIRefreshControl()
    
    enum days : String {
        case one = "1"
        case week = "7"
        case month = "30"
    }
    
    enum sections : String {
        case allSections = "all-sections"
        case sports
    }   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        
        
        
        try? fetchedResultsController.performFetch()
        
        self.loading.startAnimating()
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
        
        
        getNews(days: days.month.rawValue, section: sections.allSections.rawValue)
        
    }
    
    @objc private func refreshGetNews(_ sender : Any){
        getNews(days: days.month.rawValue, section: sections.sports.rawValue)
    }
    
    
    
    func getNews (days: String , section : String){

        let url = baseUrl + "\(section)/\(days).json" + "?api-key=Rk6GfVjL9XA3A5ipo7bjr2fNh80CpeA5"
        
        Alamofire.request(url,
                          parameters : nil )
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
                }
                
                guard let data = response.data, let result = try? JSONDecoder().decode(News.self, from: data) else {
                    return
                }
               
                let _ = AllNews.createorFetch(models: result.results ?? [])
                
                
                DispatchQueue.main.async(execute: {
                    self.newsTableView.reloadData()
                })
                
                self.refreshControl.endRefreshing()
                self.loading.stopAnimating()
                
        }
        
        
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<AllNews> = {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<AllNews> = AllNews.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedDate", ascending: false)]

        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
}
extension ViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshGetNews(_ :)), for: .valueChanged)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        
        if let news = self.fetchedResultsController.fetchedObjects?[indexPath.row] {
            
            cell.newsBody?.text = news.body
            cell.newsTitle?.text = news.title
            cell.newsImage.kf.setImage(with: URL(string: (news.newsMedia?.mediaMetaData?.url) ?? "" ) )

        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDescription", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DescriptionViewController
        if let indexPath = newsTableView.indexPathForSelectedRow{
            if let news = self.fetchedResultsController.fetchedObjects?[indexPath.row] {
                destinationVC.author = news.author ?? ""
            }
            //destinationVC.author = allNewsArrays?[indexPath.row].author
            //destinationVC.title = allNewsArrays?[indexPath.row].title
            //destinationVC.body = allNewsArrays?[indexPath.row].body
            //destinationVC.date = allNewsArrays?[indexPath.row].publishedDate
            //destinationVC.image = allNewsArrays?[indexPath.row].newsMedia?.mediaMetaData?.url
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsTableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        newsTableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                newsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                newsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                newsTableView.reloadRows(at: [indexPath], with: .none)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                newsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                newsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}

class Cell : UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsBody: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
}

