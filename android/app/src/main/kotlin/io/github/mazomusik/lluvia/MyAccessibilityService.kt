package io.github.mazomusik.lluvia

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

class MyAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Solo procesar eventos si provienen de WhatsApp
        if (event?.packageName != "com.whatsapp") {
            return
        }
        // Handle accessibility events here
    }

    override fun onInterrupt() {
        // Handle service interruption here
    }
}