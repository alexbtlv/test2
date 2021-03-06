//
//  RecipeImageGalleryView.swift
//  test2
//
//  Created by Alexander Batalov on 3/15/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeImageGalleryView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private var containerView: UIView!
    
    private let cellReuseIdentifier = "ImageCell"
    
    public var imageURLs: [URL] = [] {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RecipeImageGalleryView", owner: self, options: nil)
        
        let cellNib = UINib(nibName: "ImageGaleryCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        containerView.frame = self.bounds
        
        addSubview(containerView)
        containerView.bringSubviewToFront(pageControl)
    }

    private func reloadData() {
        pageControl.numberOfPages = imageURLs.count
        collectionView.reloadData()
    }
    
    @IBAction func pageControlValueDidChange(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
}

// MARK: Collection View Data Source

extension RecipeImageGalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageGaleryCollectionViewCell else {
            preconditionFailure("Can not cast collection view cell as ImageGaleryCollectionViewCell")
        }
        cell.imageView.kf.setImage(with: imageURLs[indexPath.row], placeholder: UIImage(named: "food"))
    }
}

// MARK: Collection View Flow Layout

extension RecipeImageGalleryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return containerView.frame.size
    }
}

// MARK: Scroll View Methods

extension RecipeImageGalleryView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
