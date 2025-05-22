enum NetworkError: Error {
    
    case invalidData
    case unathorized
    
    var titleText: String {
        switch self {
        case .invalidData:
            return "Invalid Data"
        case .unathorized:
            return "Verification Failed"
        }
    }
    
    var messageText: String {
        switch self {
        case .invalidData:
            return "The data returned by the server was invalid."
        case .unathorized:
            return "Your username or password is incorrect."
        }
    }
}
