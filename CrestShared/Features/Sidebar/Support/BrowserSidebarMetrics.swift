import CoreGraphics

enum BrowserSidebarMetrics {
    static let lockedSpaceBlurRadius: CGFloat = 12
    static let addressBottomInset: CGFloat = 1
    /// The one gap down the top of a Space: address field to extension strip,
    /// strip to pinned tabs, and address field to pinned tabs when there is no
    /// strip. The selected pin's glow slides under whichever layer is above.
    static let topSectionSpacing = CrestSpacing.small
    static let pinnedTabsBottomInset: CGFloat = 6
}
