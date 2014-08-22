tutorial app from "Learn iOS 7 App Development" by James Bucanek
chapter 13: simple networking

* iOS 7 makes it pretty easy to share on popular networking sites such as FB, Twitter, etc.
* just create an NSArray of objects to be shared and hand the array off to UIActivityViewController, which takes care of the rest
* the activities mean "social networking" services (FB, Twitter ...)
* the activities can be custom made to conform to non-popular (your own) services
* messages shared can be tailored pretty well to each service's requirements, such as 140-character limit in Twitter
* MFMailComposeViewController is an older API that allows customized mail message (HTML'ed body, BCC, ...etc.) If used, be sure to import "<Social/Social.h>"

