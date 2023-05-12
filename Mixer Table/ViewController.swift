//
//  ViewController.swift
//  Mixer Table
//
//  Created by Егор Шумейко on 12.05.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, String> = {
        return UITableViewDiffableDataSource<String, String>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = itemIdentifier
            //MARK: save chekmark for cell
            cell?.accessoryType = self.selected.contains(itemIdentifier) ? .checkmark : .none
            return cell
        }
    }()
    
    private var data: [String] = []
    private var selected: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Task 4"
        
        for i in 0...30 {
            data.append(String(i))
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = .init(title: "Shuffle", primaryAction: .init(handler: { _ in
            self.updateData(self.data.shuffled(), animated: true)
        }))
        
        updateData(data, animated: false)
    }
    
    //MARK: Сообщаем diffable какие данные показать
    private func updateData(_ data: [String], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["first"])
        snapshot.appendItems(data, toSection: "first")
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    //MARK: Перехватываем нажатие
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = dataSource.itemIdentifier(for: indexPath) {
            
            if self.selected.contains(item) {
                selected = selected.filter({ $0 != item })
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                selected.append(item)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            if let first = dataSource.snapshot().itemIdentifiers.first, first != item {
                var snapshot = dataSource.snapshot()
                snapshot.moveItem(item, beforeItem: first)
                dataSource.apply(snapshot)
            }
        }
    }
}

