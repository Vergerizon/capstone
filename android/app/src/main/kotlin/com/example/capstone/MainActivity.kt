package com.example.capstone

import android.content.res.AssetFileDescriptor
import android.media.AudioAttributes
import android.media.SoundPool
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.capstone/audio_engine"

    private var soundPool: SoundPool? = null
    private val soundMap = HashMap<String, Int>()

    companion object {
        init {
            System.loadLibrary("audio_engine")
        }
    }

    private external fun nativeStartAudioEngine(): Boolean
    private external fun nativeStopAudioEngine()
    private external fun nativePlayNote(frequency: Double)
    private external fun nativeStopNote()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initSoundPool()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startAudioEngine" -> {
                    val started = nativeStartAudioEngine()
                    result.success(started)
                }
                "stopAudioEngine" -> {
                    nativeStopAudioEngine()
                    result.success(null)
                }
                "playSample" -> {
                    val assetPath = call.argument<String>("assetPath")
                    if (assetPath != null) {
                        playSampleAudio(assetPath)
                    }
                    result.success(null)
                }
                "playNote" -> {
                    val frequency = call.argument<Double>("frequency") ?: 440.0
                    nativePlayNote(frequency)
                    result.success(null)
                }
                "stopNote" -> {
                    nativeStopNote()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initSoundPool() {
        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()

        soundPool = SoundPool.Builder()
            .setMaxStreams(8)
            .setAudioAttributes(audioAttributes)
            .build()
    }

    private fun playSampleAudio(assetPath: String) {
        val pool = soundPool ?: return
        val soundId = soundMap[assetPath]
        if (soundId != null) {
            pool.play(soundId, 1.0f, 1.0f, 1, 0, 1.0f)
            return
        }

        try {
            // Check Flutter asset path or direct assets/
            val assetLookupKey = flutterEngine?.dartExecutor?.let {
                // If needed, Flutter provides FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath)
                io.flutter.FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(assetPath)
            } ?: assetPath

            val afd: AssetFileDescriptor = assets.openFd(assetLookupKey)
            val loadedId = pool.load(afd, 1)
            soundMap[assetPath] = loadedId
            pool.setOnLoadCompleteListener { sp, sampleId, status ->
                if (status == 0 && sampleId == loadedId) {
                    sp.play(sampleId, 1.0f, 1.0f, 1, 0, 1.0f)
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Failed to load/play audio sample: $assetPath", e)
        }
    }

    override fun onDestroy() {
        nativeStopAudioEngine()
        soundPool?.release()
        soundPool = null
        soundMap.clear()
        super.onDestroy()
    }
}


