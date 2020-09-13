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
    
    let APPSTORE_SEARCH_DOMAIN = "https://itunes.apple.com/search"
    
    var recentlyWords = [String]()      // 최근 검색어
    var filteredWords = [String]()      // 필터링 검색어
    var results = [AppDataModel]()   // 미리보기 데이터
    
    /// 검색을 하고있는지 완료했는지의 상태값
    enum searchState {
        case ready      // 준비
        case typing     // 입력중
        case searched   // 검색완료
    }
    var bSearchState:searchState = .ready
    ///
    
    private let searchController: UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "App Strore"
        searchController.automaticallyShowsSearchResultsController = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let path = NSHomeDirectory()
        //print(path)
        
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
        
        // definesPresentationContext를 true로 설정하여 UISearchController가 활성화되어있는 동안 사용자가 다른 뷰 컨트롤러로 이동하면 search bar가 화면에 남아 있지 않도록 합니다.
        self.definesPresentationContext = true
        
    }
    
    // MARK: - SearchKeyword
    func startSearchApps(value:String) {
        
        let parameters:String = "?term=\(value)&country=kr&media=software&entity=software&limit=25"
        
        let urlString = APPSTORE_SEARCH_DOMAIN+parameters
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        if let url = URL(string: encodedUrl!) {
            
            print("App Search EncodedUrl === \(url)")
            
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if error == nil && data != nil {
                    
                    do {
                        if let searchDatas:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                            
                            // 검색 상태값 = 검색완료
                            self.bSearchState = .searched
                            
                            // 검색결과 리스트 초기화
                            self.results.removeAll()
                            
                            //print("results === \(result["results"])")
                            
                            // 앱 검색 데이터 세팅
                            //self.previewDatas = searchDatas["results"] as! [[String : Any]]
                            let list = searchDatas["results"] as! [[String : Any]]
                            
                            for item in list {
                                
                                let data = try! JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                                
                                let jsonDecoder = JSONDecoder()
                                let decodedData = try! jsonDecoder.decode(AppDataModel.self, from: data)
                                self.results.append(decodedData)
                            }
                
                            DispatchQueue.main.async {
                                
                                // 검색 입력 중지
                                self.searchController.searchBar.endEditing(true)
                                self.searchController.isActive = true
                                
                                self.tableView.reloadData()
                                self.view.layoutIfNeeded()
                            }
                        }
                    }
                    catch {
                        print("Fail App Search === \(error)")
                    }
                    
                }else{
                    // error
                }
                
            }.resume()
        }
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if bSearchState == .typing {
            return self.filteredWords.count
        }
        
        else if bSearchState == .searched {
            return self.results.count
        }
        
        return self.recentlyWords.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if bSearchState == .typing {
            return 30
        }
        
        else if bSearchState == .searched {
            return 290
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 최근 검색어 Cell
        if bSearchState == .ready {
            
            tableView.separatorStyle = .singleLine
            
            let cell:defaultCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! defaultCell
            cell.titleLabel.text = self.recentlyWords[indexPath.row]
            
            return cell
        }
        
        // 필터링 검색어 Cell
        else if bSearchState == .typing {
            
            tableView.separatorStyle = .singleLine
            
            let cell:filteredCell = tableView.dequeueReusableCell(withIdentifier: "filteredCell", for: indexPath) as! filteredCell
            cell.titleLabel.text = self.filteredWords[indexPath.row]
            
            return cell
        }
        
        // 미리보기 Cell
        else if bSearchState == .searched {
            
            let cell:previewCell = tableView.dequeueReusableCell(withIdentifier: "previewCell", for: indexPath) as! previewCell
            
            // 선 없애기
            tableView.separatorStyle = .none
            
            let appData = self.results[indexPath.row]
            
            cell.titleLabel.text = appData.trackName
            cell.subTitleLabel.text = appData.sellerName
            
            cell.appIcon.downloadImageWithLoad(imageUrl: appData.artworkUrl100)
            
            let screenshotUrls = appData.screenshotUrls
            for i in 0..<screenshotUrls.count {
                
                if i > 2 { break }
                
                let url = screenshotUrls[i]
                
                switch i {
                case 0: cell.screenshot_1.downloadImageWithLoad(imageUrl: url)
                case 1: cell.screenshot_2.downloadImageWithLoad(imageUrl: url)
                case 2: cell.screenshot_3.downloadImageWithLoad(imageUrl: url)
                default: break
                }
            }
            
            return cell
        }
        
        
        return UITableViewCell()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 미리보기 Cell
        if bSearchState == .ready {
            let cell = tableView.cellForRow(at: indexPath) as! defaultCell
            if let keyword = cell.titleLabel.text {
                searchController.searchBar.isSearchResultsButtonSelected = true
                searchController.searchBar.text = cell.titleLabel.text
                
                // 검색 시작
                self.startSearchApps(value: keyword)
            }
        }
        
        else if bSearchState == .typing {
            let cell = tableView.cellForRow(at: indexPath) as! filteredCell
            if let keyword = cell.titleLabel.text {
                searchController.searchBar.text = cell.titleLabel.text
                
                // 검색 시작
                self.startSearchApps(value: keyword)
            }
        }
        
        else if bSearchState == .searched {
            
            // AppDetailViewController get
            let detailViewController:AppDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppDetailViewController") as! AppDetailViewController

            // 선택한 Data set
            let result = self.results[indexPath.row]
            detailViewController.appData = result

            self.navigationController?.pushViewController(detailViewController, animated: true)
        
        }
    }
}


// MARK: - SearchBar
extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 검색 상태값 = 입력 시작
        self.bSearchState = .typing
    }
    
    // 검색
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let keyword = searchBar.text {
            
            // 글자값 최소 1 이상
            if keyword.count > 0 {
                
                // 검색어 중복 체크 및 처리
                recentlyWords = recentlyWords.filter { !$0.contains(keyword) }
                
                // 검색어 저장
                recentlyWords.insert(keyword, at: 0)
                
                // 100개 이상이면 가장 오래된 데이터 삭제
                if recentlyWords.count > 100 { recentlyWords.removeLast() }
                
                //print("search Btn click recentlyWord === \(recentlyWords)")
                
                // 배열 저장
                UserDefaults.standard.set(self.recentlyWords, forKey: "recentlyWords")
                UserDefaults.standard.synchronize()
                
                // 검색 시작
                self.startSearchApps(value: keyword)
            }
        }
    }
    
    // 취소
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // 검색 상태값 = 준비
        self.bSearchState = .ready
        
        self.tableView.reloadData()
        
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchKeyword = searchController.searchBar.text else {
            return
        }
        
        self.filteredWords = self.recentlyWords.filter({ $0.contains(searchKeyword) })
        
        self.tableView.reloadData()
    }
}
