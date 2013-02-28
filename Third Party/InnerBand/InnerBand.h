//
//  InnerBand
//
//  InnerBand - Making the iOS SDK greater from within!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@class CoreDataStore;





NSNumber *IB_BOX_BOOL(BOOL x);
NSNumber *IB_BOX_INT(NSInteger x);
NSNumber *IB_BOX_SHORT(short x);
NSNumber *IB_BOX_LONG(long x);
NSNumber *IB_BOX_UINT(NSUInteger x);
NSNumber *IB_BOX_FLOAT(float x);
NSNumber *IB_BOX_DOUBLE(double x);

BOOL IB_UNBOX_BOOL(NSNumber *x);
NSInteger IB_UNBOX_INT(NSNumber *x);
short IB_UNBOX_SHORT(NSNumber *x);
long IB_UNBOX_LONG(NSNumber *x);
NSUInteger IB_UNBOX_UINT(NSNumber *x);
float IB_UNBOX_FLOAT(NSNumber *x);
double IB_UNBOX_DOUBLE(NSNumber *x);


NSString *IB_STRINGIFY_BOOL(BOOL x);
NSString *IB_STRINGIFY_INT(NSInteger x);
NSString *IB_STRINGIFY_SHORT(short x);
NSString *IB_STRINGIFY_LONG(long x);
NSString *IB_STRINGIFY_UINT(NSUInteger x);
NSString *IB_STRINGIFY_FLOAT(float x);
NSString *IB_STRINGIFY_DOUBLE(double x);


CGRect IB_RECT_WITH_X(CGRect rect, float x);
CGRect IB_RECT_WITH_Y(CGRect rect, float y);
CGRect IB_RECT_WITH_X_Y(CGRect rect, float x, float y);

CGRect IB_RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height);
CGRect IB_RECT_WITH_WIDTH(CGRect rect, float width);
CGRect IB_RECT_WITH_HEIGHT(CGRect rect, float height);
CGRect IB_RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height);

CGRect IB_RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom);
CGRect IB_RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom);
CGRect IB_RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right);

CGRect IB_RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset);
CGRect IB_RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset);


UIImage *IB_IMAGE(NSString *name);
NSURL *IB_URL(NSString *urlString);


double IB_DEG_TO_RAD(double degrees);
double IB_RAD_TO_DEG(double radians);

NSInteger IB_CONSTRAINED_INT_VALUE(NSInteger val, NSInteger min, NSInteger max);
float IB_CONSTRAINED_FLOAT_VALUE(float val, float min, float max);
double IB_CONSTRAINED_DOUBLE_VALUE(double val, double min, double max);


BOOL IB_IS_EMPTY_STRING(NSString *str);
BOOL IB_IS_POPULATED_STRING(NSString *str);


float IB_RGB256_TO_COL(NSInteger rgb);
NSInteger IB_COL_TO_RGB256(float col);


NSString *IB_DOCUMENTS_DIR(void);


BOOL IB_IS_IPAD(void);
BOOL IB_IS_IPHONE(void);

BOOL IB_IS_MULTITASKING_AVAILABLE(void);
BOOL IB_IS_CAMERA_AVAILABLE(void);
BOOL IB_IS_GAME_CENTER_AVAILABLE(void);
BOOL IB_IS_EMAIL_ACCOUNT_AVAILABLE(void);
BOOL IB_IS_GPS_ENABLED(void);
BOOL IB_IS_GPS_ENABLED_ON_DEVICE(void);
BOOL IB_IS_GPS_ENABLED_FOR_APP(void);


void IB_DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void IB_DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)());
void IB_DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)());




CG_EXTERN void CGContextAddRoundedRect(CGContextRef ccontext, CGRect rect, CGFloat radius);
CG_EXTERN void CGContextAddRoundedRectComplex(CGContextRef ccontext, CGRect rect, const CGFloat radiuses[]);





