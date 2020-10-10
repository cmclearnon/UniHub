//
//  ViewController.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private var viewModel: UniversityViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = UniversityViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


}

