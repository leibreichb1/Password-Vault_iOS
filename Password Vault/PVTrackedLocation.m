//
//  PVTrackedLocation.m
//  Password Vault
//
//  Created by Brian Leibreich on 11/1/12.
//
//

#import "PVTrackedLocation.h"

@implementation PVTrackedLocation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    if((self = [super init])){
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

-(NSString *)title{
    if([_name isKindOfClass:[NSNull class]])
        return @"Unknown user";
    else
        return _name;
}

-(NSString *)subtitle{
    return _address;
}

-(CLLocationCoordinate2D)cord{
    return _coordinate;
}

-(NSString *)description{
    return [[NSString alloc] initWithFormat:@"%@ %@", _name, _address];
}
@end
