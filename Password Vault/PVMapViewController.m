//
//  PVMapViewController.m
//  Password Vault
//
//  Created by Brian Leibreich on 10/30/12.
//
//

#import "PVMapViewController.h"
#import "PVDataManager.h"

#define METERS_PER_MILE 1609.344

@interface PVMapViewController (){
    CLLocationManager *locationManager;
    PVDataManager *pvm;
}

@end

@implementation PVMapViewController
@synthesize _mapView;

-(id)init{
    self = [super init];
    if(self){
        
        pvm = [PVDataManager sharedDataManager];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.029579;
    zoomLocation.longitude = -84.463509;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    [self set_mapView:nil];
    [self set_mapView:nil];
    [super viewDidUnload];
}

-(BOOL)timeToPost{
    int lastPost = [pvm getLastPost];
    NSDate *date = [NSDate date];
    NSDate *prevDate = [[NSDate alloc] initWithTimeIntervalSince1970:lastPost];
    if([date timeIntervalSince1970] - [prevDate timeIntervalSince1970] > (5*60.0)){
        NSLog(@"TIMER: %f LAST: %f", [date timeIntervalSince1970], [prevDate timeIntervalSince1970]);
        [pvm setLastPost:(int)[date timeIntervalSince1970]];
        return YES;
    }
    NSLog(@"NO TIMER: %f LAST: %f", [date timeIntervalSince1970], [prevDate timeIntervalSince1970]);
    return NO;
}

#pragma Location Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //[locationManager stopUpdatingLocation];
    [self timeToPost];
}

@end
