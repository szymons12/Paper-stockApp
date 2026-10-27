
import SwiftUI
struct Top10View: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 200)
                LogoutButton()
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Most Active")
                            .font(.title2)
                            .bold()
                        MostActiveView()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Movers")
                            .font(.title2)
                            .bold()
                        TopMoversView()
                    }

                    CandlesView(symbol: "TSLA")
                        .frame(height: 300)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    Top10View()
}
