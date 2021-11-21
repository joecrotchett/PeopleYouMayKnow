//
//  UITableView+Dequeue.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

// MARK: UITableView Extension

extension UITableView {
    
    /**
    This helper allows us to write cleaner dequeuing calls by taking advantage of Swift
    Generics, and our `reuseIdentifier` class properties in UITableViewCell, to cut out common
    code, and eliminate the optional returned by `dequeueReusableCell(withIdentifier:for:)`.
    ### The old way:
      `guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier(), for: indexPath) as? PersonCell else { return UITableViewCell() }`
    ### The new way:
      `let cell: PersonCell = tableView.dequeue(for: indexPath)`
    */
    func dequeueReusableCell<T : UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

// MARK: UITableViewCell Extension

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell : ReusableView { }

