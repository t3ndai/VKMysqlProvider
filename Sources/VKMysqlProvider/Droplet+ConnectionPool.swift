import Vapor
import SwiftKuery

extension Droplet {
    public var connectionPool: SwiftKuery.ConnectionPool? {
        
        get{
            guard let pool = self.storage["SwiftKuery.ConnectionPool"] as? ConnectionPool else {
                throw VKError.noConnectionPoolCreated
            }
            return pool
        }
        set{ self.storage["SwiftKuery.ConnectionPool"] = newValue}
    }
}
