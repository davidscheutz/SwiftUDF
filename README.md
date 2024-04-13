![Supports iOS](https://img.shields.io/badge/iOS-Supported-blue.svg)
![Supports macOS](https://img.shields.io/badge/macOS-Supported-blue.svg)
![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green)

# SwiftUI Unidirectional Data Flow

"The UI is a function of the state" - Apple

Declarative UI frameworks (SwiftUI) require us to rethink how we architect our apps.

Widely known design pattern like MVVM aren't cutting it anymore.

SwiftUDF provides a set of useful functionality to setup your SwiftUI views using the unidirectional data flow pattern.

```swift
protocol BindableView {
    associatedtype State
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}
```

```swift
protocol ViewProvider {
    associatedtype State
    associatedtype Event

    var state: CurrentValuePublisher<State> { get }

    func handle(_ event: Event)
}
```

Instantiating and binding a view with the provider looks as simple:
 
```swift
ExampleView.create(using: ExampleProvider())
```

Harness the power of previews:

```swift
ExampleView.preview(State(text: "", loading: false))
ExampleView.preview(State(text: "user input", loading: true))
```

## Contributing

Contributions are welcomed and encouraged!

It is easy to get involved. Open an issue to discuss a new feature, write clean code, show some love using unit tests and open a Pull Request.

PS: Check the open issues and pull requests for existing discussions.

## License

SwiftEvolution is available under the MIT license.
