//
//  ALCommandTool.h
//  Alpha_SDK
//
//  Created by 姚 on 16/9/1.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

//通知
extern NSString *const UBTReceiveRobotStateNotification; /**< 收到机器人的状态改变 */
extern NSString *const UBTReceiveControlRobotNotification; /**< 收到机器人返回的连接XMPP状态通知*/
extern NSString *const UBTReceiveCommandRobotNotification; /**< 收到机器人返回的指令通知 */
extern NSString *const UBTReceiveThirdRobotNotification; /**< 收到第三方返回的指令通知 */
extern NSString *const UBTReceiveThirdSocketDataNotification; /**< 收到第三方机器人Socket返回的指令通知 */
extern NSString *const UBTReceiveSocketQueueDataNotification; /**< 收到第三方机器人Socket返回的指令通知 */
extern NSString *const UBTReceiveThirdXMPPDataNotification; /**< 收到第三方机器人XMPP返回的指令通知 */
extern NSString *const UBTReceiveSocketReconnectNotification; /**< 收到第三方机器人XMPP返回的指令通知 */
extern NSString *const UBTReceiveRobotErrorNotification; /**< 收到机器人返回错误的通知 */

/*!
 *  @brief 机器人头部转动
 */
typedef NS_ENUM(NSUInteger, ALRobotTurnHeadType) {
    /*!
     *  抬头
     */
    ALRobotTurnHeadTypeUp,
    /*!
     *  低头
     */
    ALRobotTurnHeadTypeDown,
    /*!
     *  向左
     */
    ALRobotTurnHeadTypeLeft,
    /*!
     *  向右
     */
    ALRobotTurnHeadTypeRight,
};

typedef NS_ENUM(NSUInteger, ALRobotTTSLanguageType) {
    ALRobotTTSLanguageCN = 0,
    ALRobotTTSLanguageEN,
};

typedef NS_ENUM(NSUInteger, ALRobotTTSSpeakerType) {
    
    ALRobotTTSSpeakerDefault     = 0,//默认发音人(中文和英文)
    
    ALRobotTTSCNSpeakerNanNan    = 1,//中文发音人（可播英文）
    ALRobotTTSCNSpeakerXiaoFeng  = 2,//中文发音人（可播英文）
    ALRobotTTSCNSpeakerXiaoYan   = 3,//中文发音人（可播英文）
    
    ALRobotTTSENSpeakerCatherine = 4,//英文发音人
    ALRobotTTSENSpeakerJohn      = 5,//英文发音人
    
    ALRobotTTSENSpeakerAllison   = 6,//英文发音人
    ALRobotTTSENSpeakerAva       = 7,//英文发音人
    ALRobotTTSENSpeakerSamantha  = 8,//英文发音人
    ALRobotTTSENSpeakerSusan     = 9,//英文发音人
    ALRobotTTSENSpeakerZoe       = 10,//英文发音人
};

typedef NS_ENUM(NSInteger, ALRobotStateChangeType) {
    ALRobotStateChangeTypeOffline = 1, //下线
    ALRobotStateChangeTypeOnline, // 在线空闲
    ALRobotStateChangeTypeByOther, //忙碌 other
    ALRobotStateChangeTypeByMyself, //忙碌 myself
};

typedef NS_ENUM(NSInteger, ALRobotConnectType) {
    ALRobotTypeConnectSuccess = 1, //连接成功
    ALRobotTypeConnectFailure = 2, //连接失败
    ALRobotTypeDisconnectSuccess = 3, //断开成功
    ALRobotTypeDisconnectFailure = 4, //断开失败
};

@protocol AlphaRevDataDelegate <NSObject>


@required
/*!
 *  @brief 接收连接断开机器人的回调
 *
 *  @param controlType 机器人返回是否可以连接和断开
 */
- (void)receiveControl:(ALRobotConnectType)controlType
                 state:(NSError *)connectState;

/*!
 *  @author Mr.Yao, 16-09-29 16:09:18
 *
 *  @brief 接收服务器推送机器人的状态
 *
 *  @param robotState            机器人状态
 *  @param robotSeriesNumber     机器人序列号
 */
- (void)receiveRobotState:(ALRobotStateChangeType)robotState
        robotSeriesNumber:(NSString *)robotSeriesNumber;


@optional

/*!
 *  @brief TTS播报的回调
 *
 *  @param result 回调结果
 */
