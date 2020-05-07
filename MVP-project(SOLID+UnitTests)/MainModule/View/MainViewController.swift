//
//  ViewController.swift
//  MVP-project(SOLID+UnitTests)
//
//  Created by SofiaBuslavskaya on 23/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // объявляем Presenter, для того, чтобы ему можно было сообщать о нажатиях, тапах на View
    // но мы обращаемся к Presenter не напрямую, а к протоколу
    // мы не создаем Presenter, а объявляем,так как мы будем передавать его извне, делаем инъекцию зависимостей снаружи(Dependency Injection)
    
    // так как мы исполняем Dependency Inversion из SOLID, мы не завязываемся на конкретном классе, мы будем использовать presenter, который конформит протокол MainViewPresenterProtocol, поэтому View все равно что тут будет
    // это и есть абстрактная связанность
    
    // MARK: - Properties
    
    var presenter: MainViewPresenterProtocol!
    var assemblyBuilder: AssemblyModuleBuilder!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getComments()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }


}

// пишем биндинг - связывание с View, обновление данных в этой View через что-то
// мы сэтим бизнес-логику во View, реализуя MainViewProtocol, сэтим сюда данные
// delegate
extension MainViewController: MainViewProtocol {
    
    func failure(error: Error) {
        // showAlert
        print(error.localizedDescription)
    }
    
    func success() {
        tableView.reloadData()
    }
   
}
 
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let comment = presenter.comments?[indexPath.row]
        
        cell.textLabel?.text = comment?.email
        
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let comment = presenter.comments?[indexPath.row]
        
        // говорим билдеру, у меня есть коммент, собери модуль, чтобы отобразить коммент
        
        presenter.tapOnComment(comment: comment)
    }
}