#define HEIGHT_OF_STATUS_BAR 20
#define HEIGHT_OF_TOOLBAR 44
#define HEIGHT_OF_TABLE_CELL 44
#define HEIGHT_OF_TAB_BAR 49
#define HEIGHT_OF_SEARCH_BAR 44
#define HEIGHT_OF_NAVIGATION_BAR 44
#define HEIGHT_OF_TEXTFIELD 31
#define HEIGHT_OF_PICKER 216
#define HEIGHT_OF_KEYBOARD 216
#define HEIGHT_OF_SEGMENTED_CONTROL 43
#define HEIGHT_OF_SEGMENTED_CONTROL_BAR 29
#define HEIGHT_OF_SEGMENTED_CONTROL_BEZELED 40
#define HEIGHT_OF_SWITCH 27
#define HEIGHT_OF_SLIDER 22
#define HEIGHT_OF_PROGRESS_BAR 9
#define HEIGHT_OF_PAGE_CONTROL 36
#define HEIGHT_OF_BUTTON 37


#define SECONDS_IN_MINUTE 60
#define SECONDS_IN_HOUR 3600
#define SECONDS_IN_DAY 86400
#define SECONDS_IN_WEEK 604800
#define MINUTES_IN_HOUR 60
#define HOURS_IN_DAY 24
#define DAYS_IN_WEEK 7




#define L(key) (NSLocalizedString((key), nil))



typedef NSInteger (^ib_enum_bool_t)(id);
typedef id (^ib_enum_id_t)(id);
typedef void (^ib_http_proc_t)(NSData *, NSInteger);



#import <Foundation/Foundation.h>

@interface IBActionSheet : UIActionSheet <UIActionSheetDelegate> {
    void (^actionBlock_)(NSInteger);
    void (^cancelBlock_)();
}

- (id)initWithTitle:(NSString *)title cancelBlock:(void (^)(void))cancelBlock  actionBlock:(void (^)(NSInteger))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end



#import <UIKit/UIKit.h>

@interface IBAlertView : UIAlertView <UIAlertViewDelegate> {
    void (^okCallback_)(void);
    void (^dismissCallback_)(void);
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;

+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message dismissBlock:(void (^)(void))dismissBlock;
+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message;

@end




#import <Foundation/Foundation.h>

@interface IBCoreTextLabel : UIControl {
	UIColor *_textColor;
	
	NSString *_text;
	NSMutableAttributedString *_attrStr;
	
