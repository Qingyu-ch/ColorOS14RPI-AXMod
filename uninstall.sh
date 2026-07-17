#!/system/bin/sh

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