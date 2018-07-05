//
//  ViewController.swift
//  TestUBTECH
//
//  Created by 张子豪 on 2018/7/5.
//  Copyright © 2018年 zhangqian. All rights reserved.
//

import UIKit
//import

class ViewController: UIViewController,AlphaRevDataDelegate {
    

    var _userId : String?
    var _robotId : String?
    var _robotEquitmentId : String?
    
    
    
    var _index = 0
    var _robotIds : NSMutableArray!
    var _soundIndex = 0
    
    var _robotArray : NSMutableArray!
    var _modelArray : NSMutableArray!
    var _speakerType : ALRobotTTSSpeakerType!
    
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var playTextView: UITextView!
    @IBAction func robotListClick(_ sender: Any) {
        
        self.pushRobotList(array: _robotArray, pushNetwork: false)
        
        
        
    }
    
    @IBOutlet weak var xmppButton: UIButton!

    @IBOutlet weak var socketButton: UIButton!
    
    
    
    func pushRobotList(array:NSMutableArray?,pushNetwork:Bool)  {
        let robot = ALRobotTableViewController()
        
        UserDefaults.standard.set("", forKey: "robotId")
        UserDefaults.standard.set("", forKey: "robotEquitmentId")
        UserDefaults.standard.synchronize()

//        self._robotId = robotId
//        self._robotEquitmentId = robotEquitmentId//@"A201B01160700034F0A"; //这里填序列号
        robot.didRobotBlock = (_robotId,_robotEquitmentId) as! (String, String)

        
        robot.dataArray = array
        robot.pushNetwork = pushNetwork
        
        
        robot.tableView.reloadData()
        self.navigationController?.pushViewController(robot, animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    #pragma mark - AlphaRevDataDelegate
    /*!
     *  @brief 接收连接断开机器人的回调
     *
     *  @param controlType 机器人返回是否可以连接和断开
     */
    
    func receiveControl(_ controlType: ALRobotConnectType, state connectState: Error!) {
        var newString = ""
        
        switch controlType {
        case .typeConnectSuccess:
            newString = "连接成功"
            break
            
            
        case .typeConnectFailure:
            newString = "连接失败"
            break
        case .typeDisconnectSuccess:
            newString = "断开成功"
            break
        case .typeDisconnectFailure:
            newString = "断开失败"
            break
        }
      
        
        let showString = "控制机器人的返回情况" + newString
        
            print(showString)
        
        
    }
    
    
    
    /*!
     *  @brief 接收服务器推送机器人的状态
     *
     *  @param robotState 机器人状态
     */
    func receiveRobotState(_ robotState: ALRobotStateChangeType, robotSeriesNumber: String!) {
        var newString = ""
        
        switch robotState    {
        case .offline:
            newString = "Offline"
            break
            
            
        case .online:
            newString = "Online"
            break
        case .byOther:
            newString = "ByOther"
            break
        case .byMyself:
            newString = "ByMyself"
            break
        }
        
        
        let showString = "机器人的状态:\(newString)序列号:\(robotSeriesNumber)"
        
        print(showString)
        
        _modelArray.add(robotSeriesNumber ?? "")

        // 一次性执行：
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//        // 延迟2秒执行：
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
//        //            [self connectRobotModel:robotModel];
//        });
//
//        });
//
        
        
        
    }
    

    func receiveTTSPlayerResult(result:String)  {
        let showString = "TTS播报：\(result)"
        
        DispatchQueue.main.async(execute: {
            
            
            
            
            self.textView.text = self.addString(newString: showString)
            
        })
        
    }

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        _robotArray = NSMutableArray()
        _modelArray = NSMutableArray()
        
        _index = 0
        _soundIndex = 0
        _speakerType = ALRobotTTSSpeakerType(rawValue: 0)
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(receiveUrlScheme), name: "receiveUrlSchemeNotification", object: nil)
        
        
//         NotificationCenter.default.addObserver(self, selector: #selector(receiveCurrentlog), name: "receiveCurrentLog", object: nil)
        
        
        ALCommandTool.sharedInstance().delegate = self
        
        
        _userId = Alpha2ApiObject.sharedInstance().userId
        _robotId = UserDefaults.standard.object(forKey: "robotId") as? String
        _robotEquitmentId = UserDefaults.standard.object(forKey: "robotEquitmentId") as? String
        
        //用户登录成功以后
        //会有一个机器人好友
        
        
        
        
        
    }
    
    
    func receiveCurrentlog(noti:Notification)  {
        if noti.object == nil{
            return
        }
        
        let str = noti.object as! String
        DispatchQueue.main.async(execute: {
            

            
            
            self.textView.text = self.addString(newString: str)
            
        })
        
    }
    
    
    