	NSMutableArray *_boldRanges;
	NSMutableArray *_italicRanges;
	NSMutableArray *_fontRanges;
	NSMutableArray *_underlineRanges;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, readonly) float measuredHeight;

@end



#import <UIKit/UIKit.h>

@interface IBHTMLLabel : UIWebView {
	NSString *_text;
	UITextAlignment _textAlignment;
	UIColor *_textColor;
	UIColor *_linkColor;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UITextAlignment textAlignment;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *linkColor;

@end



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IBCoreDataStore : NSObject {
	NSManagedObjectContext *_managedObjectContext;	
}

@property (nonatomic, readonly) NSManagedObjectContext *context;

+ (IBCoreDataStore *)mainStore;
+ (IBCoreDataStore *)createStore;
+ (IBCoreDataStore *)createStoreWithContext:(NSManagedObjectContext *)context;

- (id)initWithContext:(NSManagedObjectContext *)context;

/* Clears all data from peristent store and re-initializes (great for unit testing!) */
- (void)clearAllData;

/* Saves context. */
- (void)save;

/* Create a new entity by name. */
- (NSManagedObject *)createNewEntityByName:(NSString *)entityName;

/* Remove entity. */
- (void)removeEntity:(NSManagedObject *)entity;

/* Remove all objects of an entity. */
- (void)removeAllEntitiesByName:(NSString *)entityName;


/* Returns ALL objects for an entity. */
- (NSArray *)allForEntity:(NSString *)entityName error:(NSError **)error;

/* Returns ALL objects for an entity given a predicate. */
- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

/* Returns ALL objects for an entity given a predicate and sorting. */
- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error;

/* Returns ALL objects for an entity ordered by a field. */
- (NSArray *)allForEntity:(NSString *)entityName orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error;



/* Returns a single entity by name. */
- (NSManagedObject *)entityByName:(NSString *)entityName error:(NSError **)error;

/* Returns a single entity with the specified key/value. */
- (NSManagedObject *)entityByName:(NSString *)entityName key:(NSString *)key value:(NSObject *)value error:(NSError **)error;



/* Returns object based on URI representation. */
- (NSManagedObject *)entityByURI:(NSURL *)uri;

/* Returns object based on Object ID. */
- (NSManagedObject *)entityByObjectID:(NSManagedObjectID *)oid;



/* Returns an entity description by name. */
- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName;


@end



#import <Foundation/Foundation.h>


@interface IBDispatchMessage : NSObject {
    NSMutableDictionary *userInfo_;
}

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *userInfo;
@property (nonatomic, assign, getter=isAsynchronous) BOOL asynchronous;

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
- (id)initWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
+ (id)messageWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)name;
- (NSDictionary *)userInfo;

- (void)setUserInfoValue:(id)value forKey:(NSString *)key;

- (void)inputData:(NSData *)input;
- (NSData *)outputData;

@end



#import <Foundation/Foundation.h>

@class IBDispatchMessage;

@interface IBMessageCenter : NSObject {
}

+ (NSInteger)getCountOfListeningSources;

+ (void)setDebuggingEnabled:(BOOL)enabled;
+ (BOOL)isDebuggingEnabled;
	
+ (void)addGlobalMessageListener:(NSString *)name target:(id)target action:(SEL)action;
+ (void)addMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action;

+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target action:(SEL)action;
+ (void)removeMessageListener:(NSString *)name source:(id)source target:(id)target;
+ (void)removeMessageListener:(NSString *)name target:(id)target action:(SEL)action;
+ (void)removeMessageListenersForTarget:(id)name;

+ (void)sendGlobalMessage:(IBDispatchMessage *)message;
+ (void)sendGlobalMessageNamed:(NSString *)name;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value;
+ (void)sendGlobalMessageNamed:(NSString *)name withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sendMessage:(IBDispatchMessage *)message forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfoKey:(id)key andValue:(id)value forSource:(id)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(id)source withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end



#import <Foundation/Foundation.h>

@class IBDispatchMessage;

@interface IBMessageProcessor : NSObject {
	IBDispatchMessage *_message;
	NSArray *_targetActions;
}

- (id)initWithMessage:(IBDispatchMessage *)message targetActions:(NSArray *)targetActions;
- (void)process;

@end



#import <Foundation/Foundation.h>

@interface IBTargetAction : NSObject

@property (nonatomic, assign) NSObject *target;
@property (nonatomic, copy) NSString *action;

@end



#import <Foundation/Foundation.h>

@interface NSArray (InnerBand)

- (NSArray *)sortedArrayAsDiacriticInsensitiveCaseInsensitive;
- (NSArray *)sortedArrayAsDiacriticInsensitive;
- (NSArray *)sortedArrayAsCaseInsensitive;
- (NSArray *)sortedArray;

- (NSArray *)reversedArray;
- (NSArray *)shuffledArray;

- (id)firstObject;

- (NSArray *)map:(ib_enum_id_t)blk;

@end



#import <UIKit/UIKit.h>


@interface NSDate (InnerBand)

@property (nonatomic, readonly) NSInteger utcYear;
@property (nonatomic, readonly) NSInteger utcMonth;
@property (nonatomic, readonly) NSInteger utcDay;
@property (nonatomic, readonly) NSInteger utcHour;
@property (nonatomic, readonly) NSInteger utcMinute;
@property (nonatomic, readonly) NSInteger utcSecond;

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;

- (NSDate *)dateByAddingSeconds:(NSInteger)numSeconds;
- (NSDate *)dateByAddingMinutes:(NSInteger)numMinutes;
- (NSDate *)dateByAddingHours:(NSInteger)numHours;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateByAddingWeeks:(NSInteger)numWeeks;
- (NSDate *)dateByAddingMonths:(NSInteger)numMonths;
- (NSDate *)dateByAddingYears:(NSInteger)numYears;

- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle;
- (NSString *)formattedTimeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedDatePattern:(NSString *)datePattern;

- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle;
- (NSString *)formattedUTCTimeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedUTCDatePattern:(NSString *)datePattern;

- (NSDate *)dateAsMidnight;

- (BOOL)isSameDay:(NSDate *)rhs;

@end



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (InnerBand)


+ (id)create;
+ (id)createInStore:(IBCoreDataStore *)store;


+ (NSArray *)all;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allInStore:(IBCoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate inStore:(IBCoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inStore:(IBCoreDataStore *)store;

+ (id)first;
+ (id)firstWithKey:(NSString *)key value:(NSObject *)value;

+ (id)firstInStore:(IBCoreDataStore *)store;
+ (id)firstWithKey:(NSString *)key value:(NSObject *)value inStore:(IBCoreDataStore *)store;


+ (void)destroyAll;
+ (void)destroyAllInStore:(IBCoreDataStore *)store;

- (void)destroy;

@end



#import <Foundation/Foundation.h>

@interface NSMutableArray (InnerBand)

+ (NSMutableArray *)arrayUnretaining;

- (void)sortDiacriticInsensitiveCaseInsensitive;
- (void)sortDiacriticInsensitive;
- (void)sortCaseInsensitive;

- (void)pushObject:(id)obj;
- (id)popObject;
- (id)shiftObject;
- (void)unshiftObject:(id)obj;

- (void)deleteIf:(ib_enum_bool_t)blk;

- (void)shuffle;
- (void)reverse;

@end



#import <Foundation/Foundation.h>

@interface NSMutableString (InnerBand)

- (void)trim;

@end



#import <UIKit/UIKit.h>


@interface NSNumber (InnerBand)

- (NSString *)formattedCurrency;
- (NSString *)formattedFlatCurrency;
- (NSString *)formattedCurrencyWithMinusSign;
- (NSString *)formattedDecimal;
- (NSString *)formattedFlatDecimal;
- (NSString *)formattedSpellOut;
	
@end



#import <UIKit/UIKit.h>


@interface NSObject (InnerBand)

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

@end



#import <Foundation/Foundation.h>

typedef enum {
    kGTMXMLCharModeEncodeQUOT  = 0,
    kGTMXMLCharModeEncodeAMP   = 1,
    kGTMXMLCharModeEncodeAPOS  = 2,
    kGTMXMLCharModeEncodeLT    = 3,
    kGTMXMLCharModeEncodeGT    = 4,
    kGTMXMLCharModeValid       = 99,
    kGTMXMLCharModeInvalid     = 100,
} IBXMLCharMode;

@interface NSString (Encoding)

- (NSString *)stringWithURLEncodingUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)stringWithXMLSanitizingAndEscaping;
- (NSString *)stringWithXMLSanitizing;

@end



#import <Foundation/Foundation.h>


@interface NSString (InnerBand)

- (NSComparisonResult)diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)diacriticInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)caseInsensitiveSort:(NSString *)rhs;

