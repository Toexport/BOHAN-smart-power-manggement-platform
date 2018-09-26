//
//  AppLocationManager.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AppLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface AppLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager* manager;

@end

@implementation AppLocationManager

+ (instancetype)shareAppLocationManager {
    static AppLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AppLocationManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        if ([CLLocationManager locationServicesEnabled]) {
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
            _manager.desiredAccuracy = kCLLocationAccuracyBest;
            _manager.distanceFilter = 5.0;
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if ([CLLocationManager locationServicesEnabled] && (status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorizedAlways)) {
                [_manager startUpdatingLocation];
            }else {
                [_manager requestAlwaysAuthorization];
            }
        }
    }
    return self;
}

- (void)getLocation:(XMInfoBlock)infoBlock {
    _infoBlock = infoBlock;
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] && (status==kCLAuthorizationStatusAuthorizedWhenInUse || status==kCLAuthorizationStatusAuthorizedAlways)) {
        [_manager startUpdatingLocation];
    }else {
        [_manager requestAlwaysAuthorization];
    }
}

- (NSString *)city {
    if (!_city) {
        _city = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"] : [[NSUserDefaults standardUserDefaults] objectForKey:@"locationCity"];
        
        if (!_city) {
            return @"";
        }
    }
    
    return _city;
}

- (NSString *)longitude {
    if (!_longitude) {
        _longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        
        if (!_longitude) {
            return @"";
        }
    }
    
    return _longitude;
}

- (NSString *)latitude {
    if (!_latitude) {
        _latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        
        if (!_latitude) {
            return @"";
        }
    }
    
    return _latitude;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self updateLocation];
}

- (void)updateLocation {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.latitude?[user setObject:self.latitude forKey:@"latitude"]:[user removeObjectForKey:@"latitude"];
    self.longitude?[user setObject:self.longitude forKey:@"longitude"]:[user removeObjectForKey:@"longitude"];
    self.city?[user setObject:self.city forKey:@"currentCity"]:[user removeObjectForKey:@"currentCity"];
}

#pragma mark - 定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_manager stopUpdatingLocation];
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    /*打印当前经纬度*/
    
    NSLog(@"%f\n%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    /*地理反编码 -- 可以根据地理位置（经纬度）确认位置信息 （街道、门牌）*/
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark * placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            NSLog(@"%@",currentCity);/*当前城市*/
            NSLog(@"%@",placeMark.subLocality);/*当前位置*/
            NSLog(@"%@",placeMark.thoroughfare);/*当前街道*/
            NSLog(@"%@",placeMark.name);/*具体地址 ** 市 ** 区** 街道*/
            self.area = placeMark.subLocality;
            self.city = currentCity;
            self.cityCode = @"";
            self.latitude = @(currentLocation.coordinate.latitude).description;
            self.longitude = @(currentLocation.coordinate.longitude).description;
            
            if (_infoBlock) { _infoBlock(@{@"currentCity":currentCity,@"subLocality":placeMark.subLocality?placeMark.subLocality:@"",@"thoroughfare":placeMark.thoroughfare?placeMark.thoroughfare:@"",@"name":placeMark.name?placeMark.name:@"",@"latitude":self.latitude,@"longitude":self.longitude});
            } else {
                [self updateLocation];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kFirstPageHotelLocationSelected object:@{@"cityname":currentCity}];
            }
        }
        else if (error == nil&&placemarks.count == 0){
            NSLog(@"没有地址返回");
        }
        else if (error){
            NSLog(@"location error:%@",error);
        }
    }];
}

#pragma mark 通过经纬度计算两地距离
- (float)getDistance:(float)lat1 lng1:(float)lng1 lat2:(float)lat2 lng2:(float)lng2
{
    //地球半径
    int R = 6378137;
    //将角度转为弧度
    float radLat1 = [self radians:lat1];
    float radLat2 = [self radians:lat2];
    float radLng1 = [self radians:lng1];
    float radLng2 = [self radians:lng2];
    //结果
    float s = acos(cos(radLat1)*cos(radLat2)*cos(radLng1-radLng2)+sin(radLat1)*sin(radLat2))*R;
    //精度
    s = round(s* 10000)/10000;
    return  round(s);
}
- (float)radians:(float)degrees{
    return (degrees*3.14159265)/180.0;
}


+ (void)jumpToMapWithLat:(NSString *)lat lng:(NSString *)lng title:(NSString *)title content:(NSString *)content VC:(UIViewController *)vc {
    if (!title.length || !title) {
        title = @"目标位置";
    }
    if (!content.length || !content) {
        content = @"位置";
    }
    
    // 查看本机所安装的地图app
    NSArray *array = [self getInstalledMapAppWithEndLocation:lat.floatValue Lon:lng.floatValue appName:@"伯瀚" backScheme:@"Bohan"];
    if (array.count) {
        // 创建UIActionSheet
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择地图进行导航" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        for (NSDictionary *dic in array) {
            [alert addAction:[UIAlertAction actionWithTitle:dic[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([dic[@"title"] isEqualToString:@"百度地图"] || [dic[@"title"] isEqualToString:@"高德地图"] || [dic[@"title"] isEqualToString:@"腾讯地图"] || [dic[@"title"] isEqualToString:@"谷歌地图"]) {
//                    OpenUrl(dic[@"url"]);
                }  else {
                    [self navAppleMapWithDict:dic];
                }
            }]];
        }
        [vc presentViewController:alert animated:YES completion:^{
            
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先安装百度地图" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        //http://itunes.apple.com/cn/app/id452186370
        //NSString  *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d",appid];
        NSString  *str =  @"http://itunes.apple.com/cn/app/id452186370";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 坐标转换
+ (NSArray*)exchangeLat:(CGFloat)gg_lat Lon:(CGFloat)gg_lon {
    
    CGFloat bd_lon;
    CGFloat bd_lat;
    const double x_pi = 3.14159265358979324 * 3000.f / 180.f;
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bd_lon = z * cos(theta) + 0.0065;
    bd_lat = z * sin(theta) + 0.006;
    NSArray *array = @[@(bd_lat),@(bd_lon)];
    return array;
}


+ (NSArray *)getInstalledMapAppWithEndLocation:(CGFloat)gg_lat Lon:(CGFloat)gg_lon appName:(NSString *)appName backScheme:(NSString *)backScheme
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    iosMapDic[@"lat"] = [NSNumber numberWithDouble:gg_lat];
    iosMapDic[@"lng"] = [NSNumber numberWithDouble:gg_lon];
    [maps addObject:iosMapDic];
    
    NSArray *startArray = [self exchangeLat:gg_lat Lon:gg_lon];
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[startArray[0] floatValue],[startArray[1] floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,backScheme,gg_lat,gg_lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
//    //谷歌地图
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
//        googleMapDic[@"title"] = @"谷歌地图";
//        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,backScheme,gg_lat, gg_lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        googleMapDic[@"url"] = urlString;
//        [maps addObject:googleMapDic];
//    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",gg_lat, gg_lon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    return maps;
}

// 苹果地图
+ (void)navAppleMapWithDict:(NSDictionary *)dict
{
//    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lng"] doubleValue]) addressDictionary:nil]];
//    NSArray *items = @[currentLoc,toLocation];
//    NSDictionary *dic = @{
//                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
//                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
//                          MKLaunchOptionsShowsTrafficKey : @(YES)
//                          };
//    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

@end
