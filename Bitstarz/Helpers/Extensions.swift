enum Direction {
    case top
    case bottom
    case left
    case right
}

struct BitMaskCategories {
    static let hero: UInt32 = 0x1 << 0
    static let enemy: UInt32 = 0x1 << 1
    static let door: UInt32 = 0x1 << 2
}
