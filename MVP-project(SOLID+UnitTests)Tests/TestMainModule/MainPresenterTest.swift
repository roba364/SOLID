//
//  MainPresenterTest.swift
//  MVP-project(SOLID+UnitTests)Tests
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import XCTest
@testable import MVP_project_SOLID_UnitTests_

// создаем Мок, чтобы протестировать Presenter и Model, понимая, отображается что-либо на View или нет
// Все удобно завязывать через протоколы, так как любая сущность которая будет конформить протокол, может быть использована и подставлена в разные места
class MockView: MainViewProtocol {
    
    func success() {
    }
    
    func failure(error: Error) {
    }
    

}

class MockNetworkService: NetworkServiceProtocol {
    var comments: [Comment]!
    
    init() {}
    
    convenience init(comments: [Comment]?) {
        self.init()
        self.comments = comments
    }
    func getComments(completion: @escaping (Result<[Comment]?, Error>) -> Void) {
        if let comments = comments {
            // когда мы будем дергать getComments() у MockNetworkService - он будет возвращать нам комменты и мы их там распарсим
            completion(.success(comments))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
    
}
 
class MainPresenterTest: XCTestCase {
    
    var view: MockView!
    var presenter: MainPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var comments = [Comment]()

    override func setUp() {
        let nav = UINavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: nav, assemblyBuilder: assemblyBuilder)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // метод срабатывает каждый раз, когда отрабатывает setUp()
        // нужно nil'ить наши объекты, чтобы не было проблем
        // каждый раз обнуляются объекты при запуске теста
        view = nil
        networkService = nil
        presenter = nil
    }
    
    func testGetSuccessComments() {
        let comment = Comment(postId: 1, id: 2, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockView()
        networkService = MockNetworkService(comments: comments)
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        var catchComments: [Comment]?
        
        networkService.getComments { (result) in
            switch result {
            case .success(let commets):
                catchComments = self.comments
            case .failure(let error):
                print(error)
            }
        }
        
        XCTAssertNotEqual(catchComments?.count, 0)
        XCTAssertEqual(catchComments?.count, comments.count)
    }
    
    func testGetFailureComments() {
        let comment = Comment(postId: 1, id: 2, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockView()
        networkService = MockNetworkService( )
        presenter = MainPresenter(view: view, networkService: networkService, router: router)
        
        var catchError: Error?
        
        networkService.getComments { (result) in
            switch result {
            case .success(let _):
                break
            case .failure(let error):
                catchError = error
            }
        }
        
        // проверяем наш еррор на != nil
        XCTAssertNotNil(catchError)
    }
}
