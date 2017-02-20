#pragma mark - SingletonMacro

#define SINGLETON_FOR_HEADER \
\
+ (instancetype)getInstance;


#define SINGLETON_FOR_CLASS \
\
+ (instancetype)getInstance { \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
}
