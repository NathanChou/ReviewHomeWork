//
//  NetworkManager.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import Alamofire

public enum NetworkError: Error {
    case dataNil
    case statusDecode
    case messageDecode(_ msg: String?)
    case checksumDecode(_ msg: String?)
    case dataDecode
    case requestFailure(_ msg: String)
    case custom(_ msg: String)
    
    
    var msg: String {
        switch self {
        case .dataNil: return "- Empty Data -"
        case .statusDecode: return "- Status Decode Failed -"
        case .messageDecode(let msg): return msg == nil ? "- 無法解析錯誤訊息 -" : msg!
        case .checksumDecode(let msg): return msg == nil ? "- checksum Fail -" : msg!
        case .dataDecode: return "- Data Decode Failed -"
        case .requestFailure(let msg): return msg
        case .custom(let msg): return msg
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? { return NSLocalizedString(msg, comment: "") }
}


public enum ImageError: Error {
    case dataNil
    case requestFailure(_ msg: String)
    case loadCacheFailure
    case tryCatchFailure(_ msg: String)
    case dataDecode
    case custom(_ msg: String)
    
    
    var msg: String {
        switch self {
        case .dataNil: return "- Empty Data -"
        case .requestFailure(let msg): return msg
        case .loadCacheFailure: return "- load Cache Failed -"
        case .tryCatchFailure(let msg): return msg
        case .dataDecode: return "- Data Decode Failed -"
        case .custom(let msg): return msg
        }
    }
}

extension ImageError: LocalizedError {
    public var errorDescription: String? { return NSLocalizedString(msg, comment: "") }
}


public class NetworkManager {
    
    public static let sharedInstance = NetworkManager()
    
    public typealias DataResult = Swift.Result<Data, NetworkError>
    
    public typealias ImageResult = Swift.Result<UIImage, ImageError>
    
    public let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = 60
        let memoryCapacity = 500 * 1024 * 1024; // 500 MB
        let diskCapacity = 500 * 1024 * 1024; // 500 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        configuration.urlCache = cache
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    let imageCache = NSCache<NSURL, UIImage>()
    
    public func makeRequest(url: String,
                            method: HTTPMethod = .post,
                            parameters: Parameters? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            headers: HTTPHeaders? = nil,
                            completion: @escaping(DataResult) -> ()) {
        
        sharedSessionManager.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: encoding,
                                     headers: headers).validate().responseData { [unowned self] (response) in
                                        
            
            self.cleanCookies(from: url)
            
            switch response.result {
            case .success:
                guard let data = response.result.value else {
                    return completion(.failure(.dataNil))
                }
                
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(.requestFailure(error.localizedDescription)))
            }
        }
    }
    
  
    func fetchImage(url: URL, completion: @escaping (ImageResult) -> ()) {
        // 如果NSCache有緩存的話
        if let image = imageCache.object(forKey: url as NSURL) {
            print("match NSCache ***")
            completion(.success(image))
            return
        }
        
        // 代入Etag驗證緩存
        let header: HTTPHeaders = ["If-None-Match": self.loadEtagUserDefault(keyValue: "Etag")];
        
        sharedSessionManager.request(url, method: .get, parameters: [:], headers: header).validate().responseData { (response) in
            
            switch response.result {
            case .success:
                
                self.saveCache(response)
                
                // 獲取etag並保存
                if let etag =  response.response?.allHeaderFields["Etag"] as? String {
                    self.saveEtagUserDefault(etagValue: etag, key: "Etag")
                }
                
                guard let responseData = response.data  else { return completion(.failure(.dataNil)) }
                
                if let image = UIImage(data: responseData) {
                    // 使用NSCache緩存
                    self.imageCache.setObject(image, forKey: url as NSURL)
                    
                    completion(.success(image))
                    
                } else {
                    completion(.failure(.dataDecode))
                }
                
            case .failure(let error):
                let statusCode = response.response?.statusCode
                
                if statusCode == 304 {
                    print("match statusCode 304 ***")
                    
                    var oldRequest: URLRequest?
                    
                    do {
                        oldRequest = try response.request?.asURLRequest()
                    } catch {
                        completion(.failure(.tryCatchFailure(error.localizedDescription)))
                    }
                    
                    guard let request = oldRequest else {
                        return completion(.failure(.dataDecode))
                    }
                    
                    guard let cache = self.loadCache(url: request) else {
                        return completion(.failure(.loadCacheFailure))
                    }
                    
                    guard let cacheImage = UIImage(data: cache) else {
                        return completion(.failure(.dataDecode))
                    }
                
                    completion(.success(cacheImage))
                    
                } else {
                    completion(.failure(.requestFailure(error.localizedDescription)))
                }
            }
        }
    }
    
    private func saveCache(_ dataResponse: (DataResponse<Data>)) {
        guard let response = dataResponse.response else { return print("cache no response") }
        guard let data = dataResponse.data else { return print("cache no data") }
        
        let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowed);
      
        if let mycache: URLCache = self.sharedSessionManager.session.configuration.urlCache,
           let request = dataResponse.request {
            mycache.storeCachedResponse(cachedResponse, for: request)
        } else {
            print("store cache fail")
        }
    }
    
    private func loadCache(url: URLRequest) -> Data? {
        if let myCache: URLCache = self.sharedSessionManager.session.configuration.urlCache {
            let cacheResponse = myCache.cachedResponse(for: url)
            return cacheResponse?.data
        }
        
        print("load cache fail")
        return nil
    }

    private func saveEtagUserDefault(etagValue:String,key:String) -> Void {
      UserDefaults.standard.set(etagValue, forKey:key)
      UserDefaults.standard.synchronize()
    }
    
    private func loadEtagUserDefault(keyValue:String) -> String {
      return UserDefaults.standard.object(forKey: keyValue) as? String ?? "0"
    }
    
}

extension NetworkManager {
    public func cleanCookies(from urlString: String){
        let cstorage = HTTPCookieStorage.shared
        guard let url = URL(string: urlString) else {return}
        if let cookies = cstorage.cookies(for: url) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
    }
    
    public func decodeModel<T: Decodable>(data: Data) -> T? {
        do {
            let json = try JSONDecoder().camelCase().decode(T.self, from: data)
            return json
        } catch {
            return nil
        }
    }
    
    /// - Parameters:
    ///   - model: The Model You Want To Decode.
    ///   - result: The result from makeRequestResult
    /// - Returns: Swift.Result<T, NetworkError>
    public func handleResult<T: Decodable>(_ model: T.Type, _ result: Swift.Result<Data, NetworkError>) -> Swift.Result<T, NetworkError> {
        switch result {
        case .success(let data):
            
            if let model: T = self.decodeModel(data: data) {
                return .success(model)
            } else {
                return .failure(.dataDecode)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}


extension JSONDecoder {
    public func camelCase() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
}

