//
//  MainViewController.swift
//  AppstoreSearch
//
//  Created by yeowongu on 2020/09/09.
//  Copyright © 2020 yeowongu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MainViewController: UITableViewController {
    
    var recentlyWords = [String]() // 최근 검색어
    var filteredWords = [String]() // 필터링 검색어
    
    private let searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "App Strore"
        searchController.automaticallyShowsSearchResultsController = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedWords = UserDefaults.standard.value(forKey: "recentlyWords") as? [String] {
            self.recentlyWords = savedWords
        }
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
        
    }

    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive {
            return self.filteredWords.count
        }
        
        return recentlyWords.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchController.isActive {
            return 30
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if self.searchController.isActive {
            cell.textLabel?.text = filteredWords[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = .systemFont(ofSize: 15)
        }
        
        else{
            cell.textLabel?.text = recentlyWords[indexPath.row]
            cell.textLabel?.textColor = .link
            cell.textLabel?.font = .systemFont(ofSize: 20)
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchController.isActive == true {
            return 1
        }
        
        return 70
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        if searchController.isActive == false {
            let headerTitle = UILabel()
            headerTitle.text = "최근 검색어"
            headerTitle.font = .boldSystemFont(ofSize: 25)
            headerView.addSubview(headerTitle)
            
            headerTitle.snp.makeConstraints { (maker) in
                maker.leading.equalTo(20)
                maker.bottom.equalTo(-8)
            }
        }
        
        return headerView
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.text = ""
        
        // 최근 검색어 테이블 뷰 리로드
        self.tableView.reloadData()
        
        return true
    }
    
    // 검색
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let word = searchBar.text {
            
            // 글자값 최소 1
            if word.count > 0 {
                
                // 검색어 중복 체크 및 처리
                for i in 0..<recentlyWords.count {
                    
                    let value = recentlyWords[i]
                    
                    if value == word {
                        self.recentlyWords.remove(at: i)
                        self.recentlyWords.insert(word, at: 0)
                        
                        print("recentlyWord same === \(recentlyWords)")
                        UserDefaults.standard.set(self.recentlyWords, forKey: "recentlyWords")
                        UserDefaults.standard.synchronize()
                        return
                    }
                }
                
                // 중복된 값이 없으면 저장, 오버 체크 및 삭제
                self.recentlyWords.insert(word, at: 0)
                if self.recentlyWords.count > 100 { // 100개 이후에는 삭제
                    self.recentlyWords.removeLast()
                    
                    print("recentlyWord over === \(recentlyWords)")
                }
            }
            
            // 저장
            UserDefaults.standard.set(self.recentlyWords, forKey: "recentlyWords")
            UserDefaults.standard.synchronize()
        }
    }
    
    // 취소
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKeyword = searchController.searchBar.text else {
            return
        }
        
        self.filteredWords = self.recentlyWords.filter({ (keyword) -> Bool in
            
            keyword.contains(searchKeyword)
            
        })
        
        self.tableView.reloadData()
    }
}
