//
//  DetailPresenter.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

// Input protocol
protocol DetailViewProtocol: class {
    //сетим коммент в нашу View
    func setComment(comment: Comment?)
}

// Output protocol
protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol,
         comment: Comment?)
    func setComment()
    func tap()
}

class DetailPresenter: DetailViewPresenterProtocol {
    
    
    
    weak var view: DetailViewProtocol?
    let nerworkService: NetworkServiceProtocol
    var comment: Comment?
    var router: RouterProtocol?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, comment: Comment?) {
        self.view = view
        self.nerworkService = networkService
        self.router = router
        self.comment = comment
    }
    
    func tap() {
        router?.popToRoot()
    }
    
    public func setComment() {
        self.view?.setComment(comment: comment!)
    }
}

