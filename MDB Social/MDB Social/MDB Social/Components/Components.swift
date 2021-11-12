//
//  Components.swift
//  MDB Social
//
//  Created by Oleg Bezrukavnikov on 11/11/21.
//

import UIKit

class PaddedImageView: UIImageView {
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
