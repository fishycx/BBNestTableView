//
//  BBNestBaseTableView.swift
//  BuzzyBee
//
//  Created by fishycx on 2020/8/20.
//  Copyright © 2020 zt. All rights reserved.
//

import UIKit


class BBNestContainerScrollView:UIScrollView, UIGestureRecognizerDelegate {
    
    var boundaryLocation = BBFloat(299) - NaviHeight //悬停位置
    
    fileprivate var innerViewContentOffsetY:CGFloat = 0
    
    var innerViews = [BBInnerScrollViewProtocol]() {
        didSet {
            handleInnerViewsCallBack()
        }
    }
                
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver(self, forKeyPath: "contentOffset", options:  [.new, .old], context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue
            let newOffsetY = newValue?.uiOffsetValue.vertical ?? 0
            if (newOffsetY > boundaryLocation) {
                contentOffset = CGPoint(x: 0, y: boundaryLocation)
                scrollsToTop = false
            } else if newOffsetY < 0 {
                contentOffset = CGPoint(x: 0, y: 0)
                scrollsToTop = true
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func handleInnerViewsCallBack() {
        for item in innerViews {
            weak var innerView = item
            item.scrollCallBack = { [weak self] (oldOffsetY, newOffsetY) in
                guard let s = self else { return }
                if newOffsetY > oldOffsetY {
                    //向上滑动
                    s.changeInnerView(innerView)
                } else if newOffsetY < oldOffsetY {
                    //向下滑动
                    if newOffsetY > 0 {
                        s.contentOffset = CGPoint(x: 0, y: s.boundaryLocation)
                    }
                    s.changeInnerView(innerView)
                }
                s.innerViewContentOffsetY = newOffsetY
            }
        }
    }
        
    fileprivate func changeInnerView(_ innerView: BBInnerScrollViewProtocol?) {
        let parentContentOffsetY = self.contentOffset.y
        if floor(parentContentOffsetY) > 0 && (floor(parentContentOffsetY) < floor(boundaryLocation)) {
            //修改子视图
            innerView?.fixed()
        } else {
            //父子视图跟随滑动
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is BBInnerTableView || otherGestureRecognizer.view is BBInnerCollectionView {
            return true
        }
        return false
     }
}


class BBNestBaseTableView: UITableView, UIGestureRecognizerDelegate {
    
    var boundaryLocation = BBFloat(299) - NaviHeight //悬停位置
    
    fileprivate var innerViewContentOffsetY:CGFloat = 0
    
    var innerViews = [BBInnerScrollViewProtocol]() {
        didSet {
            handleInnerViewsCallBack()
        }
    }
                
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addObserver(self, forKeyPath: "contentOffset", options:  [.new, .old], context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue
            let newOffsetY = newValue?.uiOffsetValue.vertical ?? 0
            if (newOffsetY > boundaryLocation) {
                contentOffset = CGPoint(x: 0, y: boundaryLocation)
                scrollsToTop = false
            } else if newOffsetY < 0 {
                contentOffset = CGPoint(x: 0, y: 0)
                scrollsToTop = true
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func handleInnerViewsCallBack() {
        for item in innerViews {
            weak var innerView = item
            item.scrollCallBack = { [weak self] (oldOffsetY, newOffsetY) in
                guard let s = self else { return }
                if newOffsetY > oldOffsetY {
                    //向上滑动
                    s.changeInnerView(innerView)
                } else if newOffsetY < oldOffsetY {
                    //向下滑动
                    if newOffsetY > 0 {
                        s.contentOffset = CGPoint(x: 0, y: s.boundaryLocation)
                    }
                    s.changeInnerView(innerView)
                }
                s.innerViewContentOffsetY = newOffsetY
            }
        }
    }
        
    fileprivate func changeInnerView(_ innerView: BBInnerScrollViewProtocol?) {
        let parentContentOffsetY = self.contentOffset.y
        if floor(parentContentOffsetY) > 0 && (floor(parentContentOffsetY) < floor(boundaryLocation)) {
            //修改子视图
            innerView?.fixed()
        } else {
            //父子视图跟随滑动
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is BBInnerTableView || otherGestureRecognizer.view is BBInnerCollectionView {
            return true
        }
        return false
     }
}

protocol BBInnerScrollViewProtocol:NSObjectProtocol {
    var scrollCallBack:((_ oldValue:CGFloat, _ newValue:CGFloat)->Void)? { get set }
    func fixed()->Void
}

class BBInnerTableView:UITableView, BBInnerScrollViewProtocol {
    
    var scrollCallBack:((_ oldValue:CGFloat, _ newValue:CGFloat)->Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeIObserver()
    }
    
    func addObserver() {
        addObserver(self, forKeyPath: "contentOffset", options:  [.new, .old], context: nil)
    }
    
    func removeIObserver() {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let oldValue = change?[NSKeyValueChangeKey.oldKey] as? NSValue
            let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue
            let oldOffsetY = oldValue?.uiOffsetValue.vertical ?? 0
            let newOffsetY = newValue?.uiOffsetValue.vertical ?? 0
            self.scrollCallBack?(oldOffsetY, newOffsetY)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func fixed() {
        self.contentOffset = CGPoint(x: 0, y: 0)
    }
}

class BBInnerCollectionView:UICollectionView, BBInnerScrollViewProtocol {
    var scrollCallBack: ((CGFloat, CGFloat) -> Void)?
    
    fileprivate var parentContentOffsetY:CGFloat = 0
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let oldValue = change?[NSKeyValueChangeKey.oldKey] as? NSValue
            let newValue = change?[NSKeyValueChangeKey.newKey] as? NSValue
            let oldOffsetY = oldValue?.uiOffsetValue.vertical ?? 0
            let newOffsetY = newValue?.uiOffsetValue.vertical ?? 0
            self.scrollCallBack?(oldOffsetY, newOffsetY)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func fixed() {
        self.contentOffset = CGPoint(x: 0, y: 0)
    }
}
