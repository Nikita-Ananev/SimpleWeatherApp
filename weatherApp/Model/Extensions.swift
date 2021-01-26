//
//  Extensions.swift
//  weatherApp
//
//  Created by Никита Ананьев on 26.01.2021.
//

import UIKit

extension UIButton {
    func addButtonPressedAnimation() {
        let button = self
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3 ) {
                button.transform = .identity
            }

        }
    }
}
extension UIView {
    func addCornerRadius(borderWidth: CGFloat, borderColor: CGColor, cornerRadius: CGFloat ) {
        let view = self
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
        view.layer.cornerRadius = cornerRadius
       
    }
}
