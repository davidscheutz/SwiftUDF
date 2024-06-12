![Supports iOS](https://img.shields.io/badge/iOS-Supported-blue.svg)
![Supports macOS](https://img.shields.io/badge/macOS-Supported-blue.svg)
![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green)

# Unidirectional Data Flow code generation for SwiftUI

"The UI is a function of the state" - Apple

Declarative UI frameworks like SwiftUI require us to rethink how we architect our apps.

Widely known design pattern like MVVM aren't cutting it anymore.

SwiftUDF provides a set of useful functionality to setup your SwiftUI views using the unidirectional data flow pattern.

## Components

### View

A view only needs data to render, referred to as `State` and a way to pass through the user input, referred to as `Event`.

```swift
protocol BindableView: View {
    associatedtype State
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}
```

**Example**

Imagine a simple counter app, displayingathe total count and two buttons to increment or decrement the count.

```swift
struct CounterState {
    let count: Int
}

enum CounterEvent {
    case increase
    case decrease
}

struct CounterView: BindableView {
    let state: CounterState
    let handler: (CounterEvent) -> Void

    var body: some View { ... }
}
```

Harness the power of previews by building your UI with different states:

```swift
CounterView.preview(.init(count: 0))
CounterView.preview(.init(count: 3))
```

### Loop

Every `BindableView` needs a counter part, providing the state and receiving the user input, referred to as `Loop` in our case.

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

`CurrentValuePublisher` is a special `Combine.Publisher` providing an additional read-only value, representing the current state of the `Loop`.

**Example**

Continuing with our counter app example, let's create our `Loop` implementation.

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

Using the `@Loop` annotation, `SwiftUDF` will automatically generate a "BaseLoop", providing the following functionalities:
- first level read-only variables for each field of the `State` each field of the `State`
- update functions for each field of the `State`
- functions for every case of the `Event` enum

### Binding the `View` with the `Loop`

Instantiating and binding a view with the provider is straight forward:

```swift
CounterView.create(using: CounterLoop())
```

`SwiftUDF` will wrap your view into a container, subscribe to the loop's state and ensuring all state updates are dispatched on the main thread.

## Demo Project

To see `SwiftUDF` fully in action, checkout the demo project. Compatible with iOS and macOS, including tests.

## Contributing

Contributions are welcomed and encouraged!

It is easy to get involved. Open an issue to discuss a new feature, write clean code, show some love using unit tests and open a Pull Request.

PS: Check the open issues and pull requests for existing discussions.

## License

SwiftEvolution is available under the MIT license.
