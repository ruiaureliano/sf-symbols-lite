import Foundation

enum SFSymbolsLiteDetailEffectAnimation: String, Codable, CaseIterable, Hashable {

	case appear = "Appear"
	case drawOn = "Draw On"
	case bounce = "Bounce"
	case scale = "Scale"
	case wiggle = "Wiggle"

	var available: SFSymbolsLiteDetailEffectAnimationAvailable? {
		switch self {
		case .appear:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "17.0", macOS: "14.0", watchOS: "10.0", tvOS: "17.0", visionOS: "1.0")
		case .drawOn:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "26.0", macOS: "26.0", watchOS: "26.0", tvOS: "26.0", visionOS: nil)
		case .bounce:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "17.0", macOS: "14.0", watchOS: "10.0", tvOS: "17.0", visionOS: "1.0")
		case .scale:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "17.0", macOS: "14.0", watchOS: "10.0", tvOS: "17.0", visionOS: "1.0")
		case .wiggle:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "18.0", macOS: "15.0", watchOS: "11.0", tvOS: "18.0", visionOS: "2.0")
		}
	}
}
