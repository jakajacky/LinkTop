
#import "DCProperty.h"
#import "DCObject.h"
#import "DCObjectMacros.h"

@implementation DCProperty

- (instancetype)initWithObjcProperty:(objc_property_t)p
{
  self = [super init];
  
  if (self) {
    _isAtomic = YES;
    _name     = @(property_getName(p));
    
    NSString *propAttr = @(property_getAttributes(p));
    
    NSRange r1 = [propAttr rangeOfString:@","];
    NSRange r2 = [propAttr rangeOfString:@",V"];
    
    NSString *typeString = [propAttr substringWithRange:NSMakeRange(1, r1.location - 1)];
    NSString *attrString = nil;
    
    if (r2.length == 0) {
      attrString = [propAttr substringFromIndex:r1.location + 1];
    }
    else if (r2.location > r1.location) {
      attrString = [propAttr substringWithRange:NSMakeRange(r1.location + 1, MAX(0, r2.location - r1.location - 1))];
    }
    
    if      ([typeString isEqualToString:@"B"])  { _type = kDCPropertyTypeBOOL;            }
    else if ([typeString isEqualToString:@"c"])  { _type = kDCPropertyTypeChar;            }
    else if ([typeString isEqualToString:@"d"])  { _type = kDCPropertyTypeDouble;          }
    else if ([typeString isEqualToString:@"f"])  { _type = kDCPropertyTypeFloat;           }
    else if ([typeString isEqualToString:@"i"])  { _type = kDCPropertyTypeInt;             }
    else if ([typeString isEqualToString:@"l"])  { _type = kDCPropertyTypeLong;            }
    else if ([typeString isEqualToString:@"q"])  { _type = kDCPropertyTypeLongLong;        }
    else if ([typeString isEqualToString:@"s"])  { _type = kDCPropertyTypeShort;           }
    else if ([typeString isEqualToString:@"I"])  { _type = kDCPropertyTypeUInt;            }
    else if ([typeString isEqualToString:@"Q"])  { _type = kDCPropertyTypeUInt;            }
    else if ([typeString isEqualToString:@"^b"]) { _type = kDCPropertyTypeBOOLPointer;     }
    else if ([typeString isEqualToString:@"^c"]) { _type = kDCPropertyTypeCharPointer;     }
    else if ([typeString isEqualToString:@"^d"]) { _type = kDCPropertyTypeDoublePointer;   }
    else if ([typeString isEqualToString:@"^f"]) { _type = kDCPropertyTypeFloatPointer;    }
    else if ([typeString isEqualToString:@"^i"]) { _type = kDCPropertyTypeIntPointer;      }
    else if ([typeString isEqualToString:@"^l"]) { _type = kDCPropertyTypeLongPointer;     }
    else if ([typeString isEqualToString:@"^q"]) { _type = kDCPropertyTypeLongLongPointer; }
    else if ([typeString isEqualToString:@"^s"]) { _type = kDCPropertyTypeShortPointer;    }
    else if ([typeString isEqualToString:@"^v"]) { _type = kDCPropertyTypeVoidPointer;     }
    else if ([typeString isEqualToString:@"^I"]) { _type = kDCPropertyTypeUIntPointer;     }
    else if ([typeString isEqualToString:@"^Q"]) { _type = kDCPropertyTypeUIntPointer;     }
    else if ([typeString isEqualToString:@"^?"]) { _type = kDCPropertyTypeBlock;           }
    else if ([typeString isEqualToString:@"@"])  { _type = kDCPropertyTypeId;              }
    else if ([typeString hasPrefix:@"@"]) {
      _type = [typeString substringWithRange:NSMakeRange(2, typeString.length - 3)];
      _isExplicitInstance = YES;
    }
    else if ([typeString hasPrefix:@"{"] && [typeString hasSuffix:@"}"]) {
      NSRange r = [typeString rangeOfString:@"="];
      NSString *type = [typeString substringWithRange:NSMakeRange(1, r.location - 1)];
      _type = [NSString stringWithFormat:@"struct %@", type];
    }
    else if ([typeString hasPrefix:@"("] && [typeString hasSuffix:@")"]) {
      NSRange r = [typeString rangeOfString:@"="];
      NSString *type = [typeString substringWithRange:NSMakeRange(1, r.location - 1)];
      _type = [NSString stringWithFormat:@"union %@", type];
    }
    else if ([typeString hasPrefix:@"^{"] && [typeString hasSuffix:@"}"]) {
      NSRange r = [typeString rangeOfString:@"="];
      NSString *type = [typeString substringWithRange:NSMakeRange(2, r.location - 2)];
      _type = [NSString stringWithFormat:@"struct %@ *", type];
    }
    else if ([typeString hasPrefix:@"^("] && [typeString hasSuffix:@")"]) {
      NSRange r = [typeString rangeOfString:@"="];
      NSString *type = [typeString substringWithRange:NSMakeRange(2, r.location - 2)];
      _type = [NSString stringWithFormat:@"union %@ *", type];
    }
    else {
      NSAssert(false, @"Cannot verify 'type' for DCProperty.");
    }
    
    NSArray *attributes = [attrString componentsSeparatedByString:@","];
    for (NSString *attr in attributes) {
      if      ([attr isEqualToString:@"R"]) { _isReadonly   = YES;                          }
      else if ([attr isEqualToString:@"W"]) { _assignedType = DCPropertyAssignedTypeWeak;   }
      else if ([attr isEqualToString:@"C"]) { _assignedType = DCPropertyAssignedTypeCopy;   }
      else if ([attr isEqualToString:@"&"]) { _assignedType = DCPropertyAssignedTypeStrong; }
      else if ([attr isEqualToString:@"N"]) { _isAtomic     = NO;                           }
      else if ([attr hasPrefix:@"G"])       { _customGetter = [attr substringFromIndex:1];  }
      else if ([attr hasPrefix:@"S"])       { _customSetter = [attr substringFromIndex:1];  }
    }
  }
  
  return self;
}

- (NSString *)description
{
  NSMutableString *output = [NSMutableString stringWithString:@"@property"];
  
  [output appendString:@" ("];
  [output appendString: self.isAtomic ? @"atomic, " : @"nonatomic, "];
  [output appendString: self.isReadonly ? @"readonly, " : @"readwrite, "];
  
  switch (self.assignedType) {
    case DCPropertyAssignedTypeWeak:
      [output appendString:@"weak, "];
      break;
    case DCPropertyAssignedTypeStrong:
      [output appendString:@"strong, "];
      break;
    case DCPropertyAssignedTypeCopy:
      [output appendString:@"copy, "];
      break;
    default:
      break;
  }
  
  if (self.customGetter) {
    [output appendFormat:@"getter=%@, ", self.customGetter];
  }
  
  if (self.customSetter) {
    [output appendFormat:@"setter=%@, ", self.customSetter];
  }
  
  [output deleteCharactersInRange:NSMakeRange(output.length - 2, 2)];
  
  [output appendString:@") "];
  [output appendFormat:@"%@ ", self.type];
  
  if (self.isExplicitInstance) {
    [output appendString:@"* "];
  }
  
  [output appendString:self.name];
  
  return output;
}

- (BOOL)isSubclassOfDCObject
{
  return [NSClassFromString(self.type) isSubclassOfClass:[DCObject class]];
}

@end
