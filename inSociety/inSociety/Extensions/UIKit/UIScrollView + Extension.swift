//
//  UIScrollView + Extension.swift
//  inSociety
//
//  Created by Aleksey Libin on 01.11.2022.
//

import UIKit

extension UIScrollView {
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
