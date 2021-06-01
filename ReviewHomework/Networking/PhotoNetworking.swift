//
//  PhotoNetworking.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import Alamofire

extension NetworkManager {
    func fetchPhotos(completion: @escaping([PhotosModel]) -> ()) {
        makeRequest(url: URLs.PHOTOS, method: .get) { (result) in
            
            let handled = self.handleResult([PhotosModel].self, result)
            switch handled {
            case .success(let model):
                completion(model);
            case .failure(let error):
                print(error.localizedDescription)
                completion([]);
            }
        }
    }
}
