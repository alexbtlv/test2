//
//  ViewControllerHelper.swift
//  test2
//
//  Created by Alexander Batalov on 3/14/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withMessage message: String?, success: Bool = false ) {
        let alert = UIAlertController(title: success ? "Success" : "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
