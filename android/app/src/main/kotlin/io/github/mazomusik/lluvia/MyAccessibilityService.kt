package io.github.mazomusik.lluvia

import android.accessibilityservice.AccessibilityService
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class MyAccessibilityService : AccessibilityService() {
    companion object {
        private const val TAG = "MyAccessibilityService"
        private const val WHATSAPP_PACKAGE = "com.whatsapp"
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.d(TAG, "Servicio de accesibilidad conectado")
        // No es necesario reconfigurar eventTypes ni feedbackType, ya que están en accessibility_service.xml
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.packageName != WHATSAPP_PACKAGE) {
            Log.d(TAG, "Evento descartado: ${event?.packageName}")
            return
        }

        Log.d(TAG, "Evento de WhatsApp. Tipo: ${event.eventType}, Texto: ${event.text}")

        // 1. Procesar notificaciones de WhatsApp
        if (event.eventType == AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED) {
            val notificationText = event.text.joinToString(" ")
            Log.d(TAG, "Notificación de WhatsApp: $notificationText")

            // Extraer información de la notificación (por ejemplo, remitente y mensaje)
            if (notificationText.isNotEmpty()) {
                // Ejemplo: "Juan: Hola, ¿cómo estás?"
                val parts = notificationText.split(": ", limit = 2)
                if (parts.size == 2) {
                    val sender = parts[0]
                    val message = parts[1]
                    Log.d(TAG, "Remitente: $sender, Mensaje: $message")
                }
            }
        }

        // 2. Procesar mensajes en la interfaz de WhatsApp
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED ||
            event.eventType == AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED) {
            val source = event.source
            if (source != null) {
                findMessagesInNode(source)
                source.recycle() // Liberar el nodo para evitar fugas de memoria
            }
        }
    }

    // Función para buscar mensajes en los nodos de la interfaz
    private fun findMessagesInNode(node: AccessibilityNodeInfo?) {
        if (node == null) return

        // Verificar si el nodo contiene texto (por ejemplo, un mensaje en un TextView)
        if (node.text != null && node.className == "android.widget.TextView") {
            val messageText = node.text.toString()
            if (messageText.isNotEmpty()) {
                Log.d(TAG, "Mensaje encontrado en WhatsApp: $messageText")
            }
        }

        // Recorrer los nodos hijos recursivamente
        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            findMessagesInNode(child)
            child?.recycle() // Liberar el nodo hijo
        }
    }

    override fun onInterrupt() {
        Log.d(TAG, "Servicio interrumpido")
    }
}