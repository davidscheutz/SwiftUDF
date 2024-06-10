import SwiftUI
import SwiftUDF

struct CounterView: BindableView {
    
    let state: CounterState
    let handler: (CounterEvent) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Counter Example")
                .font(.title)
            
            incrementSelection()
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("Count:")
                    .foregroundStyle(.gray)
                
                Text("\(state.count)")
                    .font(.largeTitle)
                
                if let error = state.error {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            
            Spacer()
            
            buttons()
        }
        .animation(.easeInOut, value: state.error)
        .padding()
    }
}

extension CounterView {
    private func incrementSelection() -> some View {
        let incrementBinding = Binding(
            get: { state.increment },
            set: { handler(.incrementSelected($0)) }
        )
        
        return HStack {
            Text("Increment by:")
            
            Picker("", selection: incrementBinding) {
                ForEach(Increment.allCases) { increment in
                    Text(increment.display)
                        .tag(increment)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 140)
        }
    }
    
    private func buttons() -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 60) {
                Button("Decrease") { handler(.decrease) }
                Button("Increase") { handler(.increase) }
            }
            
            Button("Reset") { handler(.reset) }
                .foregroundStyle(.red)
                .disabled(!state.canReset)
                .opacity(state.canReset ? 1 : 0)
        }
    }
}

#Preview {
    CounterView.preview(.init(increment: .byOne, count: 0, error: nil))
}

#Preview("In Action") {
    CounterView.preview(.init(increment: .byFive, count: 13, error: nil))
}

#Preview("Error") {
    CounterView.preview(.init(increment: .byTen, count: 0, error: "Preview example error"))
}
