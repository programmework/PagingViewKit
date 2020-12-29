//
//  ViewController.swift
//  PagingViewKit
//
//  Created by kingsic on 2020/12/29.
//  Copyright © 2020 kingsic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    lazy var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = ["固定样式一", "固定样式二", "滚动样式", "富文本样式", "badge 样式", "文字渐变效果", "文字缩放样式", "指示器固定样式", "指示器动态样式","指示器遮盖样式一", "指示器遮盖样式二（百度网盘传输界面）"]
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.text = dataSource[indexPath.row];
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc: UIViewController = FixedOneVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc: UIViewController = FixedTwoVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc: UIViewController = ScrollVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc: UIViewController = AttributedVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc: UIViewController = BadgeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc: UIViewController = gradientEffectVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc: UIViewController = ZoomVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc: UIViewController = IFixedVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc: UIViewController = IDynamicVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc: UIViewController = CoverOneVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc: UIViewController = CoverTwoVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

