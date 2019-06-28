# iOS Nuts And Bolts

[![Build Status](https://app.bitrise.io/app/fb7e6e08b49676bc/status.svg?token=NQnTFTVDwqpKM6QgA0Mn7g)](https://app.bitrise.io/app/fb7e6e08b49676bc)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://www.swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-10.0-green.svg)](https://www.apple.com/ios/)

Collection of commonly shared and reused code throughout the team.

## Usage

You can find all the features inside the `Sources` folder. Each feature has its sample inside the catalog list or tests written for it, where you can find more info on feature usage.

To explore features feel free to open the `Catalog.xcworkspace` and run Catalog app or go trough tests inside `Tests` folder.

## Contributing

Before adding a new feature, please ensure that:

* Have checked there is no same component already in the catalog. If a similar component already exists, try to upgrade it if needed.
* Have created a sufficient example or wrote tests for it. If the component is for something in UIKit, the example is better, while tests are preferred for Foundation features. Please, take a look at one of the currently available features to grasp the idea.
* Code is structured, well written using standard Swift coding style or check one at our [Coding Style](https://handbook.infinum.co/books/ios/Basics/Coding%20style) handbook.
* All public methods and properties have documentation - comments have to be meaningful and concise.
* Use `public` modifier for all method and properties that could be changed from a user of your feature, and `private` for internal properties. Another reason why `public` is mandatory when using framework based development, only public properties and methods will be visible to the user.
* Remove any reference to the project that piece of code was created in - mostly the project name from header comment in the file.
* Reduce the dependencies to the minimum.

## Adding a new feature

If you are reading this, you probably have a feature PR in mind.

All features should go inside the `Sources` folder, inside an appropriate category (create a new one, if missing). Take a look at already created features to get a feeling on how to sort the things out.

However, before creating a PR with a new chunk of code - create an example app or write tests describing how to use your feature.

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
        /// return storyboard.instantiateViewController(ofType: SomeCoolFeatureViewController)
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
