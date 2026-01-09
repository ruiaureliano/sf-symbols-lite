import Foundation

enum SFSymbolsLiteDetailEffectDirection: String, Codable, CaseIterable, Hashable {

	case up = "Up"
	case down = "Down"
	case `default` = "Default"
	case localized = "Localized"
	case fixed = "Fixed"
	case clockwise = "Clock Wise"
	case counterclockwise = "Counter Clock Wise"
	case downUp = "Down-Up"
	case upUp = "Up-Up"
	case offUp = "Off-Up"
}
