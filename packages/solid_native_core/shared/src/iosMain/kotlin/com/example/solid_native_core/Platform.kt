package com.example.solid_native_core

import platform.JavaScriptCore.JSExportProtocol
import platform.UIKit.UIDevice

class IOSPlatform: Platform {
    override val name: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
}

actual fun getPlatform(): Platform = IOSPlatform()


final class LL : JSExportProtocol {

}