//
//  UIImage + Extensions.swift
//  PhotoJournal
//
//  Created by Matthew Ramos on 1/27/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
