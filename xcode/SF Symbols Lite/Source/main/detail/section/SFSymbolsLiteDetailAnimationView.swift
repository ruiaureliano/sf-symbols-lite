import SwiftUI

struct SFSymbolsLiteDetailAnimationView: View {

	@Binding var symbols: Set<Symbol>
	@Binding var effect: SFSymbolsLiteDetailEffectAnimation
	@Binding var effectAnimate: SFSymbolsLiteDetailEffectAnimate
	@Binding var effectRepeat: SFSymbolsLiteDetailEffectRepeat
	@Binding var effectDirection: SFSymbolsLiteDetailEffectDirection
	@Binding var effectPulses: Bool
	@Binding var effectVariableColorStyle: SFSymbolsLiteDetailEffectVariableColorStyle
	@Binding var effectVariableColorInactiveLayers: SFSymbolsLiteDetailEffectVariableColorInactiveLayers
	@Binding var effectVariableColorReversing: Bool
	@Binding var effectVariableColor: Color
	@Binding var effectReplaceWith: String
	@Binding var effectPreferMagicReplace: Bool
	@Binding var effectCount: Int?
	@Binding var effectDelay: Double?
	@Binding var effectPlay: Bool
	@Binding var effectID: UUID

	@AppStorage("SFSymbolsLiteDetailAnimationViewIsExpanded") private var isExpanded: Bool = false
	@State private var showReplacePopover: Bool = false

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
							Text(SFSymbolsLiteDetailEffectAnimation.appear.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.appear)
							Text(SFSymbolsLiteDetailEffectAnimation.drawOn.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.drawOn)
							Divider()
							Text(SFSymbolsLiteDetailEffectAnimation.bounce.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.bounce)
							Text(SFSymbolsLiteDetailEffectAnimation.scale.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.scale)
							Text(SFSymbolsLiteDetailEffectAnimation.wiggle.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.wiggle)
							Text(SFSymbolsLiteDetailEffectAnimation.rotate.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.rotate)
							Text(SFSymbolsLiteDetailEffectAnimation.breathe.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.breathe)
							Text(SFSymbolsLiteDetailEffectAnimation.pulse.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.pulse)
							Text(SFSymbolsLiteDetailEffectAnimation.variableColor.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.variableColor)
							Text(SFSymbolsLiteDetailEffectAnimation.replace.rawValue).tag(SFSymbolsLiteDetailEffectAnimation.replace)
							Divider()
						}
						.onChange(of: effect) {
							Task { @MainActor in
								if usesDirection, effectAnimate == .individually {
									effectAnimate = .symbol
								}
								if usesDirection, !directionOptions.contains(effectDirection) {
									effectDirection = defaultDirection
								}
								effectPlay = false
								effectID = UUID()
							}
						}
						.pickerStyle(.menu)
						.frame(width: 140, alignment: .trailing)

						if effectRepeat != .once {
							Button {
								Task { @MainActor in
									effectPlay.toggle()
									effectID = UUID()
								}
							} label: {
								Text("􀛷")
									.frame(width: 20, alignment: .center)
							}
							.padding(.trailing, 10)
						} else if effectPlay {
							Button {
								Task { @MainActor in
									effectPlay = false
									effectID = UUID()
								}
							} label: {
								Text("􀛷")
									.frame(width: 20, alignment: .center)
							}
							.padding(.trailing, 10)
						} else {
							Button {
								Task { @MainActor in
									effectPlay = true
									effectID = UUID()
								}
							} label: {
								Text("􀊄")
									.frame(width: 20, alignment: .center)
							}
							.padding(.trailing, 10)
						}

					}
					.detailInsideSection()

					HStack {
						Image(systemName: "repeat")
							.resizable()
							.scaledToFit()
							.frame(width: 16, height: 16)
							.foregroundStyle(.primary)
							.padding(.leading, 10)
							.padding(.vertical, 10)

						Text("Repeat")
							.font(.body)
							.fontWeight(.regular)
							.foregroundStyle(.primary)

						Spacer()

						HStack(spacing: 6) {
							Picker("", selection: $effectRepeat) {
								ForEach(SFSymbolsLiteDetailEffectRepeat.allCases, id: \.self) { repeatMode in
									Text(repeatMode.rawValue).tag(repeatMode)
								}
							}
							.labelsHidden()
							.pickerStyle(.menu)
							.frame(width: 160, alignment: .trailing)

							if effectRepeat == .repeatDelay {
								ZStack(alignment: .trailing) {
									TextField("", value: delaySeconds, format: .number.precision(.fractionLength(0)))
										.frame(width: 36)
										.textFieldStyle(.roundedBorder)

									Text("s")
										.foregroundStyle(.secondary)
										.padding(.trailing, 8)
								}
								.frame(width: 44, alignment: .trailing)

								Stepper("", value: delaySeconds, in: 0...60, step: 1)
									.labelsHidden()
									.fixedSize()
									.controlSize(.mini)
							}
						}
						.frame(width: effectRepeat == .repeatDelay ? 240 : 160, alignment: .trailing)
						.padding(.trailing, 10)
					}
					.detailInsideSection()
					.onChange(of: effectRepeat) {
						Task { @MainActor in
							if effectRepeat == .repeatDelay, effectDelay == nil {
								effectDelay = 0
							}
							effectPlay = false
							effectID = UUID()
						}
					}

					if effect == .replace {
						HStack {
							Image(systemName: "arrow.left.arrow.right")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("With")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Button {
								showReplacePopover = true
							} label: {
								HStack(spacing: 4) {
									Text(replaceDisplayText)
										.lineLimit(1)
									Image(systemName: "chevron.down")
										.font(.system(size: 10, weight: .semibold))
										.foregroundStyle(.secondary)
								}
							}
							.buttonStyle(.plain)
							.popover(isPresented: $showReplacePopover, arrowEdge: .top) {
								SFSymbolsLitePopoverSymbolsView(symbols: $symbols, selectedSymbol: $effectReplaceWith)
							}
							.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectReplaceWith) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}
					}

					if showsAnimateOptions {
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
								ForEach(animateOptions, id: \.self) { animate in
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
					}

					if usesDirection {
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
								ForEach(directionOptions, id: \.self) { direction in
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

					if effect == .replace {
						HStack {
							Image(systemName: "wand.and.stars")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("Prefer Magic Replace")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Toggle("", isOn: $effectPreferMagicReplace)
								.toggleStyle(.switch)
								.controlSize(.small)
								.labelsHidden()
								.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectPreferMagicReplace) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}
					}

					if effect == .breathe {
						HStack {
							Image(systemName: "waveform.path.ecg")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("Pulses")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Toggle("", isOn: $effectPulses)
								.toggleStyle(.switch)
								.controlSize(.small)
								.labelsHidden()
								.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectPulses) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}
					}

					if effect == .variableColor {
						HStack {
							Image(systemName: "paintbrush")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("Style")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Picker("", selection: $effectVariableColorStyle) {
								ForEach(SFSymbolsLiteDetailEffectVariableColorStyle.allCases, id: \.self) { style in
									Text(style.rawValue).tag(style)
								}
							}
							.labelsHidden()
							.pickerStyle(.radioGroup)
							.horizontalRadioGroupLayout()
							.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectVariableColorStyle) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}

						HStack {
							Image(systemName: "circle.grid.3x3.fill")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("Inactive Layers")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Picker("", selection: $effectVariableColorInactiveLayers) {
								ForEach(SFSymbolsLiteDetailEffectVariableColorInactiveLayers.allCases, id: \.self) { mode in
									Text(mode.rawValue).tag(mode)
								}
							}
							.labelsHidden()
							.pickerStyle(.radioGroup)
							.horizontalRadioGroupLayout()
							.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectVariableColorInactiveLayers) {
							Task { @MainActor in
								effectPlay = false
								effectID = UUID()
							}
						}

						HStack {
							Image(systemName: "arrow.triangle.2.circlepath")
								.resizable()
								.scaledToFit()
								.frame(width: 16, height: 16)
								.foregroundStyle(.primary)
								.padding(.leading, 10)
								.padding(.vertical, 10)

							Text("Reversing")
								.font(.body)
								.fontWeight(.regular)
								.foregroundStyle(.primary)

							Spacer()

							Toggle("", isOn: $effectVariableColorReversing)
								.toggleStyle(.switch)
								.controlSize(.small)
								.labelsHidden()
								.padding(.trailing, 10)
						}
						.detailInsideSection()
						.onChange(of: effectVariableColorReversing) {
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

	private var animateOptions: [SFSymbolsLiteDetailEffectAnimate] {
		usesDirection
			? SFSymbolsLiteDetailEffectAnimate.allCases.filter { $0 != .individually }
			: SFSymbolsLiteDetailEffectAnimate.allCases
	}

	private var delaySeconds: Binding<Double> {
		Binding(
			get: { effectDelay ?? 0 },
			set: { effectDelay = max(0, $0.rounded()) }
		)
	}

	private var directionOptions: [SFSymbolsLiteDetailEffectDirection] {
		switch effect {
		case .wiggle:
			return [.default, .localized, .fixed]
		case .rotate:
			return [.default, .clockwise, .counterclockwise]
		case .replace:
			return [.downUp, .upUp, .offUp]
		case .appear, .bounce, .scale:
			return [.down, .up]
		case .breathe, .pulse, .variableColor, .drawOn:
			return []
		}
	}

	private var defaultDirection: SFSymbolsLiteDetailEffectDirection {
		switch effect {
		case .wiggle:
			return .default
		case .rotate:
			return .default
		case .replace:
			return .downUp
		case .appear, .bounce, .scale:
			return .up
		case .breathe, .pulse, .variableColor, .drawOn:
			return .up
		}
	}

	private var showsAnimateOptions: Bool {
		effect != .variableColor
	}

	private var usesDirection: Bool {
		switch effect {
		case .appear, .bounce, .scale, .wiggle, .rotate, .replace:
			return true
		case .breathe, .pulse, .variableColor, .drawOn:
			return false
		}
	}

	private var replaceDisplayText: String {
		if effectReplaceWith.isEmpty {
			return "Select Symbol"
		}
		let glyph = symbols.first(where: { $0.name == effectReplaceWith })?.glyph ?? ""
		if glyph.isEmpty {
			return effectReplaceWith
		}
		return "\(glyph) \(effectReplaceWith)"
	}
}
