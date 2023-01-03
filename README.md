

<h1 align="center">
  Alfred Manager
</h1>

<h4 align="center">Export and import Alfred preferences with this native MacOS app written with SwiftUI and <a href="https://github.com/hmlongco/Factory">Factory</a>.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#architecture">Architecture</a> •
    <a href="#contributing">Contributing</a> •
</p>

![screenshot](https://raw.githubusercontent.com/JillevdW/alfred-manager/main/header_screenshot.png)

## Key Features

* Export Alfred Custom Web Searches
* Import Alfred Custom Web Searches
* For Engineers: a great place to contribute to a new SwiftUI project :)

## How To Use

- Download the application from the [releases](https://github.com/JillevdW/alfred-manager/releases) page and run it.
- Select your Alfred preferences path.
- Either
	- select the Web Searches you want to export
	- OR locate the configuration file for the Web Searches you want to import and select the Web Searches you want to import.

## Architecture

The app is built using SwiftUI for the UI and a simple ViewModel pattern to manage updates to the state. [Factory](https://github.com/hmlongco/Factory) is used to inject dependencies into the ViewModels.

### Reservations
I'm not 100% happy about the state of the code, here's a short outline of some reservations I have to get a discussion going on those topics.
#### Containers
Factory uses Containers to manage the dependencies. I've (unsuccessfully) attempted to create a hierarchical structure with these containers, to make "Child" containers automatically be able to provide dependencies already present in a "Parent" (much like with [Needle](https://github.com/uber/needle)). I ended up dropping this attempt, but some left-over code remains: for example the `InstallationSelectionContainer` referencing a dependency from the `RootViewContainer`. This has proven to be an annoyance during testing and in it's current state isn't scalable.


## Contributing

Feel free to submit a pull request with new features or improvements. That's why the project is public! Some starting points could be:
- Unifying the selection logic in `WebSearchImportViewModel` and `WebSearchExportViewModel` to reduce duplication.
	- After this, both these ViewModels could use some tests 😇
- Error handling is non-existent in almost all views.
	- Tip: For simple Views, a pattern where a simple ViewModel updates a State enum (similar to what happens in `RootView` and `RootViewModel`) is often enough and easily testable.
