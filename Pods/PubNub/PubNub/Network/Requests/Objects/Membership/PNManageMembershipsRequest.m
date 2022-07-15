/**
 * @author Serhii Mamontov
 * @version 4.14.0
 * @since 4.14.0
 * @copyright © 2010-2020 PubNub, Inc.
 */
#import "PNBaseObjectsMembershipRequest+Private.h"
#import "PNBaseObjectsRequest+Private.h"
#import "PNManageMembershipsRequest.h"
#import "PNRequest+Private.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Protected interface declaration

@interface PNManageMembershipsRequest ()


#pragma mark - Initialization & Configuration

/**
 * @brief Initialize \c manage \c UUID's memberships request.
 *
 * @param uuid Identifier for which memberships should be managed.
 * Will be set to current \b PubNub configuration \c uuid if \a nil is set.
 *
 * @return Initialized and ready to use \c manage \c UUID's memberships request.
 */
- (instancetype)initWithUUID:(nullable NSString *)uuid;

#pragma mark -


@end

NS_ASSUME_NONNULL_END


#pragma mark - Interface implementation

@implementation PNManageMembershipsRequest


#pragma mark - Information

@dynamic includeFields;


- (PNOperationType)operation {
    return PNManageMembershipsOperation;
}

- (void)setSetChannels:(NSArray<NSDictionary *> *)setChannels {
    _setChannels = setChannels;
    
    [self setRelationToObjects:setChannels ofType:@"channel"];
}

- (void)setRemoveChannels:(NSArray<NSString *> *)removeChannels {
    _removeChannels = removeChannels;
    
    [self removeRelationToObjects:removeChannels ofType:@"channel"];
}


#pragma mark - Initialization & Configuration

+ (instancetype)requestWithUUID:(NSString *)uuid {
    return [[self alloc] initWithUUID:uuid];
}

- (instancetype)initWithUUID:(NSString *)uuid {
    if ((self = [super initWithObject:@"UUID" identifier:uuid])) {
        self.includeFields = PNMembershipsTotalCountField;
    }
    
    return self;
}

- (instancetype)init {
    [self throwUnavailableInitInterface];
    
    return nil;
}

#pragma mark -


@end
