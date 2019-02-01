# Loggie

[![CI Status](http://img.shields.io/travis/infinum/iOS-Loggie.svg?style=flat)](https://travis-ci.org/infinum/iOS-Loggie)
[![Version](https://img.shields.io/cocoapods/v/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)
[![License](https://img.shields.io/cocoapods/l/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)
[![Platform](https://img.shields.io/cocoapods/p/Loggie.svg?style=flat)](http://cocoapods.org/pods/Loggie)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Xcode 8
- iOS 8

## Usage

##### 1. Register custom `LoggieURLProtocol` in the `application:didFinishLaunchingWithOptions` method:

```swift
// Swift
URLProtocol.registerClass(LoggieURLProtocol.self)
```

```objective-c
// Objective-C
[NSURLProtocol registerClass:[LoggieURLProtocol class]];
```

##### 2. If you use `NSURLSession` (or AFNetworking/Alamofire) make sure that you use `loggieSessionConfiguration`:

```swift
// Swift
URLSession(configuration: URLSessionConfiguration.loggie)
```

```objective-c
// Objective-C
[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration loggieSessionConfiguration]];
```

##### 3. At the point where you want to display network logs, you can just put the following line:

```swift
// Swift
LoggieManager.shared.showLogs(from: viewController)
```

```objective-c
// Objective-C
[[LoggieManager sharedManager] showLogsFromViewController:viewController filter:nil];
```

#### You can create custom output or UI to show network logs. To get an array of all network logs just call:

```swift
// Swift
let logs = LoggieManager.shared.logs
```

```objective-c
// Objective-C
NSArray<Log *> *array = [[LoggieManager sharedManager] logs];
```

If you would like to receive notifications when new logs are added to the list, your app can observe `LoggieDidUpdateLogs` notification.

## Important:
Please make sure that `LogieURLProtocol` and `loggieSessionConfiguration` are not used in production builds.

## Installation

Loggie is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Loggie"
```

## Author

Filip Beć, filip.bec@gmail.com

## Credits

Maintained and sponsored by [Infinum](http://www.infinum.co).

![Infinum logo](https://cloud.githubusercontent.com/assets/1422973/24369980/9c36b0a6-12da-11e7-898a-b711ed7ca52f.png)

## License

Loggie is available under the MIT license. See the LICENSE file for more info.