- (NSString *)asBundlePath;
- (NSString *)asDocumentsPath;
	
- (BOOL)contains:(NSString *)substring;
- (BOOL)contains:(NSString *)substring options:(NSStringCompareOptions)options;

- (NSString *)trimmedString;

@end



#import <Foundation/Foundation.h>

@interface UIColor (Hex)

+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a;

/*usage
 RGBA style hex value
 UIColor *solidColor = [UIColor colorWithRGBA:0xFF0000FF];
 UIColor *alphaColor = [UIColor colorWithRGBA:0xFF000099];
 */
+ (UIColor *) colorWithRGBA:(uint) hex;

/*usage
 ARGB style hex value
 UIColor *alphaColor = [UIColor colorWithHex:0x99FF0000];
 */
+ (UIColor *) colorWithARGB:(uint) hex;

/*usage
 RGB style hex value, alpha set to full
 UIColor *solidColor = [UIColor colorWithHex:0xFF0000];
 */
+ (UIColor *) colorWithRGB:(uint) hex;

/*usage 
 UIColor *solidColor = [UIColor colorWithWeb:@"#FF0000"];
 safe to omit # sign as well
 UIColor *solidColor = [UIColor colorWithWeb:@"FF0000"];
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *) hexString;

- (UIColor*) colorBrighterByPercent:(float) percent;
- (UIColor*) colorDarkerByPercent:(float) percent;

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

@end



#import <UIKit/UIKit.h>


@interface UIImage (InnerBand)

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

@end



#import <UIKit/UIKit.h>

@interface UIView (InnerBand)

- (CGFloat)left;
- (void)setLeft:(CGFloat)x;
- (CGFloat)top;
- (void)setTop:(CGFloat)y;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;
- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

@property (nonatomic, assign) BOOL visible;

@end



#import <Foundation/Foundation.h>


@interface IBViewUtil : NSObject {
}

/**
 This function is very handy for loading an instance of a specified class from a specified NIB
 file.  It's sorta like UIView initWithNibName, but more general purpose.  Very useful for loading
 UITableViewCells from NIB files, e.g.:
 
 MessageCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MessageCell"];
 if (cell == nil) {
 cell = [ViewUtil loadInstanceOfView:[MessageCell class] fromNibNamed:@"MessageCell"];
 }
 **/
