import SwiftUI

struct SFSymbolsLitePopoverSymbolsView: View {

	@Environment(\.dismiss) private var dismiss
	@Binding var symbols: Set<Symbol>
	@Binding var selectedSymbol: String
	@State private var symbolSearch: String = ""

	private var symbolsFiltered: [Symbol] {
		let filtered = symbols.filter { !$0.glyph.isEmpty }
		if symbolSearch.isEmpty {
			return filtered.sorted { $0.name < $1.name }
		}
		return
			filtered
			.filter { $0.name.localizedCaseInsensitiveContains(symbolSearch) }
			.sorted { $0.name < $1.name }
	}

	var body: some View {
		VStack {
			TextField("Search symbol", text: $symbolSearch)
				.textFieldStyle(.roundedBorder)

			ScrollView {
				LazyVStack(alignment: .leading, spacing: 6) {
					ForEach(symbolsFiltered, id: \.self) { item in
						HStack {
							Image(systemName: item.name)
								.frame(width: 20, height: 20)
							Text(item.name)
								.lineLimit(1)
							Spacer()
						}
						.contentShape(Rectangle())
						.onTapGesture {
							selectedSymbol = item.name
							dismiss()
						}
					}
				}
			}
			.frame(width: 500, height: 300)
		}
		.padding(20)
	}
}
