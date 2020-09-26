//
//  AllenRequestCenter.swift
//  PicDemo
//
//  Created by ko on 2020/9/22.
//  Copyright © 2020 SM. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Combine

public class AllenRequestCenter: NSObject {

    static let sharedInstance = AllenRequestCenter()

    let imageCache = NSCache<NSURL, UIImage>()

    private let allowedDiskSize = 100 * 1024 * 1024
    private lazy var cache: URLCache = {
        return URLCache(memoryCapacity: 0, diskCapacity: allowedDiskSize, diskPath: "photoCache")
    }()

    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    func apiErrorResut(response: AFDataResponse<Any>, failure failureCallbac:@escaping (AFError, _ code: Int, _ desc: String) -> ()) {

        switch response.result {

        case .failure(let error):


            let statusCode = response.response?.statusCode
            var description = ""
            switch error {
            case .invalidURL(let url):
                description = "Invalid URL: \(url) - \(error.localizedDescription)"
            case .parameterEncodingFailed(let reason):
                description = "Parameter encoding failed: \(error.localizedDescription)" + "Failure Reason: \(reason)"
            case .multipartEncodingFailed(let reason):
                description = "Multipart encoding failed: \(error.localizedDescription)" + "Failure Reason: \(reason)"

            case .responseValidationFailed(let reason):
                description  = "Response validation failed: \(error.localizedDescription)" + "Failure Reason: \(reason)"

                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    description = "Downloaded file could not be read"
                case .missingContentType(let acceptableContentTypes):
                    description = "Content Type Missing: \(acceptableContentTypes)"
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    description = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"

                case .unacceptableStatusCode(let code):
                    description = "Response status code was unacceptable: \(code)"
                case .customValidationFailed(error: _):
                    description = "CustomValidationFailed"

                }

            case .createUploadableFailed(error: let error):
                description = "UploadableFailed: \(error.localizedDescription)"
            case .createURLRequestFailed(error: let error):
                description = "URLRequestFailed: \(error.localizedDescription)"
            case .downloadedFileMoveFailed(error: let error, source: _, destination: _):
                description = "URLRequestFailed: \(error.localizedDescription)"
            case .explicitlyCancelled:
                description = "explicitlyCancelled"
            case .parameterEncoderFailed(reason: let reason):
                description = "URLRequestFailed: \(reason)"
            case .requestAdaptationFailed(error: let error):
                description = "requestAdaptationFailed: \(error.localizedDescription)"
            case .requestRetryFailed(retryError: let retryError, originalError: _):
                description = "RetryFailed: \(retryError.localizedDescription)"
            case .responseSerializationFailed(reason: let reason):
                description = "SerializationFailed: \(reason)"
            case .serverTrustEvaluationFailed(reason: let reason):
                description = "TrustEvaluationFailed: \(reason)"
            case .sessionDeinitialized:
                description = "sessionDeinitialized"
            case .sessionInvalidated(error: let error):
                description = "sessionInvalidated: \(error!.localizedDescription)"
            case .sessionTaskFailed(error: let error):
                description = "sessionTaskFailed: \(error.localizedDescription)"
            case .urlRequestValidationFailed(reason: let reason):
                description = "urlRequestValidationFailed: \(reason)"
            
            }
            if let code = statusCode  {
                failureCallbac(error, code, description)
                print("ok") }
            else {  failureCallbac(error, 500, description) }


        case .success(_):
            print("")
        }
    }

    //MARK: -- getDatasWithUrl
    func getDatasWithUrl<T>(url urlString:String,
                    success successCallback: @escaping ([T], _ code: Int) -> (),
                    failure failureCallbac:@escaping (AFError, _ code: Int, _ desc: String) -> ()) {

        if self.isConnectedToInternet {
            print("Yes! internet is available.")

        }
        else {
            failureCallbac(AFError.invalidURL(url: ""), 503, "No! internet is not available.")

            return
        }

        let urlStr = urlString
        let eTagDic = UserDefaults.standard.object(forKey: USER_DEFAULT_IMAGE_STOREKEY.ImageStoreKey) as? Dictionary<String, String>
        
        var headers: HTTPHeaders = []
        if let etagStr = eTagDic?[HEADER.Etag] {
            headers = [ "Accept": "application/json","If-None-Match" : etagStr]
        } else {
            headers = [ "Accept": "application/json"]
        }

        AF.request(urlStr, headers: headers)
            .validate(statusCode: 200..<511)
            .responseJSON { (response) in
                switch response.result {
                
                case .success(let array):
                    let statusCode = response.response?.statusCode
                    
                    let responseHeader = response.response?.allHeaderFields
                    print(responseHeader as Any)
                    
                    if let eTag = responseHeader?[HEADER.Etag] as? String {
                        let dictionaryKey = USER_DEFAULT_IMAGE_STOREKEY.ImageStoreKey
                        var dictionary = UserDefaults.standard.dictionary(forKey: dictionaryKey) as? [String: String]
                        if dictionary == nil {
                            dictionary = [String: String]()
                        }
                        dictionary![HEADER.Etag] = eTag
                        UserDefaults.standard.set(dictionary, forKey: dictionaryKey)
                        UserDefaults.standard.synchronize()
                        
                        
                    }
                    let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data!, userInfo: nil, storagePolicy: .allowed)
                    self.cache.storeCachedResponse(cachedURLResponse, for: URLRequest(url: URL(string: urlStr)!))
                    
                    
                    successCallback(array as! [T], statusCode!)
                    
                case .failure( _):
                    //304~~
                    do {
                        if let data = self.cache.cachedResponse(for: URLRequest(url: URL(string: urlStr)!))?.data {
                            let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            
                            let statusCode = response.response?.statusCode
                            successCallback(jsonArray as! [T], statusCode!)
                        }
                        else {
                            self.apiErrorResut(response: response, failure: failureCallbac)
                        }
                        
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                }
            }

    }

    //MARK: -- imagePublisher
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        let session = URLSession(configuration: configuration)
        
        return session
    }()
    
    enum ImageManagerError: Error {
        case invalidResponse
    }
    
    func imagePublisher(for url: URL, errorImage: UIImage? = nil) -> AnyPublisher<UIImage?, Never> {

        if let image = imageCache.object(forKey: url as NSURL) {

            return Just(image).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode,
                    let image = UIImage(data: data)
                else {
                    throw ImageManagerError.invalidResponse
                }
                self.imageCache.setObject(image, forKey: url as NSURL)
                return image
            }
            .replaceError(with: errorImage)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
     
}


 
 
