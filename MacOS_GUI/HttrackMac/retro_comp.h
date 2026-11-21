/** Include this before everything, especially library includes */

#if defined(__clang__) /** vérifie XCode 8 */
#define HAS_XCODE8
#else
#define ON_GCC
#endif

#if defined(RETROCHECK)
#define ON_GCC 1
#endif

#if __has_feature(objc_generics)
# define TYPED_CONTAINER(container, type) container<type>
#else
# define TYPED_CONTAINER(container, type) container
#endif

#if !__has_feature(nullability)
#define nullable 
#endif

