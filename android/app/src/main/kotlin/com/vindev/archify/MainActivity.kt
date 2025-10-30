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
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import java.io.File
import java.io.RandomAccessFile
import android.app.ActivityManager
import android.os.StatFs
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import java.net.InetAddress

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "archify/battery_info"
    private val METHOD_CHANNEL = "archify/device_info"
    private val METHOD_CHANNEL_WIFI = "archify/wifi_info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            BatteryStreamHandler(applicationContext)
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_WIFI)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getWifiInfo" -> {
                        val info = getWifiInfo(applicationContext)
                        result.success(info)
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "getCpuInfo" -> {
                    result.success(getCpuInfo())
                }
                "getDeviceInfo" -> {
                    result.success(getDeviceInfo())
                }
                "getStorageInfo" -> {
                    result.success(getStorageInfo())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @Suppress("MissingPermission")
    private fun getWifiInfo(context: Context): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()

        val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        val wifiInfo = wifiManager.connectionInfo

        map["ssid"] = wifiInfo.ssid?.replace("\"", "")
        map["bssid"] = wifiInfo.bssid
        map["rssi"] = "${wifiInfo.rssi} dBm"
        map["linkSpeed"] = "${wifiInfo.linkSpeed} Mbps"
        map["macAddress"] = wifiInfo.macAddress
        map["frequencyMHz"] = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) "${wifiInfo.frequency} MHz" else null

        map["is5GHz"] = wifiInfo.frequency in 4900..5900
        map["is24GHz"] = wifiInfo.frequency in 2400..2500

        // Converts the IP (int) to string
        val ipInt = wifiInfo.ipAddress
        val ip = if (ipInt != 0) {
            InetAddress.getByAddress(
                byteArrayOf(
                    (ipInt and 0xff).toByte(),
                    ((ipInt shr 8) and 0xff).toByte(),
                    ((ipInt shr 16) and 0xff).toByte(),
                    ((ipInt shr 24) and 0xff).toByte()
                )
            ).hostAddress
        } else null
        map["ipAddress"] = ip

        val network = connectivityManager.activeNetwork
        val caps = connectivityManager.getNetworkCapabilities(network)
        val isWifi = caps?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ?: false
        map["isWifiActive"] = isWifi

        return map
    }

    private fun getDeviceInfo(): Map<String, Any?> {
        val infoMap = mutableMapOf<String, Any?>()

        infoMap["manufacturer"] = Build.MANUFACTURER
        infoMap["model"] = Build.MODEL
        infoMap["android_version"] = Build.VERSION.RELEASE
        infoMap["sdk_int"] = Build.VERSION.SDK_INT
        infoMap["soc_manufacturer"] = Build.SOC_MANUFACTURER
        infoMap["soc_model"] = Build.SOC_MODEL

        infoMap["display_id"] = Build.DISPLAY
        infoMap["hardware_name"] = Build.HARDWARE
        infoMap["board_name"] = Build.BOARD

        infoMap["brand"] = Build.BRAND

        return infoMap
    }

    // STORAGE INFO MANAGER
    private fun getStorageInfo(): Map<String, Any?> {
        val infoMap = mutableMapOf<String, Any?>()

        try {
            val stat = StatFs(context.filesDir.path)

            // Note: Values are in bytes (B)
            val blockSize = stat.blockSizeLong
            val totalBlocks = stat.blockCountLong
            val availableBlocks = stat.availableBlocksLong

            infoMap["total_storage_bytes"] = totalBlocks * blockSize
            infoMap["available_storage_bytes"] = availableBlocks * blockSize

        } catch (e: Exception) {
            infoMap["error"] = "Failed to read storage: ${e.message}" // Falha ao ler armazenamento -> Failed to read storage
        }

        return infoMap
    }

    private fun getCpuInfo(): Map<String, Any?> {
        val infoMap = mutableMapOf<String, Any?>()

        // 1. Number Cores
        infoMap["core_count"] = Runtime.getRuntime().availableProcessors()

        // 3. architecture CPU
        infoMap["cpu_architecture"] = Build.CPU_ABI

        // 4. Hardware Manufacturer
        infoMap["hardware_manufacturer"] = Build.HARDWARE

        return infoMap
    }
}

// Class responsible for managing the event stream.
class BatteryStreamHandler(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    // called when the Flutter starts listening to the stream
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events == null) return

        // create a BroadcastReceiver for received system events
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == Intent.ACTION_BATTERY_CHANGED) {
                    // get all of the battery data
                    val batteryInfo = getAllBatteryInfo(context, intent)

                    // send complete Map to Flutter
                    events.success(batteryInfo)
                }
            }
        }

        // Register the receiver to listen for battery changes
        context.registerReceiver(receiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    // called when Flutter stops listening to the stream
    override fun onCancel(arguments: Any?) {
        // Unregisters the receiver to prevent memory leaks and battery drain.
        if (receiver != null) {
            context.unregisterReceiver(receiver)
        }
        receiver = null
    }

    // collects all data from the Intent (robust and complete)
    private fun getAllBatteryInfo(context: Context, batteryStatus: Intent): Map<String, Any?> {
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val infoMap = mutableMapOf<String, Any?>()

        // 1. BATTERY PERCENTAGE (MOST RELIABLE METHOD: CAPACITY)
        val directPercentage = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val finalPercentage = if (directPercentage != Int.MIN_VALUE) {
            directPercentage
        } else {
            // Fallback to Intent method (EXTRA_LEVEL / EXTRA_SCALE)
            val level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            if (level >= 0 && scale > 0) (level * 100) / scale else -1
        }
        infoMap["level"] = finalPercentage

        // 2. Charging Status
        val status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
        val statusString = when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Charging" // Carregando
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "Discharging" // Descarregando
            BatteryManager.BATTERY_STATUS_FULL -> "Full" // Completa
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "Not Charging" // Não Carregando
            BatteryManager.BATTERY_STATUS_UNKNOWN -> "Unknown" // Desconhecido
            else -> "Code: $status" // Código: $status
        }
        infoMap["status"] = statusString

        // 3. Power Source
        val plugType = batteryStatus.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1)
        val plugTypeString = when (plugType) {
            BatteryManager.BATTERY_PLUGGED_AC -> "Cable: AC"
            BatteryManager.BATTERY_PLUGGED_USB -> "USB"
            BatteryManager.BATTERY_PLUGGED_WIRELESS -> "Wireless"
            0 -> "Disconnected"
            else -> "Code: $plugType" // Código: $plugType
        }
        infoMap["plugged_type"] = plugTypeString

        // 4. Battery Health
        val health = batteryStatus.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)
        val healthString = when (health) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good" // Boa
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat" // Superaquecimento
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead" // Morta
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage" // Sobretensão
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Unspecified Failure" // Falha Não Especificada
            BatteryManager.BATTERY_HEALTH_COLD -> "Cold" // Fria
            else -> "Unknown (Code: $health)" // Desconhecida (Código: $health)
        }
        infoMap["health"] = healthString

        // 5. Battery Technology (String)
        infoMap["technology"] = batteryStatus.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Unknown" // Desconhecida

        // 6. Temperature (in tenths of a degree Celsius -> converted to Celsius)
        val temperature = batteryStatus.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
        val tempInCelsius = if (temperature != -1) temperature / 10.0 else -1.0
        infoMap["temperature_celsius"] = tempInCelsius

        // 7. Voltage (in millivolts)
        infoMap["voltage_mv"] = batteryStatus.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)

        return infoMap
    }
}