Background Location Update Programming for iOS 7 and iOS 8
==============

Most of the solutions before iOS 7 work well because during that time the system does not 
have multitasking and the system does not automatically move the app from background mode 
to suspended mode.

So, if your app needs consistent location update from the device, you will have to 
implement a solution that constantly refresh the app when it is in background mode so that 
it has a short period of time in executing the code and send the location to your server.

I have personally used a few weeks of time in testing various solutions that I found from 
StackOverFlow and also Apple Developer Forum but I didn't have much luck. 

I only managed to get the consistent location update on the background in iOS 7 by 
combining a few solutions together with my own tweaks.

The solution that I am provided might not be elegant but it is able to do what I need to
do. I am constantly looking for a better solution when I have time. 

I am glad that this solution helps some other iOS developers who are developing location 
based application. So far, this is the most popular post on my blog. If you have any question, you may join us for a discussion here: [Background Location Update Programming for iOS 7 and 8](http://mobileoop.com/background-location-update-programming-for-ios-7 "Background Location Update Programming for iOS 7 and 8").

<strong>Update on 26 September 2014</strong>: I have updated the solution to work on iOS 8. 

<strong>Update on 14 October 2014</strong>: I have Moved the delay10Seconds timer to become a share property. 

Personal Note
==============
I have used a lot of my personal time in experimenting/learning the Core Location APIs and share the solution for FREE. If my article and solution on Github helps you, please consider to donate. Donation will motivate myself to work harder in sharing more and helping more people. You may find the donation box on my website: http://mobileoop.com/

Thanks.
Ricky
