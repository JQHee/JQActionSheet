//
//  ViewController.swift
//  JQActionSheetView
//
//  Created by HJQ on 2017/6/25.
//  Copyright © 2017年 HJQ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let datas: [String] = ["带取消按钮的回调","一般选择器样式","自定义样式"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义底部ActionSheet"
        tableView.tableFooterView = UIView.init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: String.init(describing: UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: String.init(describing: UITableViewCell.self))
        }
        cell?.textLabel?.text = datas[indexPath.row]
        return cell!
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            break
        case 1:

            break
        case 2:
            let option1 = JQSelectViewInfo(title: "我是标题", color: UIColor.black, font: UIFont.systemFont(ofSize: 14), isTitle: true)
            let option2 = JQSelectViewInfo(title: "选择2", color: UIColor.orange, font: UIFont.systemFont(ofSize: 14))
            let option3 = JQSelectViewInfo(title: "选择3", color: UIColor.brown, font: UIFont.systemFont(ofSize: 14))
            let cancel = JQSelectViewInfo(title: "取消", color: UIColor.cyan, font: UIFont.systemFont(ofSize: 14))
        JQActionSheetView.init(options: [option1, option2, option3], cancelTitle: cancel, selectCallBack: { (index) in
            print(index)
        })
            break
        default:
            break
        }
        
    }

}

