#!/system/bin/sh
# service.sh - AxManager 启用后 setsid 拉起，禁用时 Reignite 杀 PID

MODDIR=${0%/*}

watch_keys() {
    vsync=$(settings get global hwui.disable_vsync)
    [ "$vsync" != "true" ] && settings put global hwui.disable_vsync true

    gpu=$(settings get global force_gpu_rendering)
    [ "$gpu" != "1" ] && settings put global force_gpu_rendering 1

    renderer=$(settings get global debug.hwui.renderer)
    [ "$renderer" != "skiavulkan" ] && settings put global debug.hwui.renderer skiavulkan

    anim1=$(settings get global window_animation_scale)
    [ "$anim1" != "0.5" ] && settings put global window_animation_scale 0.5

    anim2=$(settings get global transition_animation_scale)
    [ "$anim2" != "0.5" ] && settings put global transition_animation_scale 0.5

    anim3=$(settings get global animator_duration_scale)
    [ "$anim3" != "0.7" ] && settings put global animator_duration_scale 0.7
}

watch_keys

while true; do
    sleep 120
    watch_keys
done
