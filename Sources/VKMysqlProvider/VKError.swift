public enum VKError: Error {
    case connectionPoolCreatorFail
    case noConnectionPoolCreated

    case unknown(Error)
}
