![Supports iOS](https://img.shields.io/badge/iOS-Supported-blue.svg)
![Supports macOS](https://img.shields.io/badge/macOS-Supported-blue.svg)
![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green)

# Practical Unidirectional Data Flow Architecture for SwiftUI

**"The UI is a function of the state" - Apple**

Declarative UI frameworks like SwiftUI require us to rethink how we architect our apps.

Widely known design patterns like MVVM aren't cutting it anymore and most UDF libraries require us to write a lot of boilerplate code.

SwiftUDF provides a streamlined development experience for how to setup SwiftUI views using the unidirectional data flow pattern, support by code generation.

## Components

### View

The responsibility of a view is to render data, referred to as `State`, and pass through the inputs received from the user, referred to as `Event`.

```swift
protocol BindableView: View {
    associatedtype State
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}
```

**Example**

Imagine a simple counter app, displaying a total count and two buttons to increment or decrement that count.

The `State` and `Event` could look like this:

```swift
struct CounterState {
    let count: Int    // immutable fields for thread safety!
}

enum CounterEvent {
    case increase
    case decrease
}
```

The view would conform to `BindableView` like this:

```swift
struct CounterView: BindableView {
    let state: CounterState
    let handler: (CounterEvent) -> Void

    var body: some View { ... }
}
```

This simple setup enables us to harness the power of previews by building our UI with all the different states that might occur:

```swift
CounterView.preview(.init(count: 0))
CounterView.preview(.init(count: 3))
...
```

### Loop

The counter part to `BindableView`, providing the state and receiving the user input, referred to as `Loop`.

```swift
protocol ViewProvider {
    associatedtype State
    associatedtype Event

    var state: CurrentValuePublisher<State> { get }

    func handle(_ event: Event)

    func start() // called on view appear
    func stop()  // called on view disappear
}
```

`CurrentValuePublisher` is a custom `Combine.Publisher` providing an additional read-only value, representing the current state of the `Loop`.

**Example**

Continuing with our counter app example, a basic `Loop` implementation could look as followed:

```swift
/// @Loop(CounterState, CounterEvent)
final class CounterLoop: GeneratedBaseCounterLoop {
    override func increase() {
        updateCount(count + 1)
    }

    override func decrease() {
        let updatedCount = max(0, count - 1)
        updateCount(updatedCount)
    }
}
```

Using the `@Loop(State, Event)` annotation, `SwiftUDF` will generate a "BaseLoop" `class` including the following functionalities:
- first level read-only variables for each field of the `State` each field of the `State`
- update functions for each field of the `State`
- a dedicated function for every user input aka every case of the `Event` enum

### Binding the `View` with the `Loop`

Instantiating and binding a view with the provider is straight forward:

```swift
CounterView.create(using: CounterLoop())
```

`SwiftUDF` will wrap your view into a container, subscribing to the loop's state, calling `start` and `stop` of the loop and ensuring all state updates are dispatched on the main thread.

## Demo Project

To see `SwiftUDF` in action, please checkout the demo project. It contains a slightly evolved example of the counter app, compatible with iOS and macOS, including tests.

## Contributing

Contributions are welcomed and encouraged!

It is easy to get involved. Open an issue to discuss a new feature, write clean code, show some love using unit tests and open a Pull Request.

PS: Check the open issues and pull requests for existing discussions.

## License

SwiftEvolution is available under the MIT license.
