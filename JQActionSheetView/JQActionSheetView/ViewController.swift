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
            let option1 = JQSelectViewInfo(title: "退出", color: UIColor.green)
            JQActionSheetView.show(title: "是否退出登录？", options: [option1], cancelTitle: nil, selectCallBack: { index in
                print(index)
            }) {
                print("取消了")
            }
            break
        case 1:
            let option1 = JQSelectViewInfo(title: "语音通话", color: nil)
            let option2 = JQSelectViewInfo(title: "视频聊天", color: nil)
            JQActionSheetView.show(title: "请选择聊天方式？", options: [option1, option2], cancelTitle: nil, selectCallBack: { index in
                print(index)
            })
            break
        case 2:
            let option1 = JQSelectViewInfo(title: "选择1", color: UIColor.black)
            let option2 = JQSelectViewInfo(title: "选择2", color: UIColor.orange)
            let option3 = JQSelectViewInfo(title: "选择3", color: UIColor.brown)
            let cancel = JQSelectViewInfo(title: "取消", color: UIColor.cyan)
            
            JQActionSheetView.show(title: "请选择聊天方式？", options: [option1, option2, option3], cancelTitle: cancel, selectCallBack: { index in
                print(index)
            })
            break
        default:
            break
        }
        
    }

}

