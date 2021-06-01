//
//  ReviewHomeworkTests.swift
//  ReviewHomeworkTests
//
//  Created by 周彥宏 on 2021/6/1.
//

import XCTest
@testable import ReviewHomework

class ReviewHomeworkTests: XCTestCase {
    
    var detailViewModel: DetailViewModel!
    
    var collectionView: UICollectionView!
    
    /*
     remove 「class」 func
     Sometimes Xcode when overrides methods adds class func instead of just func. Then in static method you can't see instance properties. It is very easy to overlook it.
     */
    override func setUp() {
        super.setUp()
        
        detailViewModel = DetailViewModel();
    }
    
    override func tearDown() {
        detailViewModel = nil;
        collectionView = nil
        super.tearDown()
    }
    
    func test_download_photos() {
        let promise = expectation(description: "completion invoked")
        
        NetworkManager.sharedInstance.fetchPhotos { (photos) in
            promise.fulfill();
            
            XCTAssertNotNil(photos)
            self.detailViewModel = DetailViewModel(photos: photos);
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_isNotEmpty() {
        /// call API
        test_download_photos()
        
        /// modelAtRows success
        let model = self.detailViewModel.modelAtRows(0)
        XCTAssertNotNil(model)
        /// url != 空字串
        XCTAssertNotEqual(model.thumbnailUrl, "")
        
        /// numberOfRows success
        let number = self.detailViewModel.numberOfRows()
        XCTAssertNotEqual(number, 0)
        
        /// cellForIndexPath success
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(cellType: DetailCell.self);
        let cell = self.detailViewModel.cellForIndexPath(collectionView: collectionView, IndexPath(item: 0, section: 0))
        XCTAssertNotNil(cell)
    }

    func test_download_image() {
        /// call API
        test_download_photos()
        
        var urls: [String] = []

        (0...8).forEach({
            urls.append(self.detailViewModel.modelAtRows($0).thumbnailUrl)
        })

        /// 最後一個 404
        urls.append("https://via.placeholder.com/404")
        
        /// 保證10個
        XCTAssertEqual(urls.count, 10)

        urls.forEach({
            let promise = expectation(description: "completion invoked")
            
            guard let url = URL(string: $0) else { return }
            
            NetworkManager.sharedInstance.fetchImage(url: url) { (result) in
                promise.fulfill();
                
                switch result {
                case .success(let image):
                    /// 前面9個保證有image
                    XCTAssertNotNil(image)
                case .failure(let error):
                    /// 最後一個 404 保證error不是nil
                    XCTAssertNotNil(error)
                }
            }
            
            wait(for: [promise], timeout: 5)
        })
    }
    
    func testRequest() {
        self.measure {
            test_download_photos()
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
