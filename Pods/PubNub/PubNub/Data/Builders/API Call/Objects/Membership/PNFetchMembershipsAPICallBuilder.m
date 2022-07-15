/**
 * @author Serhii Mamontov
 * @version 4.14.0
 * @since 4.14.0
 * @copyright © 2010-2020 PubNub, Inc.
 */
#import "PNFetchMembershipsAPICallBuilder.h"
#import "PNAPICallBuilder+Private.h"


#pragma mark Interface implementation

@implementation PNFetchMembershipsAPICallBuilder


#pragma mark - Information

@dynamic queryParam;


#pragma mark - Configuration

- (PNFetchMembershipsAPICallBuilder * (^)(PNMembershipFields includeFields))includeFields {
    return ^PNFetchMembershipsAPICallBuilder * (PNMembershipFields includeFields) {
        [self setValue:@(includeFields) forParameter:NSStringFromSelector(_cmd)];
        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(BOOL shouldIncludeCount))includeCount {
    return ^PNFetchMembershipsAPICallBuilder * (BOOL shouldIncludeCount) {
        [self setValue:@(shouldIncludeCount) forParameter:NSStringFromSelector(_cmd)];
        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSArray<NSString *> *sort))sort {
    return ^PNFetchMembershipsAPICallBuilder * (NSArray<NSString *> *sort) {
        if ([sort isKindOfClass:[NSArray class]] && sort.count) {
            [self setValue:sort forParameter:NSStringFromSelector(_cmd)];
        }
        
        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSString *filter))filter {
    return ^PNFetchMembershipsAPICallBuilder * (NSString *filter) {
        if ([filter isKindOfClass:[NSString class]] && filter.length) {
            [self setValue:filter forParameter:NSStringFromSelector(_cmd)];
        }
        
        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSUInteger limit))limit {
    return ^PNFetchMembershipsAPICallBuilder * (NSUInteger limit) {
        [self setValue:@(limit) forParameter:NSStringFromSelector(_cmd)];
        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSString *name))start {
    return ^PNFetchMembershipsAPICallBuilder * (NSString *start) {
        if ([start isKindOfClass:[NSString class]] && start.length) {
            [self setValue:start forParameter:NSStringFromSelector(_cmd)];
        }

        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSString *uuid))uuid {
    return ^PNFetchMembershipsAPICallBuilder * (NSString *uuid) {
        if ([uuid isKindOfClass:[NSString class]] && uuid.length) {
            [self setValue:uuid forParameter:NSStringFromSelector(_cmd)];
        }

        return self;
    };
}

- (PNFetchMembershipsAPICallBuilder * (^)(NSString *end))end {
    return ^PNFetchMembershipsAPICallBuilder * (NSString *end) {
        if ([end isKindOfClass:[NSString class]] && end.length) {
            [self setValue:end forParameter:NSStringFromSelector(_cmd)];
        }
        
        return self;
    };
}


#pragma mark - Execution

- (void(^)(PNFetchMembershipsCompletionBlock block))performWithCompletion {
    return ^(PNFetchMembershipsCompletionBlock block) {
        [super performWithBlock:block];
    };
}

#pragma mark -


@end
