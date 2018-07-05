//
//  Alpha2ApiObject.h
//  Alpha_SDK
//
//  Created by 姚 on 16/8/18.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alpha2ApiObject : NSObject


/**
 *  单例
 */
+ (Alpha2ApiObject *)sharedInstance;


/**
 *  当前用户
 */
@property (nonatomic, copy) NSString *userId;/**<控制人ID*/
@property (nonatomic, copy) NSString *accessToken;/**<token*/

/*!
 *  @author Mr.Yao, 16-09-22 14:09:12
 *
 *  @brief 应用id，key和urlscheme
 */
@property (nonatomic, copy) NSString *appId;/**<当前SDK的appId*/
@property (nonatomic, copy) NSString *appKey;/**<当前SDK的appKey*/
@property (nonatomic, copy) NSString *urlScheme;/**<当前SDK的urlScheme*/


@end

@interface AlphaRobotModel : NSObject

@property (nonatomic, copy) NSString *robotEquitment;/**<机器人序列号*/
@property (nonatomic, copy) NSString *robotId;/**<机器人ID*/
@property (nonatomic, copy) NSString *robotName;/**<机器人昵称*/
@property (nonatomic, copy) NSString *identifier;/**<alpha2客户端授权过来的identifier*/
//@property (nonatomic, copy) NSString *robotImage;/**<机器人头像url*/

@end