    func addString(newString:String) -> String {
        _index += 1
        
        let text = self.textView.text!
        let textShow =  "--\(_index)-->:\(newString)\n\(text)"
        return textShow
    }
    
    
    func receiveUrlScheme(obj:Notification)  {
        if obj.userInfo == nil{
            return
        }
        
     
        self.textView.text = self.dataTojsonString(object: obj.userInfo!)
        let accesstoken = obj.userInfo!["accessToken"]!
        
        _userId = obj.userInfo!["userId"] as! String
        
        Alpha2ApiObject.sharedInstance().userId = _userId
        
        print("userID----\(_userId),accessToken----\(accesstoken)")
        
        _robotArray = obj.object as! NSMutableArray
        self.pushRobotList(array: obj.object as! NSMutableArray, pushNetwork: false)
        
        
    }
    

    
    func dataTojsonString(object:Any) -> String {
        var jsonString = ""
//        var error = Error()
        let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        
        if let jsonData = jsonData{
           
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
        }else{
             print("错误")
        }
        return jsonString;
    }
    
    
    
    
    
//    #pragma mark 连接机器人
    @IBAction func connectRobot(_ sender: Any) {
        
        //    ALThirdApplicationModel *model1 = [[ALThirdApplicationModel alloc] init];
        //    model1.controlAppName = @"我是SDK——1";
        //    model1.controlUserName = @"HaoJianFeng";
        //    model1.startPackageName = @"com.ubt.android";
        
//       NSDictionary *dictionary = @{@"controlAppName":@"英语教育",@"controlUserName":@"xiaoqiang",@"startPackageName":@"com.ubt.android"};
        
        let dictionary = ["controlAppName":"英语教育","controlUserName":"xiaoqiang","startPackageName":"com.ubt.android"]
        
        
        ALCommandTool.sharedInstance().startControlRobot(_robotEquitmentId, thirdApplication: dictionary)
        
    }
    
    //    #pragma mark - 断开机器人
    
    @IBAction func sendRobot(_ sender: Any) {
        
        ALCommandTool.sharedInstance().stopControlRobot()
        
        
    }
    
    @IBAction func openAlphaNetworkBTN(_ sender: Any) {
        
        self.pushRobotList(array: nil, pushNetwork: true)
    }
    
    
    @IBAction func sendMeteData_third(_ sender: Any) {
        let string = "<cmd><type>3</type><stuId>1c2be8cd44f54139bd9cfc268da6ac9a</stuId><textbookId>d082f94a097d40f1ae96e7a1c4d6b020</textbookId><name>johny</name><curSentenceId>4778b651fb92459898771c4df1cc235es</curSentenceId><moduleId>1</moduleId><unitId>534a85592a994485bce3ac4f6ba722b6</unitId></cmd>"
        
        let key = "33279EF411592974FE981B2580C3C293"
        
        ALCommandTool.sharedInstance().sendMetadata(string, serviceKey: key)
    }
    
    
    
    
    
    
    @IBAction func addRobotfriend(_ sender: Any) {
     
//        [[ALXMPPManager sharedInstance] addRobotRosters:_robotIds];
    
    }
    
    
    @IBAction func openAlpha(_ sender: Any) {
        
        if !Alpha2AuthSDK.isAlpha2Installed(){
            print("Alpha2未安装")
            return
        }
        
         //清除之前的账号
        self.clearData()
        self.clearContent()
        
        let id = Alpha2ApiObject.sharedInstance().appId
        let key = Alpha2ApiObject.sharedInstance().appKey
        let urlScheme = Alpha2ApiObject.sharedInstance().urlScheme
        
        Alpha2AuthSDK.openAlpha2(id, appKey: key, urlScheme: urlScheme)
        
    }
    
    
     //清除之前的账号
    func clearData()  {
        Alpha2AuthSDK.closeMonitor()
        Alpha2ApiObject.sharedInstance().userId = nil
    }
    
    
    @IBAction func clearContentBTN(_ sender: Any) {
        clearContent()
    }
    
    func clearContent()  {
        self.textView.text = ""
        
        _index = 0
    }
    
    
    @IBAction func moveForwardBTN(_ sender: Any) {
        
        ALCommandTool.sharedInstance().actionMovingForward()
        
        
    }
    
    
    @IBAction func moveBackForwardBTN(_ sender: Any) {
        ALCommandTool.sharedInstance().actionMovingBackward()
    }
    
    
    @IBAction func moveLeftBTN(_ sender: Any) {
        ALCommandTool.sharedInstance().actionTurnLeft()
    }
    
    
    @IBAction func moveRightBTN(_ sender: Any) {
        ALCommandTool.sharedInstance().actionTurnRight()
    }
    
    @IBAction func actionStopBTN(_ sender: Any) {
        ALCommandTool.sharedInstance().actionStopAction()
    }
    
    
    
    @IBAction func turnHeadUpBTN(_ sender: Any) {
        
        ALCommandTool.sharedInstance().processSpeechVerticalAngle(105)//75
    }
    
    @IBAction func turnHeadDownBTN(_ sender: Any) {
        ALCommandTool.sharedInstance().processSpeechVerticalAngle(155)//160
        
    }
    
    
    @IBAction func turnHeadLeftBTN(_ sender: Any) {
        
         ALCommandTool.sharedInstance().processSpeechHorizontalAngle(75)//105
    }
    
