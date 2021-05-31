//
//  Extensions.swift
//  Movien
//
//  Created by Асыланбек Нурмухамбет on 4/29/21.
//  Copyright © 2021 kbtu.edu.as1k.kz. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.7
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
    }
}

extension String {
    
    func convertDateString() -> String? {
        return convert(dateString: self, fromDateFormat: "yyyy-MM-dd", toDateFormat: "MMM d, yyyy")
    }

    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> String? {
        
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat
        
        if let fromDateObject = fromDateFormatter.date(from: dateString) {
            
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat
            
            let newDateString = toDateFormatter.string(from: fromDateObject)
            return newDateString
        }
        return nil
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func connectionAlert() {
        let alert = UIAlertController(title: "Uh Oh", message: "You have no network connection. Please try connecting again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
