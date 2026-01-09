import SwiftUI

struct SFSymbolsLiteDetailAnimationView: View {

	@Binding var effect: SFSymbolsLiteDetailEffectAnimation
	@Binding var effectAnimate: SFSymbolsLiteDetailEffectAnimate
	@Binding var effectRepeat: SFSymbolsLiteDetailEffectRepeat
	@Binding var effectDirection: SFSymbolsLiteDetailEffectDirection
	@Binding var effectCount: Int?
	@Binding var effectDelay: Double?
	@Binding var effectPlay: Bool
	@Binding var effectID: UUID

	@AppStorage("SFSymbolsLiteDetailAnimationViewIsExpanded") private var isExpanded: Bool = false

	var body: some View {

		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Button {
					isExpanded.toggle()
				} label: {
					Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 10, height: 10)
						.foregroundStyle(.secondary)
						.contentShape(Rectangle())
				}
				.buttonStyle(.plain)

				Text("ANIMATION")
					.font(.body)
					.fontWeight(.medium)
					.foregroundStyle(.secondary)
			}
			.onTapGesture {
				isExpanded.toggle()
			}

			if isExpanded {
				VStack(spacing: 5) {
					HStack {
						Image(systemName: "circle.dotted.and.circle")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Animation")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						if let available = effect.available {
							if let iOS = available.iOS {
								Text("􀟜 " + iOS)
									.tokenSection(color: .secondary, font: .callout, padding: 4)
							}
							if let macOS = available.macOS {
								Text("􀙗 " + macOS)
									.tokenSection(color: .secondary, font: .callout, padding: 4)
							}
							if let watchOS = available.watchOS {
								Text("􀟤 " + watchOS)
									.tokenSection(color: .secondary, font: .callout, padding: 4)
							}
							if let tvOS = available.tvOS {
								Text("􀨫 " + tvOS)
									.tokenSection(color: .secondary, font: .callout, padding: 4)
							}
							if let visionOS = available.visionOS {
								Text("􁎖 " + visionOS)
									.tokenSection(color: .secondary, font: .callout, padding: 4)
							}
						}

						Picker("", selection: $effect) {
							ForEach(SFSymbolsLiteDetailEffectAnimation.allCases, id: \.self) { effect in
								Text(effect.rawValue).tag(effect)
							}
						}
						.onChange(of: effect) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}
						.pickerStyle(.menu)
						.frame(width: 100, alignment: .trailing)

						if effectPlay && effectRepeat != .once {
							Button("􀛷") {
								Task { @MainActor in
									effectPlay = false
									effectID = UUID()
								}
							}
							.padding(.trailing, 10)
						} else {
							Button("􀊄") {
								Task { @MainActor in
									effectPlay = true
									effectID = UUID()
								}
							}
							.padding(.trailing, 10)
						}

					}
					.detailInsideSection()

					HStack {
						Image(systemName: "square.3.layers.3d.down.right")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Animate")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						Picker("", selection: $effectAnimate) {
							ForEach(SFSymbolsLiteDetailEffectAnimate.allCases, id: \.self) { animate in
								Text(animate.rawValue).tag(animate)
							}
						}
						.labelsHidden()
						.pickerStyle(.radioGroup)
						.horizontalRadioGroupLayout()
						.padding(.trailing, 10)
					}
					.detailInsideSection()
					.onChange(of: effectAnimate) {
						Task { @MainActor in
							effectPlay = false
							effectID = UUID()
						}
					}

					HStack {
						Image(systemName: "arrow.up.arrow.down")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Direction")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						Picker("", selection: $effectDirection) {
							ForEach(SFSymbolsLiteDetailEffectDirection.allCases, id: \.self) { direction in
								Text(direction.rawValue).tag(direction)
							}
						}
						.labelsHidden()
						.pickerStyle(.radioGroup)
						.horizontalRadioGroupLayout()
						.padding(.trailing, 10)
					}
					.detailInsideSection()
					.onChange(of: effectDirection) {
						Task { @MainActor in
							effectPlay = false
							effectID = UUID()
						}
					}
				}
			}
		}
	}

}
