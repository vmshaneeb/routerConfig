//
//  ContentView.swift
//  routerConfig
//
//  Created by M Shaneeb on 7/8/2020.
//

import SwiftUI
import Network
import SystemConfiguration

struct ContentView: View {
    @State private var showingAlert = false
    
    enum Network: String {
        case wifi = "en0"
        case cellular = "pdp_ip0"
        case ipv4 = "ipv4"
        case ipv6 = "ipv6"
    }
    
    func getRouter() -> String? {
        var routerString: String?
        
        guard let ds = SCDynamicStoreCreate(kCFAllocatorDefault, "myapp" as CFString, nil, nil)
        else {
            print("Could not connect to store")
            abort()
        }
        
        guard let dr = SCDynamicStoreCopyValue(ds, "State:/Network/Global/IPv4" as CFString)
        else {
            print("Could not connect to state")
            abort()
        }
        
        routerString = dr["Router"] as? String
        
        return "http://" + routerString!
    }
    
    func getAddress(for network: Network) -> String? {
        var address: String?
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) {
                // || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    var body: some View {
        
        VStack {
            Button(action: {
                //            print("Hello")
                self.showingAlert = true
            }) {
                //            Text("Hello")
                Image(systemName: "antenna.radiowaves.left.and.right")
                //                .font(.body)
                //                .foregroundColor(.red)
                Text("Check IP")
                
            }
            .padding()
            //        .font(.body)
            //        .cornerRadius(40)
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Hello"),message: Text(getRouter()!), primaryButton: .destructive(Text("Hello Pressed")){
                    //                print("Hello Pressed")
                }, secondaryButton: .cancel())
            })
            
            Link(destination: URL(string: getRouter()!)!) {
                Text("Router Link")
            }.padding()
            
        }
        
    }
}

//

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}


