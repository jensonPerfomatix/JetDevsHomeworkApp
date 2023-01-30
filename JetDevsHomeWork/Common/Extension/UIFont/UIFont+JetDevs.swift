//
//  UIFont+JetDevs.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/11/3.
//

import Foundation

import UIKit

extension UIFont {

	static func latoBoldFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-Bold", size: size) ?? UIFont())
	}

	static func latoSemiBoldFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-SemiBold", size: size) ?? UIFont())
	}

	static func latoBlackFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-Black", size: size) ?? UIFont())
	}

	static func latoRegularFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-Regular", size: size) ?? UIFont())
	}

	static func latoMediumFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-Medium", size: size) ?? UIFont())
	}

	static func latoLightFont(size: CGFloat) -> UIFont {
		return (UIFont(name: "Lato-Light", size: size) ?? UIFont())
	}
}
