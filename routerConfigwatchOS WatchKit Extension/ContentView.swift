//
//  ContentView.swift
//  routerConfigwatchOS WatchKit Extension
//
//  Created by M Shaneeb on 16/8/2020.
//

import SwiftUI

enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
    case ipv4 = "ipv4"
    case ipv6 = "ipv6"
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

struct ContentView: View {
    @State private var showingAlert = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        
        VStack {
            
            detailsView()
            
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
//            .modifier(PrimaryLabel())
          
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Hello"),message: Text(getAddress(for: .wifi)!), primaryButton: .destructive(Text("Hello Pressed")){
                    //                print("Hello Pressed")
                }, secondaryButton: .cancel())
            })
            
            Link(destination: URL(string: "http://www.apple.com")!) {
                Text("Router Link")
            }
//            .modifier(PrimaryLabel())
            //            .padding()
            
//            Button("Visit Apple") {
//                openURL(URL(string: "https://www.apple.com")!)
//            }
////            .modifier(PrimaryLabel())
        }
        
    }
}

//

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
            ContentView()
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            ContentView()
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
        //        NavigationView {
        //            ContentView()
        //        }
    }
}

struct detailsView: View {
    
    
    var body: some View {
        //        Group {
        Text("IP: ") +
            Text(getAddress(for: .wifi)!)
        Text("Router: ") +
            Text(getAddress(for: .wifi)!)
        Text("MAC: ") +
            Text(getAddress(for: .wifi)!)
        //        }
        //        .padding()
    }
}

struct PrimaryLabel: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(colorScheme == .dark ? Color.white : Color.black)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            .font(.largeTitle)
            .cornerRadius(10)
    }
}
