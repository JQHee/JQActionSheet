//
//  JQActionSheetView.swift
//
//
//  Created by HJQ on 2017/6/23.
//  Copyright © 2017年 HJQ. All rights reserved.
//

import UIKit
import SnapKit

// 标题，取消按钮，高度
private let KDEFAULTH: CGFloat = 50
// 取消按钮的间隔
private let KCANCLEBUTTONPADDING: CGFloat = 8
// cell高度
private let KCELLH: CGFloat = 50
// cell推荐个数
private let KCELLCOUNT: CGFloat = 4
// 默认字体
private let KDEFAULTFONT = UIFont.systemFont(ofSize: 16)

public struct JQSelectViewInfo {
    public var title: String
    public var color: UIColor?
    
    public init(title: String, color: UIColor?) {
        self.title = title
        self.color = color
    }
}

fileprivate struct Action {
    static let tapBgViewOrCancel = #selector(JQActionSheetView.tapBgViewOrCancel)
}

class JQActionSheetView: UIView {
    
    var title: String?
    var cancelTitle: JQSelectViewInfo?
    var contentViewH: CGFloat!
    var tableViewH: CGFloat!
    var options: [JQSelectViewInfo]!
    
    var selectCallBack: ((_ index: Int) -> Swift.Void)?
    var cancelCallBack: (() -> Swift.Void)?
    
    
    // MARK: - public methods
    init(title: String? = "", options: [JQSelectViewInfo], cancelTitle: JQSelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?, cancelCallBack: (() -> Swift.Void)?) {
        super.init(frame: UIScreen.main.bounds)
        self.title = title
        self.options = options
        self.cancelTitle = cancelTitle
        self.selectCallBack = selectCallBack
        self.cancelCallBack = cancelCallBack
        
        let count = CGFloat(options.count)
        tableViewH = (count <= KCELLCOUNT ? count : 4) * KCELLH
        contentViewH = KCANCLEBUTTONPADDING + CGFloat(tableViewH) + (title == nil ? KDEFAULTH : KDEFAULTH * 2)
        setupView()
    }
    
    class open func show(title: String? = "", options: [JQSelectViewInfo], cancelTitle: JQSelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?) {
        JQActionSheetView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: nil).showSelectView()
    }
    
    class open func show(title: String?, options: [JQSelectViewInfo], cancelTitle: JQSelectViewInfo?, selectCallBack: ((_ index: Int) -> Swift.Void)?, cancelCallBack: (() -> Swift.Void)?) {
        JQActionSheetView(title: title, options: options, cancelTitle: cancelTitle, selectCallBack: selectCallBack, cancelCallBack: cancelCallBack).showSelectView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - lazy load
    fileprivate lazy var coverView: UIView = {
        let view: UIView = UIView.init()
        view.frame = self.frame
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: Action.tapBgViewOrCancel)
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view: UIView = UIView.init()
        view.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 0)
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel? = {
        let label: UILabel = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var optionTableView: UITableView = {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.register(JQActionSheetCell.self, forCellReuseIdentifier: String.init(describing: JQActionSheetCell.self))
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.groupTableViewBackground
        tableView.bounces = false
        return tableView
    }()
    
    fileprivate lazy var cancelButton: UIButton = {
        let btn: UIButton = UIButton.init(type: UIButtonType.custom)
        btn.titleLabel?.font = KDEFAULTFONT
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: Action.tapBgViewOrCancel, for: .touchUpInside)
        return btn
    }()
    
}

// MARK: - 初始化
extension JQActionSheetView {
    
    fileprivate func setupSubviewsFrames() {
        
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(contentViewH)
        }
        
        var isHasTitle: Bool = false
        // 标题
        if let title = title {
            titleLabel?.text = title
            contentView.addSubview(titleLabel!)
            titleLabel?.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(KCELLH - 0.5)
            })
            isHasTitle = true
        }
        
        optionTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(isHasTitle ? KDEFAULTH : 0)
            make.height.equalTo(tableViewH)
            
        }
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(KDEFAULTH)
        }
    }
    
    fileprivate func setupView() {
        // 设置背景
        addSubview(coverView)
        
        // 内容
        addSubview(contentView)
        
        // 设置选项列表
        contentView.addSubview(optionTableView)
        
        contentView.addSubview(cancelButton)
        
        // 配置相关的属性
        optionTableView.isScrollEnabled = CGFloat(options.count) > KCELLCOUNT
        
        cancelButton.setTitle(cancelTitle?.title ?? "取消", for: .normal)
        cancelButton.setTitleColor(cancelTitle?.color ?? UIColor.darkGray, for: .normal)
        
        setupSubviewsFrames()
    }
    
    
    // 显示出来
    fileprivate func showSelectView() {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 1.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.bounds.height)
        }, completion: nil)
    }
    
    
    // MARK: - event response
    @objc fileprivate func tapBgViewOrCancel() {
        if cancelCallBack != nil {
            cancelCallBack!()
        }
        close()
    }
    
    // 隐藏并移除
    @objc fileprivate func close() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.coverView.alpha = 0.0
            self.contentView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension JQActionSheetView: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: JQActionSheetCell.self), for: indexPath) as! JQActionSheetCell
        cell.titleLabel.text = options[indexPath.row].title
        if let color = options[indexPath.row].color {
            cell.titleLabel.textColor = color
        }
        return cell
    }
}

extension JQActionSheetView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return KCELLH
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectCallBack != nil {
            selectCallBack!(indexPath.row)
        }
        close()
    }
}
