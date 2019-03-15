//
//  RecipeImageGalleryView.swift
//  test2
//
//  Created by Alexander Batalov on 3/15/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class RecipeImageGalleryView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var containerView: UIView!
    
    var images: [String]? {
        didSet {
            reloadData()
        }
    }
    private let cellReuseIdentifier = "ImageCell"
    private var URLs: [URL] {
        guard let images = images else { return [] }
        let possibles = images.map { URL(string: $0) }
        return possibles.compactMap { $0 }
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
        
        collectionView.register(UINib(nibName: "ImageGaleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageControl.hidesForSinglePage = true
        
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        containerView.bringSubviewToFront(pageControl)
        addSubview(containerView)
    }

    private func reloadData() {
        pageControl.numberOfPages = URLs.count
        collectionView.reloadData()
    }
}

extension RecipeImageGalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return URLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageGaleryCollectionViewCell else {
            preconditionFailure("Can not cast collection view cell as ImageGaleryCollectionViewCell")
        }
        cell.imageView.kf.setImage(with: URLs[indexPath.row])
    }
}


extension RecipeImageGalleryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return containerView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
