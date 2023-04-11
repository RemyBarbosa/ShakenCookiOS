//
//  DiskCacheImageLoader.swift
//  Shake'n'Cook
//
//  Created by rémy barbosa on 19/03/2023.
//

import Foundation
import Combine
import SwiftUI

class DiskCachedImageLoader: ObservableObject {
    private static let cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "image_cache")
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        let request = URLRequest(url: url)
        if let cachedResponse = DiskCachedImageLoader.cache.cachedResponse(for: request), let image = UIImage(data: cachedResponse.data) {
            return Just(image).eraseToAnyPublisher()
        } else {
            let publisher = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, response -> UIImage? in
                    let cachedData = CachedURLResponse(response: response, data: data)
                    DiskCachedImageLoader.cache.storeCachedResponse(cachedData, for: request)
                    return UIImage(data: data)
                }
                .catch { _ in
                    Just(nil)
                }
                .eraseToAnyPublisher()
            
            cancellable = publisher.sink { _ in } receiveValue: { _ in }
            
            return publisher
        }
    }
}
