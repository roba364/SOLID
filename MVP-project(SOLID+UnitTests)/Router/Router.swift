//
//  Router.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

// Навигация происходит из Presenter'a в Presenter, туда же переходят все данные, наши комменты, и все данные мы будем пересылать именно туда

// базовый протокол, который будет задавать всем остальным классам базовые требования
protocol RouterMain {
    // каждому роутеру нужно будет иметь свой navigationController
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

// создаем конкретный протокол для роутера
protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(comment: Comment?)
    func popToRoot()
}

// ВСЯ Навигация, которую мы делали бы по всем контролерам и искали в разных местах, всё это происходит в одном классе, в одной сущности navigationController, которую мы зададим извне

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    // делаем инъекцию зависимостей, чтобы всё это покрывать юнит-тестами
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    
    func initialViewController() {
        // задаем initial VC
        // проверяем navController
        if let navigationController = navigationController {
            // собираем main module
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            // берем navController и говорим что он будет первый в массиве VCs
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showDetail(comment: Comment?) {
        // задаем detail VC
        // проверяем navController
        if let navigationController = navigationController {
            // собираем detail module и передаем comment дальше
            guard let detailViewController = assemblyBuilder?.createDetailModule(comment: comment, router: self) else { return }
            // берем navController и пушим до detailVC
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    func popToRoot() {
        // проверяем navController
        if let navigationController = navigationController {
            // возвращаемся
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    
    
    
}
