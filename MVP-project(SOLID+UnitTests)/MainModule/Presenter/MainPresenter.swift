//
//  MainPresenter.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

// Презентер должен получить от View какие-то сообщения
// и отправлять этой View
// соответственно нужно 2 протокола (В Viper это Input, Output protocols)
// где-то это делегаты
// В Rx это биндинги
// у нас это будут протоколы, которые будут ходить туда-сюда

// ставим :class, чтобы сделать их слабыми, так как мы будем захватывать ссылки
protocol MainViewProtocol: class {
    // отправляем сообщение нашей View, чтобы она отреагировала на события
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: class {
    // реализуем инициализатор, который будет захватывать ссылку на View
    // делаем это через Протокол, чтобы соответствовать принципу Dependency Inversion, завязываясь не на классах, а на абстракции(протоколе)
    // Чтобы не нарушать Принцип Разделения Интерфейсов(Interface Segregation), мы делаем всё не в одном протоколе, а дробим интерфейсы
    
    // Еще такой инициализатор нужен для инъекции зависимостей(Dependency Injection)
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    // запрашиваем комменты из сети
    func getComments()
    
    // сюда будут сохраняться комменты, которые пришли из интернета
    var comments: [Comment]? { get set }
    // этот метод нужен чтобы передать его дальше по нажатию
    func tapOnComment(comment: Comment?)
}

class MainPresenter: MainViewPresenterProtocol {
    
    
    
    // Presenter ничего не знает о View по Dependency Inversion
    // мы завязываемся на абстракции
    // view у нас будет абсолютно любой класс, который подписан под протокол MainViewProtocol, чтобы создать "слабую" связь
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    let nerworkService: NetworkServiceProtocol
    var comments: [Comment]?

    // после того как мы проинджектировали зависимости, мы реализуем инициализатор
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        // в инициализаторе мы сэтим полученные данные через self
        self.view = view
        self.nerworkService = networkService
        self.router = router
        // вызывем getComments() когда извне сделаем инъекцию, сделаем пуш, вместе с инициализатором вызовется на метод
        getComments()
        print(self.comments?.count)
    }
    func tapOnComment(comment: Comment?) {
        router?.showDetail(comment: comment)
    }
    
    func getComments() {
        nerworkService.getComments { [weak self] result in
            print("get comments")
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self.comments = comments
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
            
        }
    }
}
