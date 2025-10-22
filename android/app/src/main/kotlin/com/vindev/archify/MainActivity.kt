package com.vindev.archify
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    // Definimos o canal de eventos para o stream
    private val EVENT_CHANNEL = "archify/battery_info" 

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Configura o EventChannel com o manipulador de stream
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            BatteryStreamHandler(applicationContext)
        )
    }
}

// Classe responsável por gerenciar o stream de eventos
class BatteryStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    // Chamado quando o Flutter começa a escutar o stream
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events == null) return

        // Cria um BroadcastReceiver para receber eventos do sistema
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == Intent.ACTION_BATTERY_CHANGED) {
                    // Obtém todos os dados da bateria
                    val batteryInfo = getAllBatteryInfo(context, intent)
                    
                    // Envia o Map completo para o Flutter
                    events.success(batteryInfo) 
                }
            }
        }
        
        // Registra o receiver para escutar por mudanças na bateria
        context.registerReceiver(receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    // Chamado quando o Flutter para de escutar o stream
    override fun onCancel(arguments: Any?) {
        // Desregistra o receiver para evitar vazamento de memória e consumo de bateria
        if (receiver != null) {
            context.unregisterReceiver(receiver)
        }
        receiver = null
    }

    // Função que coleta todos os dados da Intent (robusta e completa)
    private fun getAllBatteryInfo(context: Context, batteryStatus: Intent): Map<String, Any?> {
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val infoMap = mutableMapOf<String, Any?>()

        // 1. PORCENTAGEM DE BATERIA (MÉTODO MAIS CONFIÁVEL: CAPACITY)
        val directPercentage = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val finalPercentage = if (directPercentage != Int.MIN_VALUE) {
            directPercentage
        } else {
            // Fallback para o método de Intent (EXTRA_LEVEL / EXTRA_SCALE)
            val level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            if (level >= 0 && scale > 0) (level * 100) / scale else -1
        }
        infoMap["level"] = finalPercentage
        
        // 2. Estado de Carregamento
        val status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
        val statusString = when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Carregando"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "Descarregando"
            BatteryManager.BATTERY_STATUS_FULL -> "Completa"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "Não Carregando"
            BatteryManager.BATTERY_STATUS_UNKNOWN -> "Desconhecido"
            else -> "Código: $status"
        }
        infoMap["status"] = statusString

        // 3. Fonte de Energia
        val plugType = batteryStatus.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1)
        val plugTypeString = when (plugType) {
            BatteryManager.BATTERY_PLUGGED_AC -> "Cabo AC"
            BatteryManager.BATTERY_PLUGGED_USB -> "USB"
            BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Sem Fio"
            0 -> "Desconectado"
            else -> "Código: $plugType"
        }
        infoMap["plugged_type"] = plugTypeString

        // 4. Saúde da Bateria
        val health = batteryStatus.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)
        val healthString = when (health) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Boa"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Superaquecimento"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Morta"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Sobretensão"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Falha Não Especificada"
            BatteryManager.BATTERY_HEALTH_COLD -> "Fria"
            else -> "Desconhecida (Código: $health)"
        }
        infoMap["health"] = healthString
        
        // 5. Tecnologia da Bateria (String)
        infoMap["technology"] = batteryStatus.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Desconhecida"

        // 6. Temperatura (em décimos de grau Celsius -> convertida para Celsius)
        val temperature = batteryStatus.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
        val tempInCelsius = if (temperature != -1) temperature / 10.0 else -1.0
        infoMap["temperature_celsius"] = tempInCelsius
        
        // 7. Voltagem (em milivolts)
        infoMap["voltage_mv"] = batteryStatus.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)

        return infoMap
    }
}