//
//  AgoraCloudContentView.swift
//  AgoraWidgets
//
//  Created by ZYP on 2021/10/21.
//

import AgoraUIBaseViews
import Masonry

protocol AgoraCloudListViewDelegate: NSObjectProtocol {
    func agoraCloudListViewDidSelectedIndex(index: Int)
}

class AgoraCloudListView: UITableView {

    private var infos = [AgoraCloudCellInfo]()
    weak var listDelegate: AgoraCloudListViewDelegate?
    
    override init(frame: CGRect,
                  style: UITableView.Style) {
        super.init(frame: frame,
                   style: style)
        contentInset = .zero
        backgroundColor = .white
        tableFooterView = UIView()
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        register(AgoraCloudCell.self,
                 forCellReuseIdentifier: "AgoraCloudCell")
        dataSource = self
        delegate = self
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(infos: [AgoraCloudCellInfo]?) {
        self.infos = infos ?? [AgoraCloudCellInfo]()
        reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AgoraCloudListView: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgoraCloudCell",
                                                 for: indexPath) as! AgoraCloudCell
        let info = infos[indexPath.row]
        cell.set(info: info)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        listDelegate?.agoraCloudListViewDidSelectedIndex(index: indexPath.row)
    }
}
