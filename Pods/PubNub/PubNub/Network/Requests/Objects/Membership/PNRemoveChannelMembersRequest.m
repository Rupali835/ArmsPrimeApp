/**
 * @author Serhii Mamontov
 * @version 4.14.1
 * @since 4.14.1
 * @copyright © 2010-2020 PubNub, Inc.
 */
#import "PNBaseObjectsMembershipRequest+Private.h"
#import "PNBaseObjectsRequest+Private.h"
#import "PNRemoveChannelMembersRequest.h"
#import "PNRequest+Private.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Protected interface declaration

@interface PNRemoveChannelMembersRequest ()


#pragma mark - Initialization & Configuration

/**
 * @brief Initialize \c remove \c channel's members request.
 *
 * @param channel Name of channel for which members should be added.
 * @param uuids List of \c UUIDs which should be removed from \c channel's list.
 *
 * @return Initialized and ready to use \c remove \c channel's members request.
 */
- (instancetype)initWithChannel:(NSString *)channel uuids:(NSArray<NSString *> *)uuids;

#pragma mark -


@end

NS_ASSUME_NONNULL_END


#pragma mark - Interface implementation

@implementation PNRemoveChannelMembersRequest


#pragma mark - Information

@dynamic includeFields;


- (PNOperationType)operation {
    return PNRemoveChannelMembersOperation;
}


#pragma mark - Initialization & Configuration

+ (instancetype)requestWithChannel:(NSString *)channel uuids:(NSArray<NSString *> *)uuids {
    return [[self alloc] initWithChannel:channel uuids:uuids];
}

- (instancetype)initWithChannel:(NSString *)channel uuids:(NSArray<NSString *> *)uuids {
    if ((self = [super initWithObject:@"Channel" identifier:channel])) {
        self.includeFields = PNChannelMembersTotalCountField;
        [self removeRelationToObjects:uuids ofType:@"uuid"];
    }
    
    return self;
}

- (instancetype)init {
    [self throwUnavailableInitInterface];
    
    return nil;
}

#pragma mark -


@end
