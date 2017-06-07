import URI
import Vapor
import SwiftKuery
import SwiftKueryMySQL

public final class ConnectionPoolCreator {
    let connectionPool: SwiftKuery.ConnectionPool
    init(hostname: String,
         user: String,
         password: String,
         database: String,
         port: Int = 3306,
        clientFlag: UInt = 0,
        encoding: String = "utf8",
        initialCapacity: Int = 3,
        maxCapacity: Int = 15,
        timeout: Int = 10000) {
        
        let poolOptions = ConnectionPoolOptions(initialCapacity: initialCapacity,
                                                maxCapacity: maxCapacity,
                                                timeout: timeout)
        
        connectionPool = MySQLThreadSafeConnection.createPool(host: hostname,
                                                        user: user,
                                                        password: password,
                                                        database: database,
                                                        port: port,
                                                        clientFlag: clientFlag,
                                                        characterSet: encoding,
                                                        poolOptions: poolOptions)
    }
}

extension ConnectionPoolCreator: ConfigInitializable {
    
    /// Creates a VaporKuery from a `keury-mysql.json`
    /// config file.
    ///
    /// The file should contain similar JSON:
    ///
    ///     {
    ///         "hostname": "127.0.0.1",
    ///         "user": "root",
    ///         "password": "",
    ///         "database": "test",
    ///         "port": 3306, // optional
    ///         "flag": 0, // optional
    ///         "encoding": "utf8" // optional
    ///         "pool" : 
    ///         {
    ///         "initialCapacity": 3,
    ///         "maxCapacity": 15,
    ///          "timeout": 10000 // millis
    ///         }
    ///     }
    ///
    /// Optionally include a url instead:
    ///
    ///     {
    ///         "url": "mysql://user:pass@host:3306/database"
    ///     }
    public convenience init(config: Config) throws {
        let file = "kuery-mysql"
        
        guard let mysql = config[file]?.object else {
            throw ConfigError.missingFile(file)
        }
        
        let flag = mysql["flag"]?.uint
        let encoding = mysql["encoding"]?.string
        
        guard let pool = mysql["pool"]?.object else {
            throw ConfigError.missing(key: ["pool"], file: file, desiredType: Any.self)
        }
        
        guard let initialCapacity = pool["initialCapacity"]?.int else {
            throw ConfigError.missing(key: ["initialCapacity"], file: file, desiredType: Int.self)
        }
        
        guard let maxCapacity = pool["maxCapacity"]?.int else {
            throw ConfigError.missing(key: ["maxCapacity"], file: file, desiredType: Int.self)
        }
        
        guard let timeout = pool["timeout"]?.int else {
            throw ConfigError.missing(key: ["timeout"], file: file, desiredType: Int.self)
        }

        
        if let url = mysql["url"]?.string {
            try self.init(file: file, url: url, flag: flag, encoding: encoding, initialCapacity: initialCapacity, maxCapacity: maxCapacity, timeout: timeout)
        } else {
            
            guard let hostname = mysql["hostname"]?.string else {
                throw ConfigError.missing(key: ["hostname"], file: file, desiredType: String.self)
            }
            
            guard let user = mysql["user"]?.string else {
                throw ConfigError.missing(key: ["user"], file: file, desiredType: String.self)
            }
            
            guard let password = mysql["password"]?.string else {
                throw ConfigError.missing(key: ["password"], file: file, desiredType: String.self)
            }
            
            guard let database = mysql["database"]?.string else {
                throw ConfigError.missing(key: ["database"], file: file, desiredType: String.self)
            }
            
            let port = mysql["port"]?.int
            
            self.init(
                hostname: hostname,
                user: user,
                password: password,
                database: database,
                port: port ?? 3306,
                clientFlag: flag ?? 0,
                encoding: encoding ?? "utf8",
                initialCapacity: initialCapacity,
                maxCapacity: maxCapacity,
                timeout: timeout
            )
        }
    }
    
    public convenience init(file: String,
                            url: String,
                            flag: UInt?,
                            encoding: String?,
                            initialCapacity: Int,
                            maxCapacity: Int,
                            timeout: Int) throws {
        
        let uri = try URI(url)
        
        guard
            let user = uri.userInfo?.username,
            let pass = uri.userInfo?.info
            else {
                throw ConfigError.missing(key: ["url(userInfo)"], file: file, desiredType: URI.self)
        }
        
        let db = uri.path
            .characters
            .split(separator: "/")
            .map { String($0) }
            .joined(separator: "")
        
        self.init(
            hostname: uri.hostname,
            user: user,
            password: pass,
            database: db,
            port: uri.port.flatMap { Int($0) } ?? 3306,
            clientFlag: flag ?? 0,
            encoding: encoding ?? "utf8",
            initialCapacity: initialCapacity,
            maxCapacity: maxCapacity,
            timeout: timeout
        )
    }
}
