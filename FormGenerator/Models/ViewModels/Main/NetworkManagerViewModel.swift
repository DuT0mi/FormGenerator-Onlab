import Network
import SwiftUI
import Alamofire

@MainActor
final class NetworkManagerViewModel: ObservableObject{
    @Published var isChecking: Bool = false
    @Published var isConnected: Bool = false
    @Published var isNetworkReachable: Bool = false
    
    private let networkReachabilityManager = NetworkReachabilityManager()
    
    func isInternetAvailable() async -> Bool {
        isChecking.toggle()
        
        let monitor = NWPathMonitor()
        let connection = monitor.currentPath.status == .satisfied
        
        do {
            let path = try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<NWPath.Status, Error>) in
                monitor.pathUpdateHandler = { path in
                    continuation.resume(returning: path.status)
                    monitor.cancel()
                }
                monitor.start(queue: DispatchQueue.global())
            }
            isChecking.toggle()
            isConnected.toggle()
            return path == .satisfied
        } catch {
            isChecking.toggle()
            return connection
        }
    }
    
    init() { /* Listening always */
        networkReachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .reachable:
                self.isNetworkReachable = true
            case .notReachable:
                self.isNetworkReachable = false
            case .unknown:
                self.isNetworkReachable = false
            }
        })
    }
    
}
