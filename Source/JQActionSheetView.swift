//
//  JQActionSheetView.swift
//
//
//  Created by HJQ on 2017/6/23.
//  Copyright © 2017年 HJQ. All rights reserved.
//

import UIKit

public struct JQSelectViewInfo {
    
    fileprivate var title: String
    fileprivate var color: UIColor
    fileprivate var font: UIFont
    fileprivate var isTitle: Bool
    
    
    public init(title: String, color: UIColor? = UIColor.black,font: UIFont? = UIFont.systemFont(ofSize: 14), isTitle: Bool? = false) {
        self.title = title
        self.color = color!
        self.font = font!
        self.isTitle = isTitle!
    }
}

fileprivate struct Action {
    static let tapBgViewOrCancel = #selector(JQActionSheetView.tapBgViewOrCancel)
}

public class JQActionSheetView: UIView {
    
    fileprivate var cancelTitle: JQSelectViewInfo?
    fileprivate var options: [JQSelectViewInfo] = [JQSelectViewInfo]()
    fileprivate var pView: UIView!
    fileprivate var footerView: UIView = UIView.init()
    fileprivate var selectCallBack: ((_ index: Int) -> Swift.Void)?
    
    @discardableResult
    convenience public init(view: UIView? = UIApplication.shared.windows.last, options: [JQSelectViewInfo], cancelTitle: JQSelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?) {
        self.init(frame: view!.bounds)
        view?.addSubview(self)
        self.options = options
        self.cancelTitle = cancelTitle
        self.selectCallBack = selectCallBack
        self.pView = view!
        commitInit()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        coverView.frame = frame
        let height: Double = Double(self.options.count  * 40 + 45)
        optionTableView.frame = CGRect.init(x: 0, y: Double(bounds.size.height) - height, width: Double(bounds.size.width), height: height)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - private methods
    private func setupUI() {
        addSubview(coverView)
        addSubview(optionTableView)
        setupTableViewFooterView()
        showSelectView()
        
    }
    
    fileprivate func setupTableViewFooterView() {
        
        let footerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.size.width, height: 45.0))
        footerView.backgroundColor = UIColor.init(red: 243/255.0, green: 244/255.0, blue: 245/255.0, alpha: 1.0)
        
        let cancelButton: UIButton = UIButton.init(type: .custom)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitle(self.cancelTitle?.title, for: .normal)
        cancelButton.setTitleColor(self.cancelTitle?.color, for: .normal)
        cancelButton.titleLabel?.font = self.cancelTitle?.font
        cancelButton.frame = CGRect.init(x: 0, y: 5, width: bounds.size.width, height: 40)
        cancelButton.addTarget(self, action: Action.tapBgViewOrCancel, for: .touchUpInside)
        footerView.addSubview(cancelButton)
        optionTableView.tableFooterView = footerView
    }
    
    private func commitInit() {
        
        registerNotificationCenter()
    }
    
    private func registerNotificationCenter() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(statusBarOrientationDidChange(notification:)) , name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    // MARK: - lazy load
    fileprivate lazy var coverView: UIView = {
        let view: UIView = UIView.init()
        view.frame = self.frame
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: Action.tapBgViewOrCancel)
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var optionTableView: UITableView = {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.groupTableViewBackground
        tableView.bounces = false
        tableView.register(JQActionSheetCell.self, forCellReuseIdentifier: String.init(describing: JQActionSheetCell.self))
        return tableView
    }()
}

extension JQActionSheetView {
    
    // MARK: - event response
    fileprivate func showSelectView() {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 1.0
            self.optionTableView.transform = CGAffineTransform(translationX: 0, y: -self.optionTableView.bounds.height)
        }, completion: nil)
    }
    
    fileprivate func close() {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.0
            self.optionTableView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    @objc fileprivate func statusBarOrientationDidChange(notification: NSNotification) {
        
        guard let view = self.superview else { return }
        frame = view.bounds
        setupTableViewFooterView()
    }
    
    @objc fileprivate func tapBgViewOrCancel() {
        
        if selectCallBack != nil {
            selectCallBack!(-1)
        }
        close()
    }
}

extension JQActionSheetView: UITableViewDataSource {

     public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: JQActionSheetCell.self), for: indexPath) as! JQActionSheetCell
        cell.selectionStyle = .none
        let jqSelectViewInfo: JQSelectViewInfo = options[indexPath.row]
        cell.titleLabel.text = options[indexPath.row].title
        cell.titleLabel.textColor = jqSelectViewInfo.color 
        cell.titleLabel.font = jqSelectViewInfo.font 
        return cell
    }
}

extension JQActionSheetView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jqSelectViewInfo: JQSelectViewInfo = options[indexPath.row]
        if jqSelectViewInfo.isTitle {return}
        if selectCallBack != nil {
            selectCallBack!(indexPath.row)
        }
        close()
    }
}
