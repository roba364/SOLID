//
//  RouterTest.swift
//  MVP-project(SOLID+UnitTests)Tests
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import XCTest
@testable import MVP_project_SOLID_UnitTests_

class MockNavigationController: UINavigationController {
    // берем контроллер, который уже запрезентили
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // присваиваем тот VC, который собираемся сейчас запушить(viewController)
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    // мы создаем router
    var router: RouterProtocol!
    // создаем navController замоканный, чтобы специально достучаться до контроллера, который запрезентится где-то там в роутере
    var navigationController = MockNavigationController()
    let assemblyBuiler = AssemblyModuleBuilder()
    
    override func setUp() {
        // отдаем роутеру навКонтроллер и ассембли, чтобы он где-то там внутри запушился
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuiler)
    }

    override func tearDown() {
        router = nil
    }
    
    func testRouter() {
        router.showDetail(comment: nil)
        let detailVC = navigationController.presentedVC
        
        // сравниваем, detailVC или нет вызвался
        XCTAssertTrue(detailVC is DetailViewProtocol)
    }

}
