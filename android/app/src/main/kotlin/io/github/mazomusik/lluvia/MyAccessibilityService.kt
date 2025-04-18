package io.github.mazomusik.lluvia

import android.accessibilityservice.AccessibilityService
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class MyAccessibilityService : AccessibilityService() {
    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.d("MyAccessibilityService", "Servicio de accesibilidad conectado")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Log completo del evento recibido para depuración
        Log.d("MyAccessibilityService", "Evento recibido: $event")
        // Verifica si el evento es de WhatsApp y loguea más detalles
        if (event != null && event.packageName == "com.whatsapp") {
            Log.d(
              "MyAccessibilityService", 
              "Evento de WhatsApp procesado. Tipo: ${event.eventType}, Texto: ${event.text}"
            )
            // A partir de aquí manejas el evento...
        } else {
            Log.d("MyAccessibilityService", "Evento descartado: ${event?.packageName}")
        }
    }

    override fun onInterrupt() {
        Log.d("MyAccessibilityService", "Servicio interrumpido")
    }
}