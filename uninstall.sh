#!/system/bin/sh
# uninstall.sh - 卸载时还原所有修改

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

settings put system vtouch_switch 1
settings put secure multi_press_timeout 300
settings put secure long_press_timeout 400
settings put global game_mode_touch_boost 0

settings put global oppo_screen_refresh_rate_mode 60
settings put secure refresh_rate_mode 60
settings put system peak_refresh_rate 60
settings put system gamewatch_game_target_fps 60
settings put secure speed_mode_enable 0
settings put global cached_apps_freezer disabled

settings put global debug.hwui.level 1
settings put global debug_gpu_overdraw 1
settings put global background_process_limit 8
settings put global debug.egl.force_msaa 0
settings put global disable_hw_overlays 0

settings put global vsr_whitelist_apps ""
settings put global vaa_dynamic_whitelist_apps ""
settings put global vaa_gles_dynamic_whitelist_apps ""
settings put global vaa_gles_whitelist_apps ""
settings put global vaa_tips_whitelist_apps ""
settings put global vaa_whitelist_apps ""
settings put global gpu_memc_dynamic_whitelist_apps ""
settings put global gpu_memc_gles_dynamic_whitelist_apps ""
settings put global gpu_memc_gles_whitelist_apps ""
settings put global gpu_memc_switch_to_ic_memc ""
settings put global gpu_memc_tips_whitelist_apps ""
settings put global gpu_memc_whitelist_apps ""
settings put system key_frame_interpolation_ecosystem ""
