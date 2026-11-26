#include "AudioEngine.h"
#include <android/log.h>

#define TAG "AudioEngine"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)

AudioEngine::AudioEngine() {
}

AudioEngine::~AudioEngine() {
    stop();
}

bool AudioEngine::start() {
    oboe::AudioStreamBuilder builder;
    builder.setDirection(oboe::Direction::Output)
           ->setPerformanceMode(oboe::PerformanceMode::LowLatency)
           ->setSharingMode(oboe::SharingMode::Exclusive)
           ->setFormat(oboe::AudioFormat::Float)
           ->setChannelCount(oboe::ChannelCount::Stereo)
           ->setDataCallback(this);

    oboe::Result result = builder.openStream(stream_);
    if (result != oboe::Result::OK) {
        LOGE("Failed to open audio stream: %s", oboe::convertToText(result));
        return false;
    }

    soundGenerator_.setSampleRate(stream_->getSampleRate());

    result = stream_->requestStart();
    if (result != oboe::Result::OK) {
        LOGE("Failed to start audio stream: %s", oboe::convertToText(result));
        stream_->close();
        stream_.reset();
        return false;
    }

    LOGD("AudioStream started successfully with sample rate: %d", stream_->getSampleRate());
    return true;
}

void AudioEngine::stop() {
    if (stream_) {
        stream_->stop();
        stream_->close();
        stream_.reset();
        LOGD("AudioStream stopped.");
    }
}

void AudioEngine::playNote(double frequency) {
    soundGenerator_.setFrequency(frequency);
    soundGenerator_.setToneOn(true);
}

void AudioEngine::stopNote() {
    soundGenerator_.setToneOn(false);
}

oboe::DataCallbackResult AudioEngine::onAudioReady(
    oboe::AudioStream *audioStream,
    void *audioData,
    int32_t numFrames) {
    auto *floatData = static_cast<float *>(audioData);
    soundGenerator_.render(floatData, numFrames, audioStream->getChannelCount());
    return oboe::DataCallbackResult::Continue;
}
