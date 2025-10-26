//
//  YouTubeView.swift
//  MovieApp
//
//
import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let html = """
        <html>
        <body style="margin:0">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?playsinline=1" frameborder="0" allowfullscreen></iframe>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
