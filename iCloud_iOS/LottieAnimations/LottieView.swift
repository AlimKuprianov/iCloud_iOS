//
//  LottieView.swift
//  iCloud_iOS
//
//  Created by Алим Куприянов on 16.09.2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    typealias UIViewType = UIView

    private let fileName: String
    private let animationSpeed: CGFloat
    private let repeating: Bool

    init(fileName: String, animationSpeed: CGFloat = 1, repeating: Bool = true) {
        self.fileName = fileName
        self.animationSpeed = animationSpeed
        self.repeating = repeating
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = AnimationView()
        animationView.animation = Animation.named(fileName)
        animationView.contentMode = .scaleToFill
        animationView.loopMode = repeating ? .loop : .playOnce
        animationView.play()
        animationView.animationSpeed = animationSpeed

        view.addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