    //    turnHeadRight
    
    @IBAction func turnHeadRightBTN(_ sender: Any) {
        
        ALCommandTool.sharedInstance().processSpeechHorizontalAngle(165)//155
    }
        
    
    
    
//    动作复位
    
    @IBAction func resetActionBTN(_ sender: Any) {
         ALCommandTool.sharedInstance().actionReset()
    }

    
    
    
    
    
    @IBAction func setPlayerTTSBTN(_ sender: Any) {
        
        _soundIndex += 0
        
        if _soundIndex >= 10{
            _soundIndex = 0
        }
        
        var showString = "默认"
        
        
        switch (_soundIndex) {
        
        case 0:
                showString = "默认"
                break
        case 1:
            showString = "NanNan_CN"
            break
          
        case 2:
            showString = "XiaoFeng_CN"
            break
            
            
        case 3:
            showString = "XiaoYan_CN"
            break
            
            
        case 4:
            showString = "Catherine"
            break
            
            
        case 5:
            showString = "John"
            break
            
            
            
        case 6:
            showString = "Allison"
            break
            
            
        case 7:
            showString = "Ava"
            break
            
            
        case 8:
            showString = "Samantha"
            break
            
        case 9:
            showString = "Susan"
            break
            
        case 10:
            showString = "Zoe"
            break
        
        default :
            showString = ""
            break
        }
        
        _speakerType = ALRobotTTSSpeakerType(rawValue: ALRobotTTSSpeakerType.RawValue(_soundIndex))
        
        let BTN = sender as! UIButton
        BTN.setTitle(showString, for: .normal)
        
        ALCommandTool.sharedInstance().setTTSSpeaker(ALRobotTTSSpeakerType(rawValue: ALRobotTTSSpeakerType.RawValue(_soundIndex))!)
    }
    
    
    @IBAction func playerCNTTSBTN(_ sender: Any) {
        
        ALCommandTool.sharedInstance().speechStartTTS(self.playTextView.text!, language: ALRobotTTSLanguageType.CN, speaker: _speakerType)
        
        
        
        
    }
    
    
    
    
    @IBAction func playerENTTSBTN(_ sender: Any) {
        
        ALCommandTool.sharedInstance().speechStartTTS(self.playTextView.text!, language: ALRobotTTSLanguageType.EN, speaker: _speakerType)
        
        
        
        
    }
    
    
    @IBAction func stopTTSPlayerBTn(_ sender: Any) {
        
        ALCommandTool.sharedInstance().speechStopTTS()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func hasAuthedBTN(_ sender: Any) {
        //先ping Socket开通道是否存在
        //如果ping不通，登录openfire
        //
        print("others")
    }
    
    @IBAction func changeSocketAndXMPPBTN(_ sender: Any) {
      
        print("others")
    }
    
    
    
    func receiveError(_ error:Error)  {
        print("错误名：\(error)")
    }
    
    
    func xmppIsConnect()  {
        self.socketButton.backgroundColor = .white
        self.xmppButton.backgroundColor = .green
        
    }
    
    
    
    func socketIsConnect()  {
        self.xmppButton.backgroundColor = .white
        self.socketButton.backgroundColor = .green
        
    }
    
    
    /*!
     *  @brief 获取声源定位
     *
     *  @param angle 声源定位返回的机器人角度值
     */
    
    private func receiveRobotSpeechAngleResult(angle:Int)  {
        print("机器人返回的声源定位角度:\(angle)")
        //    int newAngle = angle & 0xFF;  //abs(angle); //负值转正值
        
        let showString = "机器人声源定位角度 \(angle)"
        
        DispatchQueue.main.async(execute: {
            
           
            
            
            self.textView.text = self.addString(newString: showString)
            
        })
        
        
    }
    
    /*!
     *  @brief 获取语音识别
     *
     *  @param strResult 识别内容
     *  @param voiceType 1：讯飞识别返回结果
     4：英文本地识别结果
     5：英文声音转文字结果
     6：英文语义理解结果
     
     */
    
    
    func receiveRobotSpeechGrammarResult(strResult:String,voiceType type:Int) {
        print("机器人返回的语音识别结果:\(strResult)")
        
        var newString = "未知返回结果"
        if (type == 1) {
            newString = "讯飞识别返回结果";
        }else if (type == 2){
            newString = "英文本地识别结果";
        }else if (type == 3){
            newString = "英文声音转文字结果";
        }else if (type == 4){
            newString = "英文语义理解结果";
        }
        
        let showString = "\(newString)<--->\(strResult)"
        DispatchQueue.main.async(execute: {
            
            
            
            
            self.textView.text = self.addString(newString: showString)
            
        })
        
    }
    
    
    
    
    /*!
     *  @brief 接收元数据
     *
     *  @param data data description
     */
    
    func receiveMetadata(dataString:String) {
        print("接收元数据+++++++++++++++++++++++++++++++\(dataString)")
    }
    
    
    @IBAction func cleatContent(_ sender: Any) {
        
        self.textView.text = ""
        
        _index = 0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

