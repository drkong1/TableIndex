//
//  ViewController.swift
//
// Copyright (c) 2021 Hunjong Bong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit

class ViewController: UIViewController {
    private lazy var table: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        return table
    }()

    private let names: [String: Array<String>] = ["A": ["a1", "a2", "a3"],
                                                  "B": ["b1", "b2", "b3"],
                                                  "C": ["c1", "c2", "c3"],
                                                  "D": ["d1", "d2", "d3"],
                                                  "E": ["e1", "e2", "e3"],
                                                  "F": ["f1", "f2", "f3"],
                                                  "G": ["g1", "g2", "g3"],
                                                  "H": ["h1", "h2", "h3"],
                                                  "I": ["i1", "i2", "i3"],
                                                  "J": ["j1", "j2", "j3"],
                                                  "K": ["k1", "k2", "k3"],
                                                  "L": ["l1", "l2", "l3"],
                                                  "M": ["m1", "m2", "m3"],
                                                  "N": ["n1", "n2", "n3"],
                                                  "O": ["o1", "o2", "o3"],
                                                  "P": ["p1", "p2", "p3"],
                                                  "Q": ["q1", "q2", "q3"],
                                                  "R": ["r1", "r2", "r3"],
                                                  "S": ["s1", "s2", "s3"]]
    private lazy var nameTitles: [String] = {
        let nameTitles = Array(names.keys).sorted()
        return nameTitles
    }()

    private var willLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.contentInsetAdjustmentBehavior = .never

        // 테이블뷰의 inset.top을 조정하고, 거기에 헤더를 addSubview
        var inset = table.contentInset
        inset.top = Const.headerHeight
        table.contentInset = inset

        let header = UIView()
        header.backgroundColor = .systemBlue
        table.addSubview(header)
        header.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(Const.headerHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(-Const.headerHeight)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if willLayout == false {
            // inset.top만큼 내려서 보여주게 함
            var offset = table.contentOffset
            offset.y = -Const.headerHeight
            table.contentOffset = offset

            willLayout = true
        }
    }
}

extension ViewController {
    enum Const {
        static let headerHeight: CGFloat = 200
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = nameTitles[section]
        return names[key]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let key = nameTitles[indexPath.section]

        cell.textLabel?.text = names[key]?[indexPath.row]
        return cell
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nameTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nameTitles
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset

        // 스크롤 offset에 따라서 inset.top을 변경해줘야 섹션헤더와 섹션인덱스가 같이 움직인다.
        if offset.y <= -Const.headerHeight {
            var inset = scrollView.contentInset
            inset.top = -offset.y
            scrollView.contentInset = inset
        } else if offset.y >= 0 {
            var inset = scrollView.contentInset
            inset.top = 0
            scrollView.contentInset = inset
        } else { // -Const.headerHeight ~ 0
            var inset = table.contentInset
            inset.top = -offset.y
            scrollView.contentInset = inset
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            // 스크롤 멈췄을 때 inset.top 다시 조정
            if scrollView.contentOffset.y < -Const.headerHeight {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -Const.headerHeight), animated: true)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -Const.headerHeight {
            // 스크롤 멈췄을 때 inset.top 다시 조정
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -Const.headerHeight), animated: true)
        }
    }
}