+ (id)loadInstanceOfView:(Class)clazz fromNibNamed:(NSString *)name;

@end




@interface IBBlockBasedDispatchMessage : IBDispatchMessage {
    void (^inputBlock_)(NSData *);
    NSData *(^outputBlock_)(void);
}

+ (id)messageWithName:(NSString *)name isAsynchronous:(BOOL)isAsync input:(void (^)(NSData *))inputBlock output:(NSData * (^)(void))outputBlock;

@end



#import <Foundation/Foundation.h>

/*
 * 
 * IBMessageCenter will dispatch an HTTPGetRequestMessage after it processes the URL request you provide it.
 * When specifying a URL, you can provide substitution parameters using the syntax [MYPARAM] and
 * then providing the values for those parameters in the userInfo dictionary.
 *
 * INPUT: none
 * OUTPUT: the HTTP response data on success, nil on error
 *
 * USER INFO:
 *    HTTP_STATUS_CODE - HTTP status code of result
 *
 */

#define HTTP_STATUS_CODE @"HTTP_STATUS_CODE"

@interface IBHTTPGetRequestMessage : IBDispatchMessage {
	NSString *_url;
	NSMutableData *_responseData;
	NSMutableDictionary *_headersDict;
    ib_http_proc_t _processBlock;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url processBlock:(ib_http_proc_t)processBlock;

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key;

@end



#import <Foundation/Foundation.h>

#define HTTP_STATUS_CODE @"HTTP_STATUS_CODE"

@interface IBHTTPPostRequestMessage : IBDispatchMessage {
	NSString *_url;
    NSString *_body;
	NSMutableData *_responseData;
	NSMutableDictionary *_headersDict;
    ib_http_proc_t _processBlock;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body processBlock:(ib_http_proc_t)processBlock;

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key;

@end



#import <Foundation/Foundation.h>

@interface IBSequencedMessage : IBDispatchMessage {
	NSMutableArray *_messageSequence;
	NSData *_outputOfLastMessage;
}

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence;

@end

