//
//  ViewController.swift
//  WeateherAppSwift
//
//  Created by Максим Чижавко on 30/09/2019.
//  Copyright © 2019 Максим Чижавко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var screenWidth = view.bounds.size.width;
    lazy var screenHeight = view.bounds.size.height;
    let footerHeight = 0;
    let maskStartingY = 270;  // Distance between top of scrolling content and top of screen
    let maskMaxTravellingDistance = 80; // Distance the mask can move upwards before its content starts scrolling and gets clipped
    
    var header = UILabel()
    var mask = UIView()
    var content = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Settings
            
            
            
        self.view.backgroundColor = .red // light blue
            
            
            
            // Header. This will change size and postion as the scrollview scrolls
        header = UILabel(frame: CGRect(x: 100, y: 100, width: screenWidth - 200, height: 100))
        header.text = "Header";
        header.font = UIFont(name: "Helvetic", size: 30)
        header.textAlignment = .center
        self.view.addSubview(header)
        
        
        // Scrollview

        let scrollView = UIScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)



        // Mask

        let maskFrame = CGRect(x: 0, y: maskStartingY, width: Int(screenWidth), height: Int(screenHeight) - maskStartingY - footerHeight)
        mask = UIView(frame: maskFrame)
        mask.clipsToBounds = true // important
        scrollView.addSubview(mask)



        // Scrollable content

        content = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 1.5))
        content.backgroundColor = UIColor.lightGray

        // Create some dummy content. 14 red bars that vertically fill the content container
        for i in 0..<14 {
            let bar = UILabel(frame: CGRect(x: 20, y: CGFloat(0 + 52 * i), width: screenWidth - 40, height: 45))
            bar.text = String(format: "bar no. %i", i + 1)
            content.addSubview(bar)
        }

        mask.addSubview(content)

        
        
        
        // Set scrollview size to 1.5x the screen height for this example
        
        scrollView.contentSize = CGSize(width: screenWidth, height: (screenHeight * 1.5) + CGFloat(footerHeight));
        
        
        
    }


}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // MOVING THE MASK
        //
        // Here we prevent the mask from moving as the scollview scrolls. There are two phases of motion:
        //
        // 1.
        // At first, we want the top of the mask to move upwards as the user starts scrolling, while the bottom of
        // the mask stays anchored to the top of the footer. This means the mask's height increases at the same
        // speed that it moves upwards. During this phase, the mask appears to be stretching upwards.
        //
        //
        // 2.
        // Then when the mask reaches the threshold (self.maskMaxTravellingDistance), the top of the mask
        // stops moveing upwards with the scroll and the mask stops increasing in height. It is then completely
        // stationary with respect to the screen.
        
        let offsetY = scrollView.contentOffset.y;
        
        let newMaskHeight: CGFloat
        let newMaskY: CGFloat
        let newMaskFrame: CGRect
        
        if (offsetY < CGFloat(maskMaxTravellingDistance)) {
            
            // Motion phase 1
            
            newMaskHeight = CGFloat(screenHeight - CGFloat(maskStartingY) - CGFloat(footerHeight)) + offsetY;
            newMaskY = CGFloat(maskStartingY);
            newMaskFrame = CGRect(x: 0, y: newMaskY, width: self.screenWidth, height: newMaskHeight);
            
        } else {
            
            // Motion phase 2

            newMaskHeight = screenHeight - CGFloat(maskStartingY) - CGFloat(footerHeight) + CGFloat(maskMaxTravellingDistance);
            newMaskY =  CGFloat(maskStartingY - maskMaxTravellingDistance) + offsetY;
            newMaskFrame = CGRect(x: 0, y: newMaskY, width: self.screenWidth, height: newMaskHeight);
            
        }
        
        mask.frame = newMaskFrame;
        
        
        
        
        // MOVING THE CONTENT
        //
        // Because our content container is a subview of the mask, it means that the content view is
        // also fixed to the screen along with the mask. To counteract this, we have to do the opposite to what we
        // did to the mask (above).
        //
        // But we only have to apply this counteractive measure when the scrollview is in the second phase of
        // motion, i.e. after the mask has stopped moving upwards and has become fully static with relative to the
        // screen.
        
        let newContentY: CGFloat
        let newContentFrame: CGRect
        
        if (Int(offsetY) < self.maskMaxTravellingDistance) {
            
            // Motion phase 1
            
            // We make sure the frame is set correctly to stop the top of the content from occasionally being clipped by the mask when
            // the user has scrolled too fast.
            
            newContentFrame = CGRect(x: 0, y: 0, width: self.screenWidth , height: self.screenHeight * 1.5);
            content.frame = newContentFrame;
            
        } else {
            
            // Motion phase 2
            
            // Once the mask is fixed to the screen, ensure that its content subview can still scroll
            
            newContentY = CGFloat(self.maskMaxTravellingDistance) - offsetY;
            newContentFrame = CGRect(x: 0, y: newContentY, width: self.screenWidth , height: self.screenHeight * 1.5);
            self.content.frame = newContentFrame;
            
        }
        
        
        // MOVING THE HEADER
        //
        // In this example, the header is going to move upwards and fade out as the user scrolls.
        // The to achieve this effect, we must map the header's origin.y to the amount that the
        // scrollview has scrolled
        
        let newHeaderFrame: CGRect
        let newHeaderY: CGFloat
        
        if (Int(offsetY) <= self.maskMaxTravellingDistance) {
            
            newHeaderY = 100 - (offsetY * 0.5); // move at half the speed of scroll
            newHeaderFrame = CGRect(x: header.frame.origin.x, y: newHeaderY, width: self.header.frame.size.width, height: self.header.frame.size.height);
            header.frame = newHeaderFrame;
            
        } else {
            
            newHeaderY = CGFloat(100 - (Double(maskMaxTravellingDistance) * 0.5));
            newHeaderFrame = CGRect(x: self.header.frame.origin.x, y: newHeaderY, width: self.header.frame.size.width, height: self.header.frame.size.height);
            self.header.frame = newHeaderFrame;

        }
        
        
        
        
        
        
    }
}
