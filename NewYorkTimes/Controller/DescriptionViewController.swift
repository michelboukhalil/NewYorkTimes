import UIKit
import Kingfisher

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var newsTitle : String?
    var image : String?
    var author : String?
    var date : String?
    var body : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = newsTitle
        authorLabel.text = author
        dateLabel.text = date
        bodyLabel.text = body
        imageView.kf.setImage(with: URL(string: image ?? ""))
        
        

        
    }
    
}
