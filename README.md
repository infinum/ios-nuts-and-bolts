# iOS Nuts And Bolts

[![Build Status](https://app.bitrise.io/app/fb7e6e08b49676bc/status.svg?token=NQnTFTVDwqpKM6QgA0Mn7g)](https://app.bitrise.io/app/fb7e6e08b49676bc)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://www.swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-11.0-green.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/cocoapods/l/SemanticVersioning.svg)](https://github.com/infinum/iOS-Nuts-And-Bolts/blob/master/LICENSE.md)


<p align="center">
    <img src="nuts-and-bolts.svg" width="300" max-width="50%" alt="Japx"/>
</p>

Collection of commonly shared and reused code throughout the Infinum iOS team.

## Features

<details>
<summary><big><b>Networking</b></big></summary>
<hr />
Used for easier implementation of networking features.

* **Router** - Base API routing containing shared logic for all routers.
* **Encoding** - Request params with associated encoding.
* **Adapters** - Adapters used for both basic and token authentication.
* **Service** - Base protocol for API networking communication.
* **Rx** - Reactive implementation of networking communication.
* **JSONAPI** - Used for handling JSON:API networking.
* **Headers** - commonly used request headers
<br/><br/>
</details>

<details>
<summary><big><b>Database</b></big></summary>
<hr />
Used for easier implementation of storage features.

* **Database** - High level component that should generally be interacted with. This hides unnecessary details of Realm and exposes good usage patterns.
* **Schema Migration** - A way to design your Realm schema that supports migrations. (integrated within the Database component)
* **Various Extensions** - Various Realm extensions that are commonly used
* **Async/Await** - async/await support for accessing Realm
* **Combine** - Combine support for accessing Realm

None of the methods are marked public intentionally. All components are imagined to be in a separate `Storage` module. `Storage` module should expose simple interface for the main app.

`ModelMapped` protocol allows mapping of Domain object to DB objects. This way Realm objects remain internal to `Storage` module and the rest of the app doesn't know about them.

<br/><br/>
</details>

<details>
<summary><big><b>RxCocoa</b></big></summary>
<hr />
Extensions useful when dealing with all things Cocoa, in a reactive way.
<br/><br/>
</details>

<details>
<summary><big><b>RxSwift</b></big></summary>
<hr />

Extensions for *Observables* and *Singles* which will make your reactive life a little easier.
<br/><br/>
</details>

<details>
<summary><big><b>Foundation</b></big></summary>
<hr />

Wide range of useful extensions and computed properties covering many commonly used Foundation features: *Arrays, Strings, Bools, Date, Optional* etc.
<br/><br/>
</details>

<details>
<summary><big><b>UI</b></big></summary>
<hr />

Plenty of extensions of most used UI elements, along with reactive extensions to common UI types such as *UIView*, *UIColor* etc.
<br/><br/>
</details>

<details>
<summary><big><b>Viper interfaces</b></big></summary>
<hr />

Interfaces used for building your application using the VIPER architecture pattern. Its usage is explained in more detail in our [Xcode templates GitHub page](https://github.com/infinum/iOS-VIPER-Xcode-Templates).
<br/><br/>
</details>

<details>
<summary><big><b>Utilities</b></big></summary>
<hr />

Useful classes and methods which help you achieve your goals.

* **Logging** - Used for lightweight logging and debugging during development process.
* **SecurityProtectionManager** - Used for handling the security regarding Jailbreak and Reverse engineering detection.

<br/><br/>
</details>

## Framework manager

[CocoaPods](https://cocoapods.org) - a Ruby-built dependency manager for Swift and Objective-C Cocoa projects. It has over 65 thousand libraries and is used in over 3 million apps.


<details>
<summary><big><b>Third party integrations</b></big></summary>
<hr />

### UI

* **[MBProgressHUD](https://cocoapods.org/pods/MBProgressHUD)** - an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread. The HUD is meant as a replacement for the undocumented, private UIKit UIProgressHUD with some additional features.

### Networking

* **[Alamofire](https://cocoapods.org/pods/Alamofire)** - an HTTP networking library written in Swift.
* **[CodableAlamofire](https://cocoapods.org/pods/CodableAlamofire)** - an extension for Alamofire that converts JSON data into Decodable object.
* **[Japx/RxCodableAlamofire]()** - Lightweight JSON:API parser that flattens complex JSON:API structure and turns it into simple JSON and vice versa.
* **[Loggie]()** - in-app network logging library.

### Reactive

* **[RxSwift](https://cocoapods.org/pods/RxSwift)** -  is a generic abstraction of computation expressed through Observable interface.
* **[RxCocoa](https://cocoapods.org/pods/RxCocoa)** - provides the fundamentals of Observables and provides extensions to the Cocoa and Cocoa Touch frameworks to take advantage of RxSwift.

### Localization

* **[SwiftI18n](https://cocoapods.org/pods/SwiftI18n)** - used for easier localization.

### Testing

* **[RxBlocking](https://cocoapods.org/pods/RxBlocking)** - is set of blocking operators for easy unit testing.
* **[RxTest](https://cocoapods.org/pods/RxTest)** - a test framework published at RxSwift repository.
* **[Nimble](https://cocoapods.org/pods/Nimble)** - used to express the expected outcomes of Swift or Objective-C expressions.
* **[Quick](https://cocoapods.org/pods/Quick)** - behavior-driven development framework for Swift and Objective-C.
* **[RxNimble](https://cocoapods.org/pods/RxNimble)** - Nimble extensions that make unit testing with RxSwift easier.
<br/><br/>
</details>


## Usage

You can find all the features inside the `Sources` folder. Each feature has its sample inside the catalog list or tests written for it, where you can find more info on feature usage.

To explore features feel free to open the `Catalog.xcworkspace` and run Catalog app or go through tests inside `Tests` folder.

## Contributing

Before adding a new feature, please ensure that you:

* Have checked there is no same component already in the catalog. If a similar component already exists, try to upgrade it if needed.
* Have created a sufficient example or wrote tests for it. If the component is for something in UIKit, the example is better, while tests are preferred for Foundation features. Please, take a look at one of the currently available features to grasp the idea.
* Code is structured, well written using standard Swift coding style or check one at our [Coding Style](https://handbook.infinum.co/books/ios/Basics/Coding%20style) handbook.
* All public methods and properties have documentation - comments have to be meaningful and concise.
* Use `public` modifier for all method and properties that could be changed from a user of your feature, and `private` for internal properties. Another reason why `public` is mandatory when using framework based development, only public properties and methods will be visible to the user.
* Remove any reference to the project that piece of code was created in - mostly the project name from header comment in the file.
* Reduce the dependencies to a minimum.

## Adding a new feature

If you are reading this, you probably have a feature PR in mind.

All features should go inside the `Sources` folder, inside an appropriate category (create a new one, if missing). Take a look at already created features to get a feeling on how to sort the things out.

However, before creating a PR with a new chunk of code - create an example or write tests describing how to use your feature.

For UI components we suggest creating an example view controller, while for some Foundation related feature we recommend creating tests - since they will cover how to use the feature and what to expect from it.

### Creating an example

Inside `Catalog/Examples` folder create a new folder (a group backed by folder) with your feature name. Try to put it in some of the current categories or create an appropriate category folder for it.

Create a new view controller (XIB,  Storyboard, Code - whatever floats your boat) inside of a previously created folder. Make your view controller conforms to `Catalogizable` protocol:

```swift
class SomeCoolFeatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Your code here...
    }

}

extension SomeCoolFeatureViewController: Catalogizable {

    static var title: String {
        return "Some Cool Feature"
    }

    static var viewController: UIViewController {
        return SomeCoolFeatureViewController()
        /// Or if creating it from storyboard:
        /// let storyboard = UIStoryboard(name: "SomeStoryboardName", bundle: nil)
        /// return storyboard.instantiateViewController(ofType: SomeCoolFeatureViewController.self)
    }

}
```

To be able to run your example you'll have to add it to the catalog data source - it is on top of the `Catalog/Examples` folder. There should be all available examples in terms of references to example view controllers. Just put your newly created view controller as a reference to some of the provided sections or create an appropriate section for it:

```swift
func _someSectionItems() -> [Catalogizable.Type] {
    return [
        SomeOldFeatureViewController.self,
        SomeCoolFeatureViewController.self,
    ]
}
```

Now run `Catalog` scheme, and you should see your new cool feature on the list and be able to open it.

### Writing tests

If the feature is not UI related, then we recommend writing tests for it. Tests should go inside the `Tests` folder - in appropriate category. On your disposal you have a few testing frameworks: `Quick, Nimble, RxTest, RxBlocking, RxNimble`. Also, you can write your tests in good ol' `XCTest`.

Take a look at currently written tests - and be creative :)
