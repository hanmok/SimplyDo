//
//  UIColorExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/04.
//

import UIKit

extension UIColor {
    
    // MARK: rgb 255 init
    /**
     RGB 256 초기화.
     
     RGB 각 값을 각각 256 값으로 대입
     
     **Example**
     ```
     UIColor(r: 255, g: 255, b: 255) // White
     UIColor(r: 255, g: 255, b: 255: alpha: 51) // White20
     UIColor(r: 0, g: 0, b: 0) // Black
     ```
     
     - Parameters:
        - r: 빨간색 값. 0~255 Int형 값을 대입 가능
        - g: 초록색 값. 0~255 Int형 값을 대입 가능
        - b: 파란색 값. 0~255 Int형 값을 대입 가능
        - alpah: 불투명도 값. 0~255 CGFloat형 값을 대입 가능. 값이 없을 경우 불투명도 값 최대로 지정
     */
    
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat? = nil) {
        self.init(red: CGFloat(r) / 255,
                  green: CGFloat(g) / 255,
                  blue: CGFloat(b) / 255,
                  alpha: CGFloat(alpha ?? 255) / 255)
    }
    
    // MARK: hex 8 (alpha+rgb) init
    /**
     불투명+RGB 16진수 초기화
     
     불투명 2자리+RGB 6자리 16진수를 이용한 생성
     
     **Example**
     ```
     UIColor(hex8: 0xFFFFFFFF) // White
     UIColor(hex8: 0x33FFFFFF) // White20
     UIColor(hex8: 0xFF000000) // Black
     ```
     
     - Parameters:
        - hex8 : 불투명도 값을 포함한 RGB값을 16진수로 사용. 각 자리수는 16진수 2자리씩 이용하여 8자리 사용 가능. 0x00000000~0xFFFFFFFF
     */
    
    convenience init(hex8 color: Int) {
        let mask = 0x000000FF
        let alpha = CGFloat(color >> 24 & mask) / 255.0
        self.init(hex6: color, alpha: alpha)
    }
    
    // MARK: hex 6 init
    /**
     RGB 16진수 초기화
     
     RGB 6자리 16진수와 불투명도를 따로 지정하여 생성
     
     **Example**
     ```
     UIColor(hex6: 0xFFFFFF) // White
     UIColor(hex6: 0xFFFFFF, alpha: 0.2) // White20
     UIColor(hex6: 0x000000) // Black
     ```
     
     - Parameters:
        - hex6 : RGB값을 16진수로 사용. 각 자리수는 16진수 2자리씩 이용하여 6자리 사용 가능. 0x000000~0xFFFFFF
        - alpha: 불투명도 값. 0.0~1.0 범위에 값을 지정 가능. 기본값: 1
     */
    
    public convenience init(hex6 color: Int, alpha: CGFloat? = nil) {
        let mask = 0x000000FF
        let red = CGFloat(color >> 16 & mask) / 255.0
        let green = CGFloat(color >> 8 & mask) / 255.0
        let blue = CGFloat(color & mask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha ?? 1)
    }
}

extension UIColor {
    public static let indigoHex = 0x243763
    public static let ivoryHex = 0xFFEBB7
    public static let orangeHex = 0xFF6E31
    
    public static let mainOrange = UIColor(hex6: 0xFF6E31)
    public static let indigo = UIColor(hex6: 0x243763)
    public static let ivory = UIColor(hex6: 0xFFEBB7)
    public static let lightBrown = UIColor(hex6: 0xAD8E70)
}
