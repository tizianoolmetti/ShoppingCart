//
//  ImageUrl.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct ImageUrl: View {
    private let urlString: String
    @State private var image: UIImage?
    
    init(_ urlString: String) {
        self.urlString = urlString
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                    )
                    .onAppear(perform: loadImage)
            }
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}
