//
//  StarRatingViewController.swift
//  VKCupDzenInteractive
//
//  Created by Павел Кай on 05.01.2023.
//

import UIKit

final class StarRatingViewController: UIViewController {
    
    private var rating = 1 {
        didSet {
            updateStarsRating()
        }
    }
    
    lazy var starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(starsStackView)
        setStars()
        setConstraints()
        
        view.backgroundColor = .systemBackground
    }
    
    private func setStars() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapStar(_:)))
            imageView.addGestureRecognizer(gesture)
            imageView.isUserInteractionEnabled = true
            
            starsStackView.addArrangedSubview(imageView)
        }
        updateStarsRating()
    }
    
    private func updateStarsRating() {
        for (index, image) in starsStackView.arrangedSubviews.enumerated() {
            let star = image as! UIImageView
            
            if index < rating {
                star.animateScale(with: 1.35)
                star.image = createStarImage(with: "star.fill")
            } else {
                star.image = createStarImage(with: "star")
            }
        }
    }
    
    private func createStarImage(with sfsymbol: String) -> UIImage {
        var image = UIImage(systemName: sfsymbol) ?? UIImage(systemName: "xmark")!
        let config = UIImage.SymbolConfiguration(scale: .large)
        
        image = image.withConfiguration(config)
        image = image.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        return image
    }
    
}

private extension StarRatingViewController {
    
    @objc func didTapStar(_ sender: UITapGestureRecognizer) {
        guard let tappedStar = sender.view else { return }
        
        createTapticFeedback(with: .soft)
        
        if let tappedStarIndex = starsStackView.arrangedSubviews.firstIndex(of: tappedStar) {
            rating = tappedStarIndex + 1
        }
    }
    
}

private extension StarRatingViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            starsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
