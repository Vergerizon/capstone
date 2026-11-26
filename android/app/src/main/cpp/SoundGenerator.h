#ifndef SOUND_GENERATOR_H
#define SOUND_GENERATOR_H

#include <atomic>
#include <cmath>

class SoundGenerator {
public:
    SoundGenerator() = default;

    void setFrequency(double frequency) {
        frequency_.store(frequency);
    }

    void setSampleRate(int32_t sampleRate) {
        sampleRate_ = sampleRate;
    }

    void setToneOn(bool isToneOn) {
        isToneOn_.store(isToneOn);
        if (!isToneOn) {
            phase_ = 0.0;
        }
    }

    void render(float* targetData, int32_t numFrames, int32_t channelCount) {
        bool toneOn = isToneOn_.load();
        double freq = frequency_.load();
        double phaseIncrement = (2.0 * M_PI * freq) / static_cast<double>(sampleRate_);

        for (int i = 0; i < numFrames; ++i) {
            float sample = 0.0f;
            if (toneOn) {
                sample = static_cast<float>(std::sin(phase_) * 0.5); // 0.5 amplitude
                phase_ += phaseIncrement;
                if (phase_ >= 2.0 * M_PI) {
                    phase_ -= 2.0 * M_PI;
                }
            }

            for (int ch = 0; ch < channelCount; ++ch) {
                targetData[i * channelCount + ch] = sample;
            }
        }
    }

private:
    std::atomic<double> frequency_{440.0};
    std::atomic<bool> isToneOn_{false};
    int32_t sampleRate_{48000};
    double phase_{0.0};
};

#endif // SOUND_GENERATOR_H
