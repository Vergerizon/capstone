cmake_minimum_required(VERSION 3.22.1)
project(audio_engine LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Oboe is exposed via Android Prefab
find_package(oboe REQUIRED CONFIG)

add_library(
    audio_engine
    SHARED
    audio_engine_jni.cpp
    AudioEngine.cpp
    SoundGenerator.cpp
)

target_include_directories(audio_engine PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(
    audio_engine
    PRIVATE
    oboe::oboe
    log
)
