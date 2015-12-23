//
//  TRMapViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+TRBarItem.h"
#import "TRBusiness.h"
#import "DPAPI.h"
#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "TRCategory.h"
#import "TRAnnotation.h"

@interface TRMapViewController ()<MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//管理类(征求用户定位同意)
@property (nonatomic, strong) CLLocationManager *manager;
//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
//城市名字(用户所在位置)
@property (nonatomic, strong) NSString *cityName;
@end

@implementation TRMapViewController
- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建返回的item
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"icon_back" withHighlightedImageName:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    //添加item
    self.navigationItem.leftBarButtonItem = backItem;
    //设置nav的title
    self.navigationItem.title = @"地图";
    
    //征求用户同意(iOS8+/假定用户iOS8+/Info.plist)
    self.manager = [CLLocationManager new];
    //假定用户同意定位
    [self.manager requestWhenInUseAuthorization];
    //开始定位
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置代理
    self.mapView.delegate = self;
}

- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- MKMapViewDelegate
//定位到用户的位置
//以userLocation为中心, 以一个默认跨度来显示地图
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //反地理编码(获取城市名字)
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        //北京市
        NSString *cityName = placemark.addressDictionary[@"City"];
        self.cityName = [cityName substringToIndex:cityName.length - 1];
        NSLog(@"城市名字:%@", self.cityName);
        NSLog(@"地标字典:%@", placemark.addressDictionary);
    }];
    //发送请求(城市+经度+纬度+半径)
    [self mapView:mapView regionDidChangeAnimated:YES];
}
//地图区域发生移动
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //保证反地理编码已经成功
    if (!self.cityName) {
        return;
    }
    
    //获取地图的中心位置(包含最初用户的位置+地图区域移动后的位置)
    //发送请求(城市+经度+纬度+半径)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @3000;
    DPAPI *api = [DPAPI new];
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //把蓝色圈排除
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //写重用机制
    static NSString *identifier = @"annotation";
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //显示弹出框
        annotationView.canShowCallout = YES;
    }
    
    TRAnnotation *anno = (TRAnnotation *)annotation;
    annotationView.image = anno.image;
    annotationView.annotation = annotation;
    
    return annotationView;
}

#pragma mark --- DianPing delegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //将服务器返回的result(字典)转成由TRDeal组成的数组
    NSArray *dealsArray = [TRMetaDataTool parseResultFromServer:result];
    //判定服务器返回的数据不为空
    if (dealsArray.count == 0) {
        return;
    }
    
    //需求:获取所有订单对象中商家的经纬度(添加大头针对象到地图上)
    for (TRDeal *deal in dealsArray) {
        //将deal.businesses数组中的所有字典转成TRBusiness组成的数组
        NSArray *businessArray = [TRMetaDataTool getBusinessesWithDeal:deal];
        //deal.categories --> 第一项在categories.plist中对应的那项item --> map_icon图片名字
        //给定某个deal对象, 返回该deal对应的那个分类对象(map_icon图片名字)
        TRCategory *category = [TRMetaDataTool categoryWithDeal:deal];
        for (TRBusiness *business in businessArray) {
            //添加大头针到地图视图上(准备工作:TRAnnotation)
            TRAnnotation *annotaion = [TRAnnotation new];
            annotaion.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotaion.title = business.name;
            annotaion.subtitle = deal.desc;
            if (category) {
                //找到分类对象
                annotaion.image = [UIImage imageNamed:category.map_icon];
            } else {
                //没有找到分类对象
                annotaion.image = [UIImage imageNamed:@"icon_detail_merchants_selected"];
            }
            
            //避免在同一个商家多次添加大头针对象
            //重写isEqual方法(同一个商家的大头针对象的地址不一样)
            if ([self.mapView.annotations containsObject:annotaion]) {
                //不要添加(继续下次循环)
                continue;
            }
            
            [self.mapView addAnnotation:annotaion];
        }
        
    }
    
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
