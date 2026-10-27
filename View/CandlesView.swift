import SwiftUI
import Charts

struct CandlesView: View {
    @StateObject private var viewModel: CandleViewModel

    // Wartości startowe są tylko zaślepką, po załadowaniu danych zostaną nadpisane
    @State private var visibleLength: Double = 24 * 3600
    @State private var baseLength: Double = 24 * 3600
    @State private var scrollPosition: Date = .now

    // Ile świec maksymalnie widać przy największym przybliżeniu
    private let minCandlesVisible: Double = 5

    // Maksymalne przybliżenie: kilka długości jednej świecy
    private var minLength: Double {
        viewModel.selectedTimeframe.seconds * minCandlesVisible
    }

    // Maksymalne oddalenie: cały zakres pobranych danych
    private var dynamicMaxLength: Double {
        max(minLength, dataSpan)
    }

    // Czas od pierwszej do ostatniej świecy (plus jedna świeca, żeby ostatnia się mieściła)
    private var dataSpan: Double {
        guard let first = viewModel.candles.first?.t,
              let last = viewModel.candles.last?.t else { return 0 }
        return last.timeIntervalSince(first) + viewModel.selectedTimeframe.seconds
    }

    init(symbol: String) {
        _viewModel = StateObject(wrappedValue: CandleViewModel(symbol: symbol))
    }

    var body: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Text(viewModel.symbol)

            Chart(viewModel.candles, id: \.t) { candle in
                let color: Color = candle.c >= candle.o ? .green : .red
                let half = candle.timeframe.seconds * 0.35   // korpus zajmuje ok. 70% szerokości świecy

                RuleMark(
                    x: .value("Czas", candle.t),
                    yStart: .value("Low", candle.l),
                    yEnd: .value("High", candle.h)
                )
                .lineStyle(StrokeStyle(lineWidth: 1))
                .foregroundStyle(color)

                RectangleMark(
                    xStart: .value("Start", candle.t.addingTimeInterval(-half)),
                    xEnd: .value("Koniec", candle.t.addingTimeInterval(half)),
                    yStart: .value("Open", candle.o),
                    yEnd: .value("Close", candle.c)
                )
                .foregroundStyle(color)
            }
            .chartYScale(domain: .automatic(includesZero: false))
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleLength)
            .chartScrollPosition(x: $scrollPosition)
            .simultaneousGesture(
                MagnifyGesture()
                    .onChanged { value in
                        let newLength = min(
                            max(baseLength / value.magnification, minLength),
                            dynamicMaxLength
                        )
                        // zachowaj prawą krawędź okna (najnowsze dane)
                        let right = scrollPosition.addingTimeInterval(visibleLength)
                        visibleLength = newLength
                        scrollPosition = right.addingTimeInterval(-newLength)
                    }
                    .onEnded { _ in
                        baseLength = visibleLength
                    }
            )
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }

            Picker("Interwał", selection: $viewModel.selectedTimeframe) {
                ForEach(Timeframe.allCases, id: \.self) { timeframe in
                    Text(timeframe.label).tag(timeframe)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .task(id: viewModel.selectedTimeframe) {
            await viewModel.loadCandles()
            resetView()
        }
    }

    /// Ustawia widok na cały pobrany zakres (wywoływane po każdym załadowaniu danych)
    private func resetView() {
        guard let first = viewModel.candles.first?.t else { return }
        let length = max(dataSpan, minLength)
        visibleLength = length
        baseLength = length
        scrollPosition = first
    }
}

#Preview {
    CandlesView(symbol: "TSLA")
}
