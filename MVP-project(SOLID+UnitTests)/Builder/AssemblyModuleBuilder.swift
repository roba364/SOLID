//
//  ModuleBuilder.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    // сетим роутер в assembly, чтобы ими можно было пользоваться
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // builder
    // Внедрение зависимостей снаружи
    // когда мы вызываем функцию, она проставляет все зависимости и возвращаем уже проинджекшенный UIViewController, который мы можем презентить юзеру
    func createMainModule(router: RouterProtocol) -> UIViewController {
        
        let view = MainViewController()
        let networkService = NetworkService()
        // Presenter'у мы заранее инджектим view и model
        // мы делаем это снаружи, следуя принципам SOLID
        // Для того, чтобы потом можно было подсунуть туда же Mock-object(fake)
        // Mock - чтобы протестировать наш Presenter, нашу бизнес-логику
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        // отдаем нашей view(созданной на 23ей строчке) наш созданный, заинъекченный презентер
        // так как presenter мы объявили во View(MainViewController), но не инициализировали внутри, мы делаем инъекцию зависимостей извне
        
        view.presenter = presenter
        
        return view
        
    }
    
    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
            let networkService = NetworkService()
        
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, comment: comment)

            view.presenter = presenter
            
            return view
    }
}
