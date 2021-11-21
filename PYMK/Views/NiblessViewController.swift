//
//  NiblessViewController.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

// Reader note: When building views and view controllers programmatically, I like use a
// view controller subclass such as this to 1) express intent, 2) cleanup
// the intializers used in IB-abuilt view controllers, and 3) enforce programmatic constraints
class NiblessViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // Enforce programmatically built view controllers intializers only
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: UIKit.Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported")
    }
}
