//
//  Color+wcag.swift
//  Capable
//
//  Created by Christoph Wendt on 20.11.18.
//

#if os(iOS) || os(tvOS) || os(watchOS)

import UIKit

/// Typealias used for colors. It maps to UIColor.
public typealias Color = UIColor

/// Typealias used for fonts. It maps to UIFont.
public typealias Font = UIFont

#elseif os(OSX)

import AppKit

/// Typealias used for colors. It maps to NSColor.
public typealias Color = NSColor

/// Typealias used for fonts. It maps to NSFont.
public typealias Font = NSFont

#endif

/// Extension that adds functionality for calculating WCAG compliant high contrast colors.
extension Color {

    /**
     Calculates the color ratio for a text color on a background color.

     - Parameters:
         - textColor: The text color.
         - backgroundColor: The background color.

     - Returns: The contrast ratio for a given pair of colors.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    public class func getContrastRatio(forTextColor textColor: Color, onBackgroundColor backgroundColor: Color) -> CGFloat? {
        guard let rgbaTextColor = textColor.rgbaColor, let rgbaBackgroundColor = backgroundColor.rgbaColor else {
            return nil
        }

        return RGBAColor.getContrastRatio(forTextColor: rgbaTextColor, onBackgroundColor: rgbaBackgroundColor)
    }

    /**
     Returns the text color with the highest contrast (black or white) for a given background color.

     - Parameters:
        - backgroundColor: The background color.

     - Returns: A color that has the highest contrast with the given background color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    public class func getTextColor(onBackgroundColor backgroundColor: Color) -> Color? {
        guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }
        let textColor = RGBAColor.getTextColor(onBackgroundColor: rgbaBackgroundColor)

        return textColor == RGBAColor.Colors.black ? .black : .white
    }

    /**
     Calculates the contrast ratio of a given list of text colors and a background color. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

     - Parameters:
         - colors: A list of possible text colors.
         - font: The font used for the text.
         - backgroundColor: The background color that the text should be displayed on.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

     - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    public class func getTextColor(fromColors colors: [Color], withFont font: Font, onBackgroundColor backgroundColor: Color, conformanceLevel: ConformanceLevel = .AA) -> Color? {
        guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }

        for textColor in colors {
            guard let rgbaTextColor = textColor.rgbaColor else { return nil }

            let isValidTextColor = RGBAColor.isValidColorCombination(textColor: rgbaTextColor, fontProps: font.fontProps, onBackgroundColor: rgbaBackgroundColor, conformanceLevel: conformanceLevel)
            if isValidTextColor {
                return textColor
            }
        }

        return nil
    }

    /**
     Returns the background color with the highest contrast (black or white) for a given text color.

     - Parameters:
        - textColor: The textColor color.

     - Returns: A color that has the highest contrast with the given text color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    public class func getBackgroundColor(forTextColor textColor: Color) -> Color? {
        guard let rgbaTextColor = textColor.rgbaColor else { return nil }
        let backgroundColor = RGBAColor.getBackgroundColor(forTextColor: rgbaTextColor)

        return backgroundColor == RGBAColor.Colors.black ? .black : .white
    }

    /**
     Calculates the contrast ratio of a given list of background colors and a text color. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

     - Parameters:
         - colors: A list of possible background colors.
         - textColor: The text color that should be used.
         - font: The font used for the text.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

     - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    public class func getBackgroundColor(fromColors colors: [Color], forTextColor textColor: Color, withFont font: Font, conformanceLevel: ConformanceLevel = .AA) -> Color? {
        guard let rgbaTextColor = textColor.rgbaColor else { return nil }

        for backgroundColor in colors {
            guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }

            let isValidBackgroundColor = RGBAColor.isValidColorCombination(textColor: rgbaTextColor, fontProps: font.fontProps, onBackgroundColor: rgbaBackgroundColor, conformanceLevel: conformanceLevel)
            if isValidBackgroundColor {
                return backgroundColor
            }
        }

        return nil
    }
}
