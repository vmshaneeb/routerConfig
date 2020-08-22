//
//  ContentView.swift
//  routerConfig
//
//  Created by M Shaneeb on 16/8/2020.
//

import SwiftUI
import FGRoute
import WebKit
import SafariServices
import BetterSafariView

struct ContentView: View {
    @State private var presentingSafariView = false
    @State private var showingAlert = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        
//        NavigationView {
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
                .modifier(PrimaryLabel())
                
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Hello"),message: Text("Hello Pressed"), primaryButton: .destructive(Text("Hello Pressed")){
                        //                print("Hello Pressed")
                    }, secondaryButton: .cancel())
                })
                
                let gip = "http://" + FGRoute.getGatewayIP()
                
                //            Link(destination: URL(string: gip)!) {
                //                Text("Router Link")
                //            }
                
//                                Button("Router Link") {
//                                    SafariView(url:URL(string: gip)!)
                //                    openURL(URL(string: gip)!)
                
                //                NavigationLink(destination: WebView(request: URLRequest(url: URL(string: gip)!))) {
                //                        Text("Router Link")
                //                            .modifier(PrimaryLabel())
                //                }
                
//                NavigationLink(destination: SafariView(url:URL(string: gip)!)) {
//                    Text("Router Link")
//                        .modifier(PrimaryLabel())
//                }
                
//                                }
//                                .modifier(PrimaryLabel())
                
                Button(action: {
                    self.presentingSafariView = true
                }) {
                    Text("Router Link")
                }
                .safariView(isPresented: $presentingSafariView) {
                    SafariView(
                        url: URL(string: gip)!,
                        configuration: SafariView.Configuration(
                            entersReaderIfAvailable: false,
                            barCollapsingEnabled: true
                        )
                    )
                    .preferredBarAccentColor(.clear)
                    .preferredControlAccentColor(.accentColor)
                    .dismissButtonStyle(.done)
                }
                
            }
        }
//    }
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
        Text("WiFI: ") +
            Text(FGRoute.isWifiConnected().description.capitalized)
        //        Text("SSID: ") +
        //            Text(FGRoute.getSSID())
        //        Text("BSSID: ") +
        //                    Text(FGRoute.getBSSID())
        //        Text("SSIDDATA: ") +
        //            Text(FGRoute.getSSIDDATA())
        Text("IP Address: ") +
            Text(FGRoute.getIPAddress())
        Text("Router Address: ") +
            Text(FGRoute.getGatewayIP())
        //        }
        //        .padding()
    }
}

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
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
