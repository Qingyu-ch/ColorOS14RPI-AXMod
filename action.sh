#!/system/bin/sh
# action.sh - 点"执行"按钮触发，toggle 两次

MODDIR=${0%/*}
FLAG="$MODDIR/.applied"

apply() {
    settings put global window_animation_scale 0.5
    settings put global transition_animation_scale 0.5
    settings put global animator_duration_scale 0.7
    settings put global force_gpu_rendering 1
    settings put global hardware_accelerated_rendering 1
    settings put global hwui.disable_vsync true
    settings put global debug.cpurend.vsync false
    settings put global gfx_overlay_enabled 0
    settings put global debug.sf.enable_gl_backpressure 0
    settings put global debug.sf.latch_unsignaled 1
    settings put global debug.hwui.renderer skiavulkan
    settings put global ro.hwui.use_vulkan true
    settings put system debug.performance.tuning 1
}

restore() {
    settings put global window_animation_scale 1
    settings put global transition_animation_scale 1
    settings put global animator_duration_scale 1
    settings put global force_gpu_rendering 0
    settings put global hardware_accelerated_rendering 1
    settings put global hwui.disable_vsync false
    settings put global debug.cpurend.vsync true
    settings put global gfx_overlay_enabled 1
    settings put global debug.sf.enable_gl_backpressure 1
    settings put global debug.sf.latch_unsignaled 0
    settings put global debug.hwui.renderer default
    settings put global ro.hwui.use_vulkan false
    settings put system debug.performance.tuning 0
}

if [ -f "$FLAG" ]; then
    echo "- 检测到已提帧，将在5秒后还原设置，如果为误触请立即退出！"
    sleep 5
    restore
    rm -f "$FLAG"
    echo "- 已经还原！可以再次点击执行进行优化"
    sleep 1
    exit 0
else
    echo "- 应用参数"
    apply
    touch "$FLAG"
    echo "✓ 完成"
    sleep 1
    exit 0
fi