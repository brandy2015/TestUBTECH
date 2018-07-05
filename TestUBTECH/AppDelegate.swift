//
//  AppDelegate.swift
//  TestUBTECH
//
//  Created by 张子豪 on 2018/7/5.
//  Copyright © 2018年 zhangqian. All rights reserved.
//

import UIKit

//正式环境的APP应用

let APPID = "2922"
let APPKEY = "13A5B4558637968B24AB5125E9057AF3"
let UrlScheme = "SDKDemoShow"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Alpha2ApiObject.sharedInstance().appId = APPID
        
        Alpha2ApiObject.sharedInstance().appKey = APPKEY
        Alpha2ApiObject.sharedInstance().urlScheme = UrlScheme
        
        Alpha2AuthSDK.openLog(true)
        Alpha2AuthSDK.startMonitor()//开启监听
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    #pragma mark - 第三方登录回调
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let auth = Alpha2AuthSDK.handleOpen(url) { (responobject, array, error) in
            //265782
            
            
            
            Alpha2ApiObject.sharedInstance().userId = (responobject as!  [AnyHashable : Any])["userId"] as! String
            Alpha2ApiObject.sharedInstance().accessToken = (responobject as!  [AnyHashable : Any])["accessToken"] as! String
            let arr = Alpha2AuthSDK.obtainAuthRobotList()
            print("\(responobject)------\(arr)")
            
            
            //responobject 里面有用户的ID  用这个id来登录XMPP
            //array 有机器人列表  登录XMPP成功以后，连接列表里面的机器人
            //取到机器人数组后请存到本地
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receiveUrlSchemeNotification"), object: array, userInfo: (responobject as! [AnyHashable : Any]))
            
        }
        return auth
    }
    
    
    
    
    
    
    
    
    
    

}

