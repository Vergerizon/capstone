#include <jni.h>
#include <memory>
#include "AudioEngine.h"

static std::unique_ptr<AudioEngine> sAudioEngine;

extern "C" {

JNIEXPORT jboolean JNICALL
Java_com_example_capstone_MainActivity_nativeStartAudioEngine(JNIEnv *env, jobject thiz) {
    if (!sAudioEngine) {
        sAudioEngine = std::make_unique<AudioEngine>();
    }
    return static_cast<jboolean>(sAudioEngine->start());
}

JNIEXPORT void JNICALL
Java_com_example_capstone_MainActivity_nativeStopAudioEngine(JNIEnv *env, jobject thiz) {
    if (sAudioEngine) {
        sAudioEngine->stop();
        sAudioEngine.reset();
    }
}

JNIEXPORT void JNICALL
Java_com_example_capstone_MainActivity_nativePlayNote(JNIEnv *env, jobject thiz, jdouble frequency) {
    if (sAudioEngine) {
        sAudioEngine->playNote(frequency);
    }
}

JNIEXPORT void JNICALL
Java_com_example_capstone_MainActivity_nativeStopNote(JNIEnv *env, jobject thiz) {
    if (sAudioEngine) {
        sAudioEngine->stopNote();
    }
}

} // extern "C"
