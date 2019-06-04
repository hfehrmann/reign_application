//
//  PullDownToRefresh.swift
//  Reign
//
//  Created by Hans Fehrmann on 6/4/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

class PullDownToRefreshMessage: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Pull down to refresh"
        label.textColor = .lightGray
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: label.bounds.height)
        addSubview(label)
        label.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin, .flexibleTopMargin]
    }
}
