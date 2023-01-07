//
//  TapticEngine.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 07.01.2023.
//

import UIKit

func createTapticFeedback(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let taptic = UIImpactFeedbackGenerator(style: style)
    taptic.impactOccurred()
}
