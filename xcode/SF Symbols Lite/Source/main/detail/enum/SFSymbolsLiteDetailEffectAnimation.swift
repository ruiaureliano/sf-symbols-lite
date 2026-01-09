import Foundation

enum SFSymbolsLiteDetailEffectAnimation: String, Codable, CaseIterable, Hashable {

	case appear = "Appear"

	var available: SFSymbolsLiteDetailEffectAnimationAvailable? {
		switch self {
		case .appear:
			return SFSymbolsLiteDetailEffectAnimationAvailable(iOS: "17.0", macOS: "14.0", watchOS: "10.0", tvOS: "17.0", visionOS: "1.0")
		}
	}
}
