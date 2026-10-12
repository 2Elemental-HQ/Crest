import SwiftUI

/// The sidebar's shared geometry, and the one place its layers take their
/// shape from.
///
/// A *layer* is anything drawn as a surface above the sidebar's base: the
/// address field, the extension strip, the pinned tiles, every tab row's
/// selection and hover, the New Tab row's hover, folders, Split Views, and the
/// drag previews lifted from them. Every top-level layer sits the same distance
/// from the sidebar's edges and has the same corners. A container — a folder or
/// a Split View — holds its rows the same padding in from every side, and each
/// layer inside it is cornered concentrically, one padding tighter per
/// container around it.
enum BrowserSidebarMetrics {
    // MARK: - Static Variables

    static let lockedSpaceBlurRadius: CGFloat = 12
    static let addressBottomInset: CGFloat = 1
    /// The one gap down the top of a Space: address field to extension strip,
    /// strip to pinned tabs, and address field to pinned tabs when there is no
    /// strip. The selected pin's glow slides under whichever layer is above.
    static let topSectionSpacing = CrestSpacing.small
    static let pinnedTabsBottomInset: CGFloat = 6

    /// How far every top-level layer sits from the sidebar's leading and
    /// trailing edges.
    static let layerInset = CrestSpacing.small

    /// How far a container holds what it contains in from its own edge, the
    /// same on all four sides for folders and Split Views alike. It is also the
    /// step each level of nesting moves in by.
    static let containerPadding = CrestSpacing.extraSmall

    /// The space a container keeps above and below itself, apart from the rows
    /// beside it.
    static let containerSpacing = CrestSpacing.extraExtraSmall

    /// The roundest corner a layer inside a container takes, however round the
    /// person sets corners in Look and Feel. Folders and Split Views are many
    /// rows tall; corners that followed a capsule setting would turn them into
    /// pills, so the setting is held here and everything else is derived from
    /// it.
    static let maximumNestedCornerRadius: CGFloat = 10

    // MARK: - Actions - Containers

    /// The padding a container keeps under its last row. A row already keeps
    /// half its separation around its own surface, so the container gives that
    /// much less and the surface sits exactly ``containerPadding`` from the
    /// edge, as it does at the sides.
    @MainActor
    static func containerBottomPadding(tabScale: Double) -> CGFloat {
        let separation = BrowserSidebarDensity(tabScale).rowSeparation(
            hasBorders: BrowserDeviceAppearanceStore.shared.tabs.borders == .all)
        return max(0, containerPadding - CGFloat(separation) / 2)
    }

    // MARK: - Actions - Corners

    /// The corner radius of a layer drawn inside `depth` containers, from the
    /// device's corner radius setting.
    @MainActor
    static func layerCornerRadius(depth: Int = 0) -> CGFloat {
        layerCornerRadius(depth: depth, userRadius: BrowserDeviceAppearanceStore.shared.sidebarCornerRadius)
    }

    /// The corner radius of a layer drawn inside `depth` containers, for a
    /// corner radius setting of `userRadius`.
    ///
    /// A layer one container deep wears the setting itself, up to
    /// ``maximumNestedCornerRadius``; the container around it is that plus
    /// ``containerPadding``, so the two curves stay parallel. A setting below
    /// the padding grows the outer corner by no more than the setting, so
    /// Square stays square at every depth and the slider stays continuous.
    static func layerCornerRadius(depth: Int, userRadius: Double) -> CGFloat {
        let setting = userRadius.isFinite ? min(max(CGFloat(userRadius), 0), maximumNestedCornerRadius) : 0
        let outer = setting + min(setting, containerPadding)
        return max(0, outer - containerPadding * CGFloat(max(0, depth)))
    }
}

extension EnvironmentValues {
    /// How many containers — folders and Split Views — hold the layer being
    /// drawn. A list row sets it from where the core places the row, and a
    /// Split View adds one for its members.
    @Entry var sidebarLayerDepth = 0
}
