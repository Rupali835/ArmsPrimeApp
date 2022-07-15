//
//  ScreenProtector.swift
//  PreventScreenshot
//


import UIKit

class ScreenProtector {
    private var warningWindow: UIWindow?

    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }

    func startPreventingRecording() {
        NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
            let isCaptured =  UIScreen.main.isCaptured
            self.window?.isHidden = isCaptured
            if isCaptured {
                //videoGreetingController.stateChangeClouser = {  state in
               // headerPlayerController.changeSoundStatus(with: state)self.player?.pause()
                
                
               // self.alert(message: "Screen Prevent", title: "Error")
                
                
//                                let alert = UIAlertController(title: "Screen recording detected", message: "Please switch off screen recording to continue watching", preferredStyle: .alert)
//                                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
//                                 alert.addAction(action)
//                                 self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
              //  self.presentwarningWindow("Please switch off screen recording to continue watching")
                
                
                 let alert = UIAlertController(title: "Screen recording detected", message: "Please switch off screen recording to continue watching", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                  alert.addAction(action)

                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindow.Level.alert + 1;
                alertWindow.makeKeyAndVisible()
                
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                
                
                self.presentwarningWindow("Please switch off screen recording to continue watching")
                
                

                
            }
            else{
                self.warningWindow?.removeFromSuperview()
                self.warningWindow = nil
                self.window?.makeKeyAndVisible()
            }
        }
    }

   /* func startPreventingScreenshot() {
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
            let isCaptured =  UIScreen.main.isCaptured
            self.window?.isHidden = true
            if isCaptured {
                self.presentwarningWindow( "Screenshots are not allowed in our app. Please follow the instruction to delete the screenshot from your photo album!")
            }else{
//                self.warningWindow?.removeFromSuperview()
//                self.warningWindow = nil
//                self.window?.isHidden = false
//                self.window?.makeKeyAndVisible()
                self.warningWindow?.removeFromSuperview()
                self.warningWindow = nil
                self.window?.makeKeyAndVisible()
            }
        }
    }*/
    
    func startPreventingScreenshot() {
           NotificationCenter.default.addObserver(self, selector: #selector(newScreenpresentwarningWindow), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
   
       }
    
    @objc private func didDetectScreenshot() {
        DispatchQueue.main.async {
           // self.hideScreen()
            
            
            // self.ScreenpresentwarningWindow( "Screenshots are not allowed in our app.")
    //        self.grandAccessAndDeleteTheLastPhoto()
            NotificationCenter.default.addObserver(
              forName: UIApplication.userDidTakeScreenshotNotification,
              object: nil, queue: nil) { _ in

                let alert = UIAlertController(title: "Screenshot detected", message: "Screenshots are not allowed", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindow.Level.alert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.backgroundColor = .clear
                
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                  // self.ScreenpresentwarningWindow( "Screenshots are not allowed in our app.")
            }
        
        }
        
    }
    
    private func hideScreen() {
        if UIScreen.main.isCaptured {
            window?.isHidden = true
        } else {
            window?.isHidden = false
        }
    }
    
    func resentOrigional() {
         warningWindow?.removeFromSuperview()
         warningWindow = nil
         self.window?.isHidden = false
                       
    }
    
    
    
    private func ScreenpresentwarningWindow(_ message: String) {
        // Remove exsiting
        warningWindow?.removeFromSuperview()
        warningWindow = nil

        // Warning label
        let label = UILabel(frame: UIScreen.main.bounds)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.text = message

        // warning window
        var warningWindow = UIWindow(frame: UIScreen.main.bounds)

        let windowScene = UIApplication.shared
            .connectedScenes
            .first {
                $0.activationState == .foregroundActive
            }
        if let windowScene = windowScene as? UIWindowScene {
            warningWindow = UIWindow(windowScene: windowScene)
        }

        warningWindow.backgroundColor = .clear
        warningWindow.windowLevel = UIWindow.Level.statusBar + 1
        warningWindow.clipsToBounds = true
        warningWindow.isHidden = false
        warningWindow.addSubview(label)

        self.warningWindow = warningWindow

        UIView.animate(withDuration: 0.15) {
            label.alpha = 1.0
            label.transform = .identity
        }
        warningWindow.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) { [unowned self] () in
            self.resentOrigional()
        }
        
    }
    
    
    
    func lockRecording(){
        self.presentwarningWindow("Please switch off screen recording to continue watching")
    }
    private func presentwarningWindow(_ message: String) {
        // Remove exsiting
        warningWindow?.removeFromSuperview()
        warningWindow = nil

        // Warning label
        warningWindow?.backgroundColor = .clear
        let label = UILabel(frame: UIScreen.main.bounds)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .center
        label.text = message

        // warning window
        var warningWindow = UIWindow(frame: UIScreen.main.bounds)

        let windowScene = UIApplication.shared
            .connectedScenes
            .first {
                $0.activationState == .foregroundActive
            }
        if let windowScene = windowScene as? UIWindowScene {
            warningWindow = UIWindow(windowScene: windowScene)
        }

        warningWindow.backgroundColor = .clear
        warningWindow.windowLevel = UIWindow.Level.statusBar + 1
        warningWindow.clipsToBounds = true
        warningWindow.isHidden = true
        warningWindow.addSubview(label)

        self.warningWindow = warningWindow

        UIView.animate(withDuration: 0.15) {
            label.alpha = 1.0
            label.transform = .identity
        }
        warningWindow.makeKeyAndVisible()
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func newScreenpresentwarningWindow() {
        // Remove exsiting
        warningWindow?.removeFromSuperview()
        warningWindow = nil

        /*// Warning label
        let label = UILabel(frame: UIScreen.main.bounds)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        //label.text = message*/
        
        let alert = UIAlertController(title: "Screenshot detected", message: "Screenshots are not allowed in our app", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
       // alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.backgroundColor = .clear
        
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        

        // warning window
        var warningWindow = UIWindow(frame: UIScreen.main.bounds)

        let windowScene = UIApplication.shared
            .connectedScenes
            .first {
                $0.activationState == .foregroundActive
            }
        if let windowScene = windowScene as? UIWindowScene {
            warningWindow = UIWindow(windowScene: windowScene)
        }

        warningWindow.backgroundColor = .black
        warningWindow.windowLevel = UIWindow.Level.statusBar + 1
        warningWindow.clipsToBounds = true
        warningWindow.isHidden = false
        warningWindow.addSubview(alertWindow)

        self.warningWindow = warningWindow

        UIView.animate(withDuration: 0.15) {
           // label.alpha = 1.0
           // alert.transform = .identity
        }
        warningWindow.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 300) { [unowned self] () in
            self.resentOrigional()
        }
    }
}




