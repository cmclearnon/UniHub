//
//  URLProtocolMock.swift
//  UniHubTests
//
//  Created by Chris McLearnon on 14/10/2020.
//

import Foundation

// URLProtocol subclass to intercept the Network layer & create mocked URLRequest responses
class URLProtocolMock: URLProtocol {

    static var response: URLResponse?
    static var error: Error?
    
    /// Handler to verify the URLRequest & return a mocked response
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Override of startLoading() to intercept network request, verify it & send notifications back to URLProtocol client
    override func startLoading() {
      guard let handler = URLProtocolMock.requestHandler else {
        fatalError("Handler is unavailable.")
      }
        
      do {
        /// Call handler to verify request & capture the mocked Response & Data
        let (response, data) = try handler(request)
        
        /// Notify the client that a response object has been created
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
          /// Notify the client that a data object has been created
          client?.urlProtocol(self, didLoad: data)
        }
        
        /// Notify client that URLProtocolMock has completed loading
        client?.urlProtocolDidFinishLoading(self)
      } catch {
        /// Notify client that an error has occured
        client?.urlProtocol(self, didFailWithError: error)
      }
    }

    override func stopLoading() {

    }
}
