//
//  DetailViewController.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var commentLabel: UILabel!
    
    //MARK: - Properties
    
    var presenter: DetailViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setComment()
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        presenter.tap()
    }
    
}

extension DetailViewController: DetailViewProtocol {
    func setComment(comment: Comment?) {
        self.commentLabel.text = comment?.email
    }
    
    
}
