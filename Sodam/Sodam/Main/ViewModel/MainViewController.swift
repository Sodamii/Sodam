//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
