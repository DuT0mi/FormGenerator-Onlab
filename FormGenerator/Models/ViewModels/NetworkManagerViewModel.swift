import Network
import SwiftUI

@MainActor
final class NetworkManagerViewModel: ObservableObject{
    @Published var isChecking:Bool = false
    @Published var isConnected:Bool = false
    
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
}
