#import "PNBaseObjectsRequest.h"
#import "PNRequestParameters.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Private interface declaration

/**
 * @brief Private \c base request extension to provide access to identifiable instance
 * initialization.
 *
 * @author Serhii Mamontov
 * @version 4.14.0
 * @since 4.14.0
 * @copyright © 2010-2020 PubNub, Inc.
 */
@interface PNBaseObjectsRequest (Private)


#pragma mark - Information

/**
 * @brief Whether entity identifier required to complete request or not.
 */
@property (nonatomic, readonly, assign) BOOL identifierRequired;

/**
 * @brief Unique \c object identifier.
 */
@property (nonatomic, copy) NSString *identifier;

/**
 * @brief Bitfield set to fields which should be returned with response.
 *
 * @note Available values depends from object type for which request created. So far following
 *   helper \a types available: \b PNMembershipFields, \b PNChannelMemberFields,
 *   \b PNChannelFields, \b PNUUIDFields.
 */
@property (nonatomic, assign) NSUInteger includeFields;


#pragma mark - Initialization & Configuration

/**
 * @brief Initialize \c base request for identifiable object.
 *
 * @param objectType Name of object type (so far known: \c UUID and \c Channel).
 * @param identifier Identifier of \c object for which request created.
 *
 * @return Initialized and ready to use \c request.
 */
- (instancetype)initWithObject:(NSString *)objectType identifier:(nullable NSString *)identifier;


#pragma mark - Misc

/**
 * @brief Add another data field to 'include' query fields set.
 *
 * @param fields List of names of data fields which should be added to 'include' list.
 * @param requestParameters Request's parameters object which is used to build actual network
 * request.
 */
- (void)addIncludedFields:(NSArray<NSString *> *)fields
                toRequest:(PNRequestParameters *)requestParameters;

#pragma mark -


@end

NS_ASSUME_NONNULL_END
