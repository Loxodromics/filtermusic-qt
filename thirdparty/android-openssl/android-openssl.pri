# includes openssl libs onto android build
android {

    equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/armeabi-v7a/libcrypto.so
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/armeabi-v7a/libssl.so
    }
    equals(ANDROID_TARGET_ARCH, armeabi) {
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/armeabi/libcrypto.so
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/armeabi/libssl.so
    }
    equals(ANDROID_TARGET_ARCH, x86)  {
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/x86/libcrypto.so
        ANDROID_EXTRA_LIBS += $$PWD/prebuilt/x86/libssl.so
    }
}