- (void)receiveTTSPlayerResult:(id)result;


/*!
 *  @brief 获取声源定位
 *
 *  @param angle angle description
 */
- (void)receiveRobotSpeechAngleResult:(int)angle;


/*!
 *  @brief 获取语音识别
 *
 *  @param strResult 识别内容
 *  @param voiceType
 1：讯飞识别返回结果
 4：英文本地识别结果
 5：英文声音转文字结果
 6：英文语义理解结果
 */
- (void)receiveRobotSpeechGrammarResult:(NSString *)strResult voiceType:(int)type;


/*!
 *  @author Mr.Yao, 16-10-10 14:10:57
 *
 *  @brief 接收元数据
 *
 *  @param dataString 接收定义机器人的数据
 */
- (void)receiveMetadata:(NSString *)dataString;

/*!
 *  @brief 连接错误的回调
 *
 *  @param error error //含强T关系
 */
- (void)receiveError:(NSError *)error;

@end


@interface ALCommandTool : NSObject

+ (instancetype)sharedInstance;

/////////////////////////////////////////////////////////////////////
////////////////////////////发送命令//////////////////////////////////
////////////////////////////////////////////////////////////////////
/*!
 *  @brief 连接机器人
 *
 *  @param robotSeriesNumber     机器人序列号
 *  @param applicationInfo (optional)   要启动的第三方(发送Start命令可以启动相应的第三方App，例下)
 *         @{@"controlAppName":@"控制应用名",@"controlUserName":@"控制者名称",@"startPackageName":@"第三方App包名"}
 */
- (void)startControlRobot:(NSString *)robotSeriesNumber
         thirdApplication:(NSDictionary *)applicationInfo;

/*!
 *  @brief 断开机器人（须先连接机器人）
 */
- (void)stopControlRobot;

/*!
 *  @brief 停止动作（须先连接机器人）
 */
- (void)actionStopAction;

/*!
 *  @brief 动作复位（须先连接机器人）
 */
- (void)actionReset;

/*!
 *  @brief 前进（须先连接机器人）
 */
- (void)actionMovingForward;

/*!
 *  @brief 后退（须先连接机器人）
 */
- (void)actionMovingBackward;

/*!
 *  @brief 向左转（须先连接机器人）
 */
- (void)actionTurnLeft;

/*!
 *  @brief 向右转（须先连接机器人）
 */
- (void)actionTurnRight;


/*!
 *  @brief 机器人头部水平角度（须先连接机器人）
 *
 *  @param angle     角度 75-165
 *  @param robotId   机器人ID
 */
- (void)processSpeechHorizontalAngle:(int)angle;


/*!
 *  @brief 机器人头部垂直角度（须先连接机器人）
 *
 *  @param angle     角度 105-155
 *  @param robotId   机器人ID
 */
- (void)processSpeechVerticalAngle:(int)angle;


/*!
 *  @brief TTS播报（须先连接机器人）
 *
 *  @param voiceString 播报的内容
 *  @param language    播报的语言
 *  @param voiceName   播报的发音人
 */
- (void)speechStartTTS:(NSString *)voiceString
              language:(ALRobotTTSLanguageType)language
               speaker:(ALRobotTTSSpeakerType)voiceName;

/*!
 *  @brief 设置TTS发音人（须先连接机器人）
 *
 *  @param speaker 发音人
 */
- (void)setTTSSpeaker:(ALRobotTTSSpeakerType)speaker;


/*!
 *  @brief 停止TTS播报（须先连接机器人）
 *
 *  @param robotId 机器人ID
 */
- (void)speechStopTTS;


/*!
 *  @brief 发送数据的元接口 （须先连接机器人）
 *
 *  通过XMPP或者Socket发送元数据的过程中，请保持与机器人建立相应的连接
 *
 *  @param data         开发者定义的数据
 *  @param serviceKey   机器人端应用的APPkey：74CA7E9994D8C10124270F913EF31EA0
 */
- (void)sendMetadata:(NSString *)dataString serviceKey:(NSString *)serviceKey;

/////////////////////////////////////////////////////////////////////
////////////////////////////接收命令//////////////////////////////////
////////////////////////////////////////////////////////////////////

@property (nonatomic, weak) id <AlphaRevDataDelegate> delegate;/**< 代理 */



@end























