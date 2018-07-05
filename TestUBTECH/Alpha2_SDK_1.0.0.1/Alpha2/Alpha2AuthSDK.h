//
//  Alpha2AuthSDK.h
//  Alpha_SDK
//
//  Created by 姚 on 16/8/18.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlphaRobotModel;

/**
 *  返回错误类型
 */
typedef NS_ENUM(NSUInteger, ALErrorType) {
    /**
     *  APPKey无效
     */
    ALErrorTypeAppKeyInvalid,
    /**
     *  APPID无效
     */
    ALErrorTypeAppIdInvalid,
    /**
     *  授权码无效
     */
    ALErrorTypeAuthCodeInvalid,
    /**
     *  url无效
     */
    ALErrorTypeAuthUrlInvalid,
};



@interface Alpha2AuthSDK : NSObject


+ (BOOL)handleOpenURL:(NSURL *)url;

/*!
 *  @author Mr.Yao, 16-09-22 14:09:04
 *
 *  @brief 接受ALpha2的回调
 *
 *  @param url             Alpha2包装的Url数据
 *  @param completionBlock responobject
 *
 *  @return 是否来自Alpha2的回调
 */
+ (BOOL)handleOpenURL:(NSURL *)url
           completion:(void(^)(id responobject,NSMutableArray <AlphaRobotModel *> *,NSError *))completionBlock;


/*!
 *  @author Mr.Yao, 16-09-22 14:09:55
 *
 *  @brief 检测是否安装了Alpha2客户端
 *
 *  @return 返回YES代表安装，NO代表未安装
 */
+ (BOOL)isAlpha2Installed;

/*!
 *  @author Mr.Yao, 16-09-30 15:09:33
 *
 *  @brief 检测token是否失效（失效有效期7天）
 *
 *  @return 返回YES代表已经过期，NO代表未过期
 */
+ (BOOL)accessTokenIsDisabled;

/*!
 *  @author Mr.Yao, 16-09-22 14:09:59
 *
 *  @brief 设置log开关(默认打开)
 *
 *  @param YesOrNo YesOrNo description
 */
+ (void)openLog:(BOOL)YesOrNo;

/*!
 *  @author Mr.Yao, 16-09-22 15:09:07
 *
 *  @brief 获取log是否打开
 *
 *  @return return value description
 */
+ (BOOL)logEnable;

/*!
 *  @author Mr.Yao, 16-09-22 14:09:30
 *
 *  @brief 打开ALpha2授权SDK
 */
+ (void)openAlpha2Auth;

/*!
 *  @author Mr.Yao, 16-09-28 17:09:18
 *
 *  @brief 打开ALPHA
 *
 *  @param appId     appid
 *  @param appKey    appkey
 *  @param urlScheme urlScheme
 */
+ (void)openAlpha2:(NSString *)appId appKey:(NSString *)appKey urlScheme:(NSString *)urlScheme;


/*!
 *  @author Mr.Yao, 16-09-28 17:09:36
 *
 *  @brief 获取授权的机器人
 *
 *  @return 返回授权列表
 */
+ (NSArray <AlphaRobotModel *>*)obtainAuthRobotList;

/*!
 *  @author Mr.Yao, 16-09-28 17:09:52
 *
 *  @brief 删除机器人列表
 *
 *  @param robotId 机器人ID
 */
+ (void)deleteRobot:(NSString *)robotId
         completion:(void(^)(id responobject,NSError *error))completion;


/*!
 *  @author Mr.Yao, 16-09-29 16:09:44
 *
 *  @brief 开启监听广播 （程序启动和重新授权时开启）
 */
+ (void)startMonitor;

/*!
 *  @author Mr.Yao, 16-09-29 16:09:57
 *
 *  @brief 关闭广播监听
 */
+ (void)closeMonitor;

/*!
 *  @author Mr.Yao, 16-10-03 10:10:31
 *
 *  @brief 打开Alpha2网络配置页面
 *
 *  @param equipmentUserId 机器人ID
 *  @param equipmentId     机器人的序列号
 */
+ (void)openAlphaNetWork:(NSString *)equipmentUserId
             equipmentId:(NSString *)equipmentId;


/*!
 *  @author Mr.Yao, 16-09-26 09:09:55
 *
 *  @brief 删除机器人
 *
 *  @param robotId    机器人ID
 *  @param userId     当前用户的ID
 *  @param appId      应用的ID
 *  @param completion 删除回调
 */
+ (void)deleteRobot:(NSString *)robotId
             userId:(NSString *)userId
              appId:(NSString *)appId
         completion:(void(^)(id responobject,NSError *error))completion;



@end







