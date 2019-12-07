//
//  URLImage.swift
//
//  Created by Takuya Yokoyama on 2019/10/27.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import Combine

public struct URLImage<Content>: View where Content: View {
    
    @ObservedObject private var downloader: ImageDownloader
    
    private let contentBuilder: ((Image) -> Content)?
    private let placeholder = Image(uiImage: UIImage(systemName: "photo")!)
    
    public init(url: URL, contentBuilder: ((Image) -> Content)?) {
        self.downloader = ImageDownloader(url: url)
        self.contentBuilder = contentBuilder
    }
    
    public init(urlString: String, contentBuilder: ((Image) -> Content)?) {
        self.downloader = ImageDownloader(urlString: urlString)
        self.contentBuilder = contentBuilder
    }
    
    public var body: some View {
        Group {
            if downloader.downloadedImage != nil {
                contentBuilder?(Image(uiImage: downloader.downloadedImage!))
            } else {
                placeholder
                    .onAppear { self.downloader.load() }
                    .onDisappear { self.downloader.cancel() }
            }
        }
    }
}

struct URLImage_Previews: PreviewProvider {
    static var previews: some View {
        URLImage(urlString: "https://picsum.photos/300") { (image: Image) in
            image.resizable()
        }
    }
}

public final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<AnyObject, AnyObject>()
    
    private init() {}
    
    public func set(_ image: UIImage, with url: URL) {
        cache.setObject(image, forKey: url as AnyObject)
    }
    
    public func get(_ url: URL) -> UIImage? {
        cache.object(forKey: url as AnyObject) as? UIImage
    }
}

public class ImageDownloader: ObservableObject, Identifiable {
    
    private let url: URL
    
    @Published var downloadedImage: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    
    public init(url: URL) {
        self.url = url
        downloadedImage = ImageCache.shared.get(url)
    }
    
    convenience init(urlString: String) {
        self.init(url: URL(string: urlString)!)
    }
    
    deinit {
        cancel()
    }
    
    public func load() {
        NetworkPublisher.publish(URLRequest(url: url))
            .compactMap { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    guard let self = self else { return }
                    self.downloadedImage = image
                    ImageCache.shared.set(image, with: self.url)
                }
            )
            .store(in: &cancellables)
    }
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
    }
}
