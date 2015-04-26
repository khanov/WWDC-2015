//
//  AboutViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/19/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var hiPageView: PageView!
    weak var usatuPageView: PageView!
    weak var msumPageView: PageView!
    weak var storyPageView: PageView!
    
    var didSetupConstraints = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.delegate = self
        
        statusBarColor = .Black
        
        appearAnimationCompletionBlock = { _ in
            self.view.backgroundColor = .blackColor()
        }
        
        setupHiPage()
        setupUSATUPage()
        setupMSUMPage()
        setupStoryPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if didSetupConstraints == false {
            setupPageConstraints()
            didSetupConstraints = true
        }
    }
    
    // MARK: - Pages
    
    func setupHiPage() {
        let label = UILabel(pageText: "Hi! My name is Salavat Khanov.\nIt’s nice to meet you.", fontSize: 21)
        
        let hiPageView = createNewPageView()
        self.hiPageView = hiPageView
        hiPageView.addBackgroundImageNamed("Sal-Photo")
        hiPageView.addAndPinMainLabel(label)
    }
    
    func setupUSATUPage() {
        let label = UILabel(pageText: "I'm currently pursuing my Bachelor's degree of Software Engineering at Ufa State Aviation Technical University.")
        
        let usatuPageView = createNewPageView()
        self.usatuPageView = usatuPageView
        usatuPageView.addBackgroundImageNamed("USATU-Photo")
        usatuPageView.addAndPinMainLabel(label, topSpacing: 65)
    }
    
    func setupMSUMPage() {
        let label = UILabel(pageText: "In 2013, I won a scholarship from the US Government to study Computer Science for a semester at Minnesota State University Moorhead.\n\nI was lucky enough to be awarded the Dean's List Certificate.")
        label.textColor = UIColor.whiteColor()
        
        let msumPageView = createNewPageView()
        self.msumPageView = msumPageView
        msumPageView.addBackgroundImageNamed("MSUM-Photo")
        msumPageView.addAndPinMainLabel(label, topSpacing: 65)
    }
    
    func setupStoryPage() {
        let label = UILabel(storyText: "What’s your story?\n\nHere’s mine.\n\nSix years ago, because I liked technology and design and wanted to learn more how to make websites, I decided to create a blog. It was dedicated to the Mac and iPhone.\n\nLater, I got my first iPhone and was fascinated by its camera capabilities and all the apps available to process photos. I thought it would be cool to create another blog — about taking photos on the iPhone — iPhoneography.\n\nSoon, I realized that I was becoming more interested in app development than just writing about them. So I started to learn Objective-C. All the good Objective-C books were in English at the time. For me, that meant I had to work on my English skills first. So I did that.\n\nWhile still learning Objective-C, I needed a little side project to practice Objective-C. That’s how I ended up creating a Mac game like Super Mario. I had never developed games before and knew nothing about it — this was so much fun!\n\nThen something big happened. I won a scholarship to study Computer Science in the US for one semester. Since I had never been abroad, you can imagine how excited I was to visit America!\n\nAfter coming back home from the US, I released my first iOS app on the App Store and landed a job at Lapka as an iOS Developer. The team was located in Moscow, so I worked remotely from my home town. While working at Lapka, I learned many things about iOS development and working for startups. I was pleasently surprised that they were not afraid to give me the freedom of doing whatever I think is best for Lapka, even though I didn’t have a lot of experience.\n\nSoon, WWDC ’14 was announced and Lapka said that I’m going! For a few years, I had been only dreaming of going to WWDC sometime in the future. Who would have thought I’m going in two months?! I couldn’t be more excited.\n\nWWDC '14 was amazing. I have never met so many great iOS and Mac developers in one place. Many of them I knew only from Twitter. I left WWDC very motivated and touched by the Apple community.\n\nI later joined another team, who worked on an app for storing personal documents and other sensitive information like passwords on iOS. This app was featured by Apple and climbed to the #1 place on the Russian App Store.\n\nSo, that was my story. Like Steve Jobs said in his Stanford speech, “You can't connect the dots looking forward; you can only connect them looking backward.” When I was creating my first blog, I didn’t even think it would lead me to this amazing journey.\n\nWhat’s your story? I’d like to hear it at WWDC '15!\n\nThank you.\n\n~ Sal")
        
        let storyPageView = createNewPageView()
        self.storyPageView = storyPageView
        storyPageView.backgroundColor = .blackColor()
        storyPageView.mainLabel = label
        storyPageView.addSubview(label)
        
        storyPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]-20-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        storyPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-45-[label]-45-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        
    }
    
    // MARK: - Constraints
    
    func setupPageConstraints() {

        let pages = [hiPageView, usatuPageView, msumPageView, storyPageView]
        for pageView in pages {
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView]))
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageView(==scrollView)]",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView, "scrollView": scrollView]))
            
            if pageView != storyPageView {
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageView(==scrollView)]",
                    options: NSLayoutFormatOptions.allZeros,
                    metrics: nil,
                    views: ["pageView": pageView, "scrollView": scrollView]))
            }
        }
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[hiView][usatuView][msumView][storyView]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["hiView": hiPageView, "usatuView": usatuPageView, "msumView": msumPageView, "storyView": storyPageView]))
    }
    

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
//            println("bottom")
        }
        
        // White status bar for the MSUM and Story pages
        let whiteTextMode = CGRectIntersectsRect(scrollView.bounds, msumPageView.frame) == true || CGRectIntersectsRect(scrollView.bounds, storyPageView.frame) == true
        statusBarColor = whiteTextMode ? .White : .Black
        navigationItem.rightBarButtonItem?.tintColor = whiteTextMode ? .whiteColor() : .blackColor()
        
        // Disable paged view and hide status bar for the Story text
        var storyRect = storyPageView.frame
        storyRect.origin.y += scrollViewHeight
        let storyTextMode = CGRectIntersectsRect(scrollView.bounds, storyRect)
        scrollView.pagingEnabled = !storyTextMode
        statusBarHidden = storyTextMode
    }
    
}

// MARK: - Helpers

private extension UILabel {
    convenience init(pageText: String, fontSize: CGFloat = 19) {
        self.init(frame: CGRectZero)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        numberOfLines = 0
        text = pageText
        font = UIFont(name: "HelveticaNeue-Light", size: fontSize)
        textColor = UIColor.blackColor()
        sizeToFit()
    }
    convenience init(storyText: String) {
        self.init(frame: CGRectZero)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        numberOfLines = 0
        text = storyText
        font = UIFont(name: "GillSans", size: 18)
        textColor = .whiteColor()
        sizeToFit()
    }
}

private extension AboutViewController {
    func createNewPageView() -> PageView {
        let pageView = PageView()
        pageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageView.clipsToBounds = true
        containerView.addSubview(pageView)
        return pageView
    }
}
