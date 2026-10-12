import SwiftUI

/// Shared hover and press treatment for compact browser chrome controls.
struct CrestChromeButtonStyle: ButtonStyle {
    /// The control's fixed size, or `nil` for a tile that takes the size its
    /// label and container give it.
    var controlSize: CGSize? = CGSize(
        width: CrestLayout.minimumHitTarget,
        height: CrestLayout.minimumHitTarget
    )
    var cornerRadius = CrestLayout.sidebarControlCornerRadius
    /// Draws the device's surface material at rest, for a tile that stands on
    /// its own rather than a glyph that only shows a surface under the pointer.
    var showsRestingSurface = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(
                CrestChromeButtonSurface(
                    isPressed: configuration.isPressed,
                    controlSize: controlSize,
                    cornerRadius: cornerRadius,
                    showsRestingSurface: showsRestingSurface
                )
            )
    }
}

private struct CrestChromeButtonSurface: ViewModifier {
    let isPressed: Bool
    let controlSize: CGSize?
    let cornerRadius: CGFloat
    let showsRestingSurface: Bool

    @Environment(\.isEnabled) private var isEnabled

    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                isEnabled
                    ? Color.primary
                    : Color.secondary.opacity(CrestOpacity.disabled)
            )
            .frame(width: controlSize?.width, height: controlSize?.height)
            .contentShape(.rect)
            .crestHoverSurface(
                isSelected: false,
                cornerRadius: cornerRadius,
                isPressed: isPressed,
                showsRestingSurface: showsRestingSurface
            )
    }
}
