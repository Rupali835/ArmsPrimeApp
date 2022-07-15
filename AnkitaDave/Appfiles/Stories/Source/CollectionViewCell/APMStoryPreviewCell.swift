//
//  APMStoryPreviewCell.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit
import AVKit

protocol StoryPreviewProtocol: class {
    func didCompletePreview()
    func didTapCloseButton()
    func didTapPromotionButton(index: Int)
}
enum SnapMovementDirectionState {
    case forward
    case backward
}
//Identifiers
fileprivate let snapViewTagIndicator: Int = 8

final class APMStoryPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    //MARK: - Delegate
    public weak var delegate: StoryPreviewProtocol? {
        didSet { storyHeaderView.delegate = self }
    }
    
    //MARK:- Private iVars
    private lazy var storyHeaderView: APMStoryPreviewHeaderView = {
        let v = APMStoryPreviewHeaderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var longPress_gesture: UILongPressGestureRecognizer = {
        let lp = UILongPressGestureRecognizer.init(target: self, action: #selector(didLongPress(_:)))
        lp.minimumPressDuration = 0.2
        lp.delegate = self
        return lp
    }()
    private lazy var tap_gesture: UITapGestureRecognizer = {
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTapSnap(_:)))
        tg.cancelsTouchesInView = false;
        tg.numberOfTapsRequired = 1
        tg.delegate = self
        return tg
    }()
    private var previousSnapIndex: Int {
        return snapIndex - 1
    }
    private var snapViewXPos: CGFloat {
        return (snapIndex == 0) ? 0 : scrollview.subviews[previousSnapIndex].frame.maxX
    }
    private var videoSnapIndex: Int = 0
    
    var retryBtn: APMRetryLoaderButton!
    var longPressGestureState: UILongPressGestureRecognizer.State?
    
    //MARK:- Public iVars
    public var direction: SnapMovementDirectionState = .forward
    public let scrollview: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.isScrollEnabled = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    public var getSnapIndex: Int {
        return snapIndex
    }
    public var snapIndex: Int = 0 {
        didSet {
            scrollview.isUserInteractionEnabled = true
            
            if let story = self.story,
                let snaps = story.snaps {
                
                let snapsCount = snaps.count
                
                switch direction {
                case .forward:
                    if snapIndex < snapsCount {
                        if snaps[snapIndex].kind != MimeType.video {
                            if let url = snaps[snapIndex].photo?.url {
                                if let snapView = getSnapview() {
                                    startRequest(snapView: snapView, with: url)
                                } else {
                                    let snapView = createSnapView()
                                    startRequest(snapView: snapView, with: url)
                                }
                            }
                        } else {
                            if let url = snaps[snapIndex].video?.url {
                                if let videoView = getVideoView(with: snapIndex) {
                                    startPlayer(videoView: videoView, with: url)
                                } else {
                                    let videoView = createVideoView()
                                    startPlayer(videoView: videoView, with: url)
                                }
                            }
                        }
                    }
                case .backward:
                    if snapIndex < snapsCount {
                        if snaps[snapIndex].kind != MimeType.video {
                            if let snapView = getSnapview(),
                                let url = snaps[snapIndex].photo?.url {
                                self.startRequest(snapView: snapView, with: url)
                            }
                        } else {
                            if let url = snaps[snapIndex].video?.url {
                                if let videoView = getVideoView(with: snapIndex) {
                                    startPlayer(videoView: videoView, with: url)
                                } else {
                                    let videoView = self.createVideoView()
                                    self.startPlayer(videoView: videoView, with: url)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    public var story: APMStory? {
        didSet {
            storyHeaderView.story = story
        }
    }
    
    //MARK: - Overriden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollview.frame = bounds
        loadUIElements()
        installLayoutConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        direction = .forward
        clearScrollViewGarbages()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private functions
    private func loadUIElements() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        scrollview.delegate = self
        scrollview.isPagingEnabled = true
        scrollview.backgroundColor = .clear
        contentView.addSubview(scrollview)
        contentView.addSubview(storyHeaderView)
        scrollview.addGestureRecognizer(longPress_gesture)
        scrollview.addGestureRecognizer(tap_gesture)
    }
    private func installLayoutConstraints() {
        //Setting constraints for scrollview
        NSLayoutConstraint.activate([
            scrollview.igLeftAnchor.constraint(equalTo: contentView.igLeftAnchor),
            contentView.igRightAnchor.constraint(equalTo: scrollview.igRightAnchor),
            scrollview.igTopAnchor.constraint(equalTo: contentView.igTopAnchor),
            contentView.igBottomAnchor.constraint(equalTo: scrollview.igBottomAnchor),
            scrollview.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            scrollview.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0)
        ])
        NSLayoutConstraint.activate([
            storyHeaderView.igLeftAnchor.constraint(equalTo: contentView.igLeftAnchor),
            contentView.igRightAnchor.constraint(equalTo: storyHeaderView.igRightAnchor),
            storyHeaderView.igTopAnchor.constraint(equalTo: contentView.igTopAnchor),
            storyHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    private func createSnapView() -> UIImageView {
        let snapView = UIImageView()
        snapView.translatesAutoresizingMaskIntoConstraints = false
        snapView.contentMode = .scaleAspectFit
        snapView.backgroundColor = .clear
        snapView.tag = snapIndex + snapViewTagIndicator
        scrollview.addSubview(snapView)
  
        let promotionButton = UIButton()
        promotionButton.translatesAutoresizingMaskIntoConstraints = false
        promotionButton.backgroundColor = .red
        promotionButton.layer.cornerRadius = 10
        promotionButton.tag = snapIndex
        promotionButton.isUserInteractionEnabled = true
        promotionButton.isHidden = true
        promotionButton.addTarget(self, action: #selector(didTapPromotionButton(_:)), for: .touchUpInside)
        
        if let story = self.story,
            let snaps = story.snaps {
            if let title = snaps[snapIndex].webview_label {
                if title != "" {
                    promotionButton.isHidden = false
                    promotionButton.setTitle(title, for: .normal)
                }
            }
        }
        
        self.isUserInteractionEnabled = true
        scrollview.addSubview(promotionButton)
        
        var previousIndex = previousSnapIndex
        
        if previousIndex != 0 {
            previousIndex += snapIndex - 1
        }

        // Setting constraints for snap view.
        NSLayoutConstraint.activate([
            snapView.leadingAnchor.constraint(equalTo: (snapIndex == 0) ? scrollview.leadingAnchor : scrollview.subviews[previousIndex].trailingAnchor),
            snapView.igTopAnchor.constraint(equalTo: scrollview.igTopAnchor),
            snapView.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            snapView.heightAnchor.constraint(equalTo: scrollview.heightAnchor),
            scrollview.igBottomAnchor.constraint(equalTo: snapView.igBottomAnchor)
        ])
        
        //Setting constraints for promotionButton
        NSLayoutConstraint.activate([
            promotionButton.igCenterXAnchor.constraint(equalTo: snapView.igCenterXAnchor),
            promotionButton.igBottomAnchor.constraint(equalTo: scrollview.igBottomAnchor, constant: -10),
            promotionButton.widthAnchor.constraint(equalToConstant: 180),
            promotionButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        return snapView
    }
    private func getSnapview() -> UIImageView? {
        if let imageView = scrollview.subviews.filter({$0.tag == snapIndex + snapViewTagIndicator}).first as? UIImageView {
            return imageView
        }
        return nil
    }
    private func createVideoView() -> APMPlayerView {
        let videoView = APMPlayerView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = .clear
        videoView.tag = snapIndex + snapViewTagIndicator
        videoView.playerObserverDelegate = self
        scrollview.addSubview(videoView)
        
        let promotionButton = UIButton()
        promotionButton.translatesAutoresizingMaskIntoConstraints = false
        promotionButton.backgroundColor = .red
        promotionButton.layer.cornerRadius = 10
        promotionButton.tag = snapIndex
        promotionButton.isUserInteractionEnabled = true
        promotionButton.isHidden = true
        promotionButton.addTarget(self, action: #selector(didTapPromotionButton(_:)), for: .touchUpInside)
        
        if let story = self.story,
            let snaps = story.snaps {
            if let title = snaps[snapIndex].webview_label {
                if title != "" {
                    promotionButton.isHidden = false
                    promotionButton.setTitle(title, for: .normal)
                }
            }
        }
        
        self.isUserInteractionEnabled = true
        scrollview.addSubview(promotionButton)
        
        var previousIndex = previousSnapIndex
        
        if previousIndex != 0 {
            previousIndex += snapIndex - 1
        }
        
        // Setting constraints for video view.
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: (snapIndex == 0) ? scrollview.leadingAnchor : scrollview.subviews[previousIndex].trailingAnchor),
            videoView.igTopAnchor.constraint(equalTo: scrollview.igTopAnchor),
            videoView.widthAnchor.constraint(equalTo: scrollview.widthAnchor),
            videoView.heightAnchor.constraint(equalTo: scrollview.heightAnchor),
            scrollview.igBottomAnchor.constraint(equalTo: videoView.igBottomAnchor)
        ])
        
        //Setting constraints for promotionButton
        NSLayoutConstraint.activate([
            promotionButton.igCenterXAnchor.constraint(equalTo: videoView.igCenterXAnchor),
            promotionButton.igBottomAnchor.constraint(equalTo: scrollview.igBottomAnchor, constant: -10),
            promotionButton.widthAnchor.constraint(equalToConstant: 180),
            promotionButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        return videoView
    }
    private func getVideoView(with index: Int) -> APMPlayerView? {
        if let videoView = scrollview.subviews.filter({$0.tag == index + snapViewTagIndicator}).first as? APMPlayerView {
            return videoView
        }
        return nil
    }
    private func startRequest(snapView: UIImageView, with url: String) {
        snapView.setImage(url: url, style: .squared) { [weak self] (result) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(_):
                        strongSelf.startProgressors()
                    case .failure(_):
                        strongSelf.showRetryButton(with: url, for: snapView)
                }
            }
        }
    }
    private func showRetryButton(with url: String, for snapView: UIImageView) {
        self.retryBtn = APMRetryLoaderButton.init(withURL: url)
        self.retryBtn.translatesAutoresizingMaskIntoConstraints = false
        self.retryBtn.delegate = self
        self.isUserInteractionEnabled = true
        snapView.addSubview(self.retryBtn)
        NSLayoutConstraint.activate([
            self.retryBtn.igCenterXAnchor.constraint(equalTo: snapView.igCenterXAnchor),
            self.retryBtn.igCenterYAnchor.constraint(equalTo: snapView.igCenterYAnchor)
        ])
    }
    private func startPlayer(videoView: APMPlayerView, with url: String) {
        if scrollview.subviews.count > 0 {
            if story?.isCompletelyVisible == true {
                videoView.startAnimating()
                let videoResource = VideoResource(filePath: url)
                videoView.play(with: videoResource)
            }
        }
    }
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        longPressGestureState = sender.state
        if sender.state == .began ||  sender.state == .ended {
            if (sender.state == .began) {
                pauseEntireSnap()
            } else {
                resumeEntireSnap()
            }
        }
    }
    @objc private func didTapSnap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: self.scrollview)
        
        if let snapCount = story?.snaps?.count {
            var n = snapIndex
            /*!
             * Based on the tap gesture(X) setting the direction to either forward or backward
             */
            if let snap = story?.snaps?[n], snap.kind == .photo, getSnapview()?.image == nil {
                //Remove retry button if tap forward or backward if it exists
                if let snapView = getSnapview(), let btn = retryBtn, snapView.subviews.contains(btn) {
                    snapView.removeRetryButton()
                }
                fillupLastPlayedSnap(n)
            } else {
                //Remove retry button if tap forward or backward if it exists
                if let videoView = getVideoView(with: n), let btn = retryBtn, videoView.subviews.contains(btn) {
                    videoView.removeRetryButton()
                }
                if getVideoView(with: n)?.player?.timeControlStatus != .playing {
                    fillupLastPlayedSnap(n)
                }
            }
            if touchLocation.x < scrollview.contentOffset.x + (scrollview.frame.width/2) {
                direction = .backward
                if snapIndex >= 1 && snapIndex <= snapCount {
                    clearLastPlayedSnaps(n)
                    stopSnapProgressors(with: n)
                    n -= 1
                    resetSnapProgressors(with: n)
                    willMoveToPreviousOrNextSnap(n: n)
                }
            } else {
                if snapIndex >= 0 && snapIndex <= snapCount {
                    //Stopping the current running progressors
                    stopSnapProgressors(with: n)
                    direction = .forward
                    n += 1
                    willMoveToPreviousOrNextSnap(n: n)
                }
            }
        }
    }
    @objc private func didEnterForeground() {
        if let snap = story?.snaps?[snapIndex] {
            if snap.kind == .video {
                if let url = snap.video?.url {
                    let videoView = getVideoView(with: snapIndex)
                    startPlayer(videoView: videoView!, with: url)
                }
            } else {
                startSnapProgress(with: snapIndex)
            }
        }
    }
    @objc private func didEnterBackground() {
        if let snap = story?.snaps?[snapIndex] {
            if snap.kind == .video {
                stopPlayer()
            }
        }
        resetSnapProgressors(with: snapIndex)
    }
    private func willMoveToPreviousOrNextSnap(n: Int) {
        if let count = story?.snaps?.count {
            if n < count {
                //Move to next or previous snap based on index n
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                scrollview.setContentOffset(offset, animated: false)
                story?.lastPlayedSnapIndex = n
                snapIndex = n
            } else {
                delegate?.didCompletePreview()
            }
        }
    }
    @objc private func didCompleteProgress() {
        let n = snapIndex + 1
        if let count = story?.snaps?.count {
            if n < count {
                //Move to next snap
                let x = n.toFloat * frame.width
                let offset = CGPoint(x: x,y: 0)
                scrollview.setContentOffset(offset, animated: false)
                story?.lastPlayedSnapIndex = n
                direction = .forward
                snapIndex = n
            } else {
                stopPlayer()
                delegate?.didCompletePreview()
            }
        }
    }
    private func fillUpMissingImageViews(_ sIndex: Int) {
        if sIndex != 0 {
            for i in 0..<sIndex {
                snapIndex = i
            }
            let xValue = sIndex.toFloat * scrollview.frame.width
            scrollview.contentOffset = CGPoint(x: xValue, y: 0)
        }
    }
    //Before progress view starts we have to fill the progressView
    private func fillupLastPlayedSnap(_ sIndex: Int) {
        if let snap = story?.snaps?[sIndex], snap.kind == .video {
            videoSnapIndex = sIndex
            stopPlayer()
        }
        if let holderView = self.getProgressIndicatorView(with: sIndex),
            let progressView = self.getProgressView(with: sIndex) {
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
            progressView.widthConstraint?.isActive = true
        }
    }
    private func fillupLastPlayedSnaps(_ sIndex: Int) {
        //Coz, we are ignoring the first.snap
        if sIndex != 0 {
            for i in 0..<sIndex {
                if let holderView = self.getProgressIndicatorView(with: i),
                    let progressView = self.getProgressView(with: i) {
                    progressView.widthConstraint?.isActive = false
                    progressView.widthConstraint = progressView.widthAnchor.constraint(equalTo: holderView.widthAnchor, multiplier: 1.0)
                    progressView.widthConstraint?.isActive = true
                }
            }
        }
    }
    private func clearLastPlayedSnaps(_ sIndex: Int) {
        if let _ = self.getProgressIndicatorView(with: sIndex),
            let progressView = self.getProgressView(with: sIndex) {
            progressView.widthConstraint?.isActive = false
            progressView.widthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
            progressView.widthConstraint?.isActive = true
        }
    }
    private func clearScrollViewGarbages() {
        scrollview.contentOffset = CGPoint(x: 0, y: 0)
        if scrollview.subviews.count > 0 {
            var i = 0 + snapViewTagIndicator
            var snapViews = [UIView]()
            scrollview.subviews.forEach({ (imageView) in
                if imageView.tag == i {
                    snapViews.append(imageView)
                    i += 1
                }
            })
            if snapViews.count > 0 {
                snapViews.forEach({ (view) in
                    view.removeFromSuperview()
                })
            }
        }
    }
    private func gearupTheProgressors(type: MimeType, playerView: APMPlayerView? = nil) {
        if let holderView = getProgressIndicatorView(with: snapIndex),
            let progressView = getProgressView(with: snapIndex) {
            progressView.story_identifier = self.story?.internalIdentifier
            progressView.snapIndex = snapIndex
            DispatchQueue.main.async {
                if type == .photo {
                    progressView.start(with: 5.0, holderView: holderView, completion: { (identifier, snapIndex, isCancelledAbruptly) in
                        if isCancelledAbruptly == false {
                            self.didCompleteProgress()
                        }
                    })
                } else {
                    //Handled in delegate methods for videos
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func didTapPromotionButton(_ sender: UIButton) {
        delegate?.didTapPromotionButton(index: sender.tag)
    }
    
    //MARK:- Internal functions
    func startProgressors() {
        DispatchQueue.main.async {
            if self.scrollview.subviews.count > 0 {
                let imageView = self.scrollview.subviews.filter{ v in v.tag == self.snapIndex + snapViewTagIndicator}.first as? UIImageView
                if imageView?.image != nil && self.story?.isCompletelyVisible == true {
                    self.gearupTheProgressors(type: .photo)
                } else {
                    // Didend displaying will call this startProgressors method. After that only isCompletelyVisible get true. Then we have to start the video if that snap contains video.
                    if self.story?.isCompletelyVisible == true {
                        let videoView = self.scrollview.subviews.filter{v in v.tag == self.snapIndex + snapViewTagIndicator}.first as? APMPlayerView
                        if let snap = self.story?.snaps?[self.snapIndex],
                            let vv = videoView, self.story?.isCompletelyVisible == true,
                            let url = snap.video?.url {
                            self.startPlayer(videoView: vv, with: url)
                        }
                    }
                }
            }
        }
    }
    func getProgressView(with index: Int) -> APMSnapProgressView? {
        let progressView = storyHeaderView.getProgressView
        if progressView.subviews.count > 0 {
            let pv = getProgressIndicatorView(with: index)?.subviews.first as? APMSnapProgressView
            guard let currentStory = self.story else {
                fatalError("story not found")
            }
            pv?.story = currentStory
            return pv
        }
        return nil
    }
    func getProgressIndicatorView(with index: Int) -> UIView? {
        let progressView = storyHeaderView.getProgressView
        return progressView.subviews.filter( { v in v.tag == index+progressIndicatorViewTag }).first ?? nil
    }
    func adjustPreviousSnapProgressorsWidth(with index: Int) {
        fillupLastPlayedSnaps(index)
    }
    //MARK: - Public functions
    public func willDisplayCellForZerothIndex(with sIndex: Int) {
        story?.isCompletelyVisible = true
        willDisplayCell(with: sIndex)
    }
    public func willDisplayCell(with sIndex: Int) {
        //Todo:Make sure to move filling part and creating at one place
        //Clear the progressor subviews before the creating new set of progressors.
        storyHeaderView.clearTheProgressorSubviews()
        storyHeaderView.createSnapProgressors()
        fillUpMissingImageViews(sIndex)
        fillupLastPlayedSnaps(sIndex)
        snapIndex = sIndex
        
        //Remove the previous observors
        NotificationCenter.default.removeObserver(self)
        
        // Add the observer to handle application from background to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    public func startSnapProgress(with sIndex: Int) {
        if let indicatorView = getProgressIndicatorView(with: sIndex),
            let pv = getProgressView(with: sIndex) {
            pv.start(with: 5.0, holderView: indicatorView, completion: { (identifier, snapIndex, isCancelledAbruptly) in
                if isCancelledAbruptly == false {
                    self.didCompleteProgress()
                }
            })
        }
    }
    public func pauseSnapProgressors(with sIndex: Int) {
        story?.isCompletelyVisible = false
        getProgressView(with: sIndex)?.pause()
    }
    public func stopSnapProgressors(with sIndex: Int) {
        getProgressView(with: sIndex)?.stop()
    }
    public func resetSnapProgressors(with sIndex: Int) {
        self.getProgressView(with: sIndex)?.reset()
    }
    public func pausePlayer(with sIndex: Int) {
        getVideoView(with: sIndex)?.pause()
    }
    public func stopPlayer() {
        let videoView = getVideoView(with: videoSnapIndex)
        if videoView?.player?.timeControlStatus != .playing {
            getVideoView(with: videoSnapIndex)?.player?.replaceCurrentItem(with: nil)
        }
        videoView?.stop()
        //getVideoView(with: videoSnapIndex)?.player = nil
    }
    public func resumePlayer(with sIndex: Int) {
        getVideoView(with: sIndex)?.play()
    }
    public func didEndDisplayingCell() {
        
    }
    public func resumePreviousSnapProgress(with sIndex: Int) {
        getProgressView(with: sIndex)?.resume()
    }
    public func pauseEntireSnap() {
        let v = getProgressView(with: snapIndex)
        let videoView = scrollview.subviews.filter{v in v.tag == snapIndex + snapViewTagIndicator}.first as? APMPlayerView
        if videoView != nil {
            v?.pause()
            videoView?.pause()
        } else {
            v?.pause()
        }
    }
    public func resumeEntireSnap() {
        let v = getProgressView(with: snapIndex)
        let videoView = scrollview.subviews.filter{v in v.tag == snapIndex + snapViewTagIndicator}.first as? APMPlayerView
        if videoView != nil {
            v?.resume()
            videoView?.play()
        } else {
            v?.resume()
        }
    }
    //Used the below function for image retry option
    public func retryRequest(view: UIView, with url: String) {
        if let v = view as? UIImageView {
            v.removeRetryButton()
            self.startRequest(snapView: v, with: url)
        } else if let v = view as? APMPlayerView {
            v.removeRetryButton()
            self.startPlayer(videoView: v, with: url)
        }
    }
}

//MARK: - Extension|StoryPreviewHeaderProtocol
extension APMStoryPreviewCell: StoryPreviewHeaderProtocol {
    func didTapCloseButton() {
        delegate?.didTapCloseButton()
    }
}

//MARK: - Extension|RetryBtnDelegate
extension APMStoryPreviewCell: RetryBtnDelegate {
    func retryButtonTapped() {
        self.retryRequest(view: retryBtn.superview!, with: retryBtn.contentURL!)
    }
}

//MARK: - Extension|APMPlayerObserverDelegate
extension APMStoryPreviewCell: APMPlayerObserver {
    
    func didStartPlaying() {
        
        if let videoView = getVideoView(with: snapIndex), videoView.currentTime <= 0.0 {
            if let story = self.story {
                if videoView.error == nil && story.isCompletelyVisible == true {
                    if let holderView = getProgressIndicatorView(with: snapIndex),
                        let progressView = getProgressView(with: snapIndex) {
                        progressView.story_identifier = story.internalIdentifier
                        progressView.snapIndex = snapIndex
                        if let duration = videoView.currentItem?.asset.duration {
                            if Float(duration.value) > 0 {
                                progressView.start(with: duration.seconds, holderView: holderView, completion: {(identifier, snapIndex, isCancelledAbruptly) in
                                    if isCancelledAbruptly == false {
                                        self.videoSnapIndex = snapIndex
                                        self.stopPlayer()
                                        self.didCompleteProgress()
                                    } else {
                                        self.videoSnapIndex = snapIndex
                                        self.stopPlayer()
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    func didFailed(withError error: String, for url: URL?) {
        debugPrint("Failed with error: \(error)")
        if let videoView = getVideoView(with: snapIndex), let videoURL = url {
            self.retryBtn = APMRetryLoaderButton(withURL: videoURL.absoluteString)
            self.retryBtn.translatesAutoresizingMaskIntoConstraints = false
            self.retryBtn.delegate = self
            self.isUserInteractionEnabled = true
            videoView.addSubview(self.retryBtn)
            NSLayoutConstraint.activate([
                self.retryBtn.igCenterXAnchor.constraint(equalTo: videoView.igCenterXAnchor),
                self.retryBtn.igCenterYAnchor.constraint(equalTo: videoView.igCenterYAnchor)
            ])
        }
    }
    func didCompletePlay() {
        //Video completed
    }
    
    func didTrack(progress: Float) {
        //Delegate already handled. If we just print progress, it will print the player current running time
    }
}

extension APMStoryPreviewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UISwipeGestureRecognizer) {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let _ = touch.view as? UIButton { return false }
        return true
    }
}
