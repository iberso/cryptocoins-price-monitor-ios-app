//
//  CustomTableViewCell.swift
//  UAS_c14190189
//
//  Created by Adakah? on 05/12/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelViewNomor: UILabel!
    @IBOutlet weak var labelViewPrice: UILabel!
    @IBOutlet weak var labelViewName: UILabel!
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //fungsi load image dari url
    func loadImage(from url : URL){
        let task = URLSession.shared.dataTask(with: url){(data,response,error) in
            guard let data = data,
                let newImage = UIImage(data: data)
                else {
                    print("image cannot load")
                    return
                }
                    DispatchQueue.main.async {
                        self.imageViewLogo.image = newImage
                    }
                }
           task.resume()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
