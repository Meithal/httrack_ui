/** Include this before your own headers and after library headers */

#if __has_feature(objc_generics)
# define TYPED_CONTAINER(container, type) container<type>
#else
# define TYPED_CONTAINER(container, type) container
#endif

#if !__has_feature(nullability)
#define nullable 
#endif
