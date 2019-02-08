# SwiftI18n

[![CI Status](http://img.shields.io/travis/Vlaho Poluta/SwiftI18n.svg?style=flat)](https://travis-ci.org/Vlaho Poluta/SwiftI18n)
[![Version](https://img.shields.io/cocoapods/v/SwiftI18n.svg?style=flat)](http://cocoapods.org/pods/SwiftI18n)
[![License](https://img.shields.io/cocoapods/l/SwiftI18n.svg?style=flat)](http://cocoapods.org/pods/SwiftI18n)
[![Platform](https://img.shields.io/cocoapods/p/SwiftI18n.svg?style=flat)](http://cocoapods.org/pods/SwiftI18n)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* Xcode 8.0
* Swift 3.0
* iOS 9.0+

## Installation

SwiftI18n is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftI18n/I18n'
pod 'SwiftI18n/I18n+Case'
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Add:
```Swift
import SwiftI18n
```

Set or get currently selected language from:
```Swift
I18nManager.instance.language
```

Set available languages and default language:
```Swift
I18nManager.instance.availableLanguages = ["en_US", "hr"]
I18nManager.instance.defaultLanguage = "hr"
```
If `availableLanguages` are present, and `defaultLanguage` isn't, `language` is initialy set to language most preferable by the user from `availableLanguages`.

Handling language change:
Subscribe to `I18nManager.subscribeForLocaleDidChange(block: { ... } -> -> NSObjectProtocol`
or if you prefer notifications, you can use:
`NSNotification.Name.loc_LanguageDidChangeNotification`

### Where fun really starts

```Swift
someLabel.locTitleKey = "some_key"
```
Now when language changes, your `someLabel`'s title automaticaly changes. Isn't that great!?

Supported elements:
```UILabel ```
```UIButton ```
```UITextFiled ```
```UITextView ```
```UIViewController ```
```UIBarButtonItem ```
```UITabBarItem ```
```UINavigationItem ```

**And the most important thing, all of those `locTitleKey`'s are supported in ```Storyboards ``` as ```@IBInspectable ```.**

### Handling cases

Sometimes you have to work with translations that are all lowercased, but you want them to be uppercased or maybe capitalized.
To handle this use:
```ruby
pod 'SwiftI18n/I18n+Case'
```

Now you have an enum:
```Swift
enum I18nCaseTransform: String {
    case uppercased = "up"
    case lowercased = "low"
    case capitalized = "cap"
}
```
which you can use like this:
```Swift
someButton.setCaseTransform(.uppercased, for: .normal)
```
You can also set case transform in ```Storyboards ```.

### Working with Polyglot client Strings enum

For SwiftI18n to work beautifly with polyglot client created `Strings` enum you will need to copy:
`SwiftI18n/Polyglot/PolyglotSwiftI18Extensions.swift`
into your project.

By doing this you can now set translations to your UI elements with ease:
```Swift
someLabe.loc.titleKey = .somePolygotKey
```

## Not supported 

```
Attributed strings
```
Sry :(



## Author

Vlaho Poluta, vlaho.poluta@infinum.hr

## License

SwiftI18n is available under the MIT license. See the LICENSE file for more info.
