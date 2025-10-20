package gomep.app.dev

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresPermission
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        private const val IMEI_CHANNEL = "imei_channel"
        private const val PREFS_NAME = "gomep.app.dev.device_id_prefs"
        private const val KEY_STABLE_ID = "stable_device_id"
    }
}
