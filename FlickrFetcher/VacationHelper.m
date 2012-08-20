//
//  VacationHelper.m
//  FlickrFetcher
//
//  Created by Travis McChesney on 8/16/12.
//
//

#import "VacationHelper.h"
#import "Vacation+Create.h"

@interface VacationHelper()
@property (nonatomic, strong) NSMutableDictionary *vacationDocumentDictionary;
@end

@implementation VacationHelper

@synthesize vacationDocumentDictionary = _vacationDocumentDictionary;

static VacationHelper *instance;

+ (VacationHelper *)instance
{
    @synchronized(self)
    {
        if (!instance)
            instance = [[VacationHelper alloc] init];
    }
    
    return instance;
}

- (NSMutableDictionary *)vacationDocumentDictionary
{
    if (!_vacationDocumentDictionary)
        _vacationDocumentDictionary = [[NSMutableDictionary alloc] init];
    
    return _vacationDocumentDictionary;
}

- (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    UIManagedDocument *vacationDocument = [self.vacationDocumentDictionary objectForKey:vacationName];
    
    if (!vacationDocument) {
        // Create a document for the vacation name and add a vacation entity to it.
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:vacationName];
        vacationDocument = [[UIManagedDocument alloc] initWithFileURL:url];
        
        [self.vacationDocumentDictionary setObject:vacationDocument forKey:vacationName];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[vacationDocument.fileURL path]]) {
        [vacationDocument saveToURL:vacationDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [Vacation vacationWithName:vacationName inManagedObjectContext:vacationDocument.managedObjectContext];
                [vacationDocument saveToURL:vacationDocument.fileURL
                           forSaveOperation:UIDocumentSaveForOverwriting
                          completionHandler:^(BOOL success) {
                              if (success) {
                                  completionBlock(vacationDocument);
                              }
                          }];
            }
        }];
    } else if (vacationDocument.documentState == UIDocumentStateClosed) {
            [vacationDocument openWithCompletionHandler:^(BOOL success) {
                if (success) completionBlock(vacationDocument);
            }];
    } else if (vacationDocument.documentState == UIDocumentStateNormal) {
        completionBlock(vacationDocument);
    }
}

@end
