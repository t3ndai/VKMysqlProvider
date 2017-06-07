import Vapor
import SwiftKuery

private let SwiftKueryConnectionPoolKey = "SwiftKuery.ConnectionPool"

extension Droplet {
    
    public internal(set) var connectionPool: SwiftKuery.ConnectionPool? {
        
        get{ return  self.storage[SwiftKueryConnectionPoolKey] as? SwiftKuery.ConnectionPool }
        set{ self.storage[SwiftKueryConnectionPoolKey] = newValue }
    }
    
    public func assertConnectionPool() throws -> SwiftKuery.ConnectionPool {
        guard let connectionPool = self.connectionPool else {
            throw VKError.noConnectionPoolCreated
        }
        
        return connectionPool
    }
}
