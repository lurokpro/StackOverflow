//
//  Question.m
//  StackOverflow
//
//  Created by Сергей Мирошниченко on 13/05/2019.
//  Copyright © 2019 Сергей Мирошниченко. All rights reserved.
//

#import "Question.h"
#import "Config.h"


@implementation Question

- (instancetype)initWithID:(NSInteger)identifier
                     owner:(NSString *)owner
                     title:(NSString *)title
                      tags:(NSArray *)tags
              profileImage:(NSString *)profileImage {
    
    if (!(self = [self init]))
        return nil;
    
    _identifier = identifier;
    _owner = owner;
    _title = title;
    _tags = tags;
    _profileImage = profileImage;
    
    return self;
}

+ (instancetype)questionFromManagedObject:(NSManagedObject *)questionManagedObject {
    NSArray *tags = [[questionManagedObject valueForKey:GStackOverflowCoreDataAttribute_Question_Tags] componentsSeparatedByString:@" "];
    
    Question *question = [[Question alloc] initWithID:[[questionManagedObject valueForKey:GStackOverflowCoreDataAttribute_Question_Identifier] integerValue]
                                                  owner:[questionManagedObject valueForKey:GStackOverflowCoreDataAttribute_Question_Owner]
                                                  title:[questionManagedObject valueForKey:GStackOverflowCoreDataAttribute_Question_Title]
                                                   tags:tags
                                           profileImage:[questionManagedObject valueForKey:GStackOverflowCoreDataAttribute_Question_Profile_Image]];
    
    return question;
}

- (void)updateManagedObject:(NSManagedObject *__autoreleasing *)questionManagedObject {
    [*questionManagedObject setValue:@(self.identifier) forKey:GStackOverflowCoreDataAttribute_Question_Identifier];
    [*questionManagedObject setValue:self.owner forKey:GStackOverflowCoreDataAttribute_Question_Owner];
    [*questionManagedObject setValue:self.title forKey:GStackOverflowCoreDataAttribute_Question_Title];
    [*questionManagedObject setValue:[self.tags componentsJoinedByString:@" "] forKey:GStackOverflowCoreDataAttribute_Question_Tags];
    [*questionManagedObject setValue:self.profileImage forKey:GStackOverflowCoreDataAttribute_Question_Profile_Image];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
