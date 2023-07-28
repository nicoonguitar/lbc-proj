# Lbc test project

## Project overview

The project is made by a multiplatform application that can run on both iOS and iPadOS and a number of local swift packages that modularize data management, business logic, reusable view design and simple implementations of the Coordinator and the Service Locator pattern to support the architecture for navigation and DI. It makes no use of external third party libraries.

Also, a number of unit tests are provided in the Domain and Data swift packages.

## Architecture overview

The application was structured using a layered archictured to separate data management, business logic and UI presentation.

We can start by taking a look at the Domain swift package that contains pure business logic. It provides the definition of the models, repository interfaces and use cases.

Then we can continue with the Data swift package, which contains the implementation of the repositories (as described by the interfaces provided in the Domain package) and their data sources to remotely fetch data from given URLs and to store them them in a built-in in memory cache. It's worth mentioning that the in memory caches were defined as Swift actors to avoid data races.

Right before taking a look at the main app, we should continue with the ServiceLocator swift package which contains a simple implementation of the pattern with an API that allows to register types either as a factory or a singleton by optionally providing an argument. It also provides an Assembly type that allows for each package to provide a set of registered types to comply with modularization and encapsulation. It's implementation is quite limited as it serves to support the architecture. On a larger application it'd be best to rely on a more powerful implementation that's based on a graph. More on this on the swift package README.

About the main application, the current version of Xcode (14.3.1) created a SwiftUI project so I implemented a simple UIKit AppDelegate to be able to instantiate a UIWindow to support the whole UIKit view hierarchy to be displayed. From there, some points I'd like to highlight:

* In the Feature folder we can find the Presentation layer implementation. It provides the ViewModels and View implementations for the Listing, Category selector and Classified Ad detail pages.
* All views are implemented using UIKit types as required. However, we can find SwiftUI previews in the Design package. This was to quickly iterate on the implementation but has no relationship with the UIKit views themselves.
* Navigation is supported by a simple implementation of the Coordinator pattern, which lives in the Coordinator swift package.
* DI is managed by the ServiceLocator, where the AppAssembly will register all required instances of the ViewModels and ViewControllers.
* When the application launches, the service locator will load all the assemblies provided by the app itself and the domain and data swift packages. Instances are then going to be resolved in the Coordinator when loading a ViewController based on the user navigation journey.
* The ImageLoader manages image loading from a given URL, being implemented as an actor to protect its inner in memory cache from data races. 
