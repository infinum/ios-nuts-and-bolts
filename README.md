# iOS Nuts And Bolts

Collection of commonly shared and reused code throughout the team.

## Contributing

Before adding a new feature, please ensure that:

* Have checked there is no same component already in catalog. If similar component already exists, try to upgrade it if needed.
* Have created a sufficient example or wrote tests for it. If component is for something in UIKit, then example is better, while tests are preferred for Foundation features. Please, take a look at one of the current available features to grasp the idea.
* Code is structured, well written using standard Swift coding style or check one at our [Coding Style](https://handbook.infinum.co/books/ios/Basics/Coding%20style) handbook.
* All public methods and properties have documentation - comments have to be meaningful and concise.
* Use `public` modifier for all method and properties that could be changed from user of your feature, and `private` for internal properties. Another reason why `public` is mandatory, when using framework based development, only public properties and methods will be visible to the user.
* Remove any reference to the project that piece of code was created in - mostly the project name from header comment in file.
* Reduce the dependencies to minimum.
