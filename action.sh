#!/system/bin/sh
# action.sh - 点"执行"按钮触发，toggle 提帧↔还原
# 包含 A/B/C/D 四类优化，A类从 game_list.txt 读取包名

MODDIR=${0%/*}
FLAG="$MODDIR/.applied"
GAME_LIST="$MODDIR/game_list.txt"

# ==================== 工具函数 ====================

# 读取 game_list.txt，每行一个包名，输出空格分隔的字符串
read_game_list() {
    if [ -f "$GAME_LIST" ]; then
        tr '\n' ' ' < "$GAME_LIST" | sed 's/ $//'
    else
        echo ""
    fi
}

# 写入 A 类白名单（传入包名字符串，空格分隔）
write_a_whitelist() {
    local pkgs="$1"
    # 如果为空，则清空白名单
    [ -z "$pkgs" ] && pkgs=""
    settings put global vsr_whitelist_apps "$pkgs"
    settings put global vaa_dynamic_whitelist_apps "$pkgs"
    settings put global vaa_gles_dynamic_whitelist_apps "$pkgs"
    settings put global vaa_gles_whitelist_apps "$pkgs"
    settings put global vaa_tips_whitelist_apps "$pkgs"
    settings put global vaa_whitelist_apps "$pkgs"
    settings put global gpu_memc_dynamic_whitelist_apps "$pkgs"
    settings put global gpu_memc_gles_dynamic_whitelist_apps "$pkgs"
    settings put global gpu_memc_gles_whitelist_apps "$pkgs"
    settings put global gpu_memc_switch_to_ic_memc "1_1_1_1_1"
    settings put global gpu_memc_tips_whitelist_apps "$pkgs"
    settings put global gpu_memc_whitelist_apps "$pkgs"
    settings put system key_frame_interpolation_ecosystem "$pkgs"
}

# ==================== apply / restore ====================

apply() {
    # ---- 原有 13 条（A 类核心渲染）----
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

    # ---- B 类：触控响应 ----
    settings put system vtouch_switch 0               # 轻触优化开
    settings put secure multi_press_timeout 10         # 双击间隔 10ms
    settings put secure long_press_timeout 200         # 长按触发 200ms
    settings put global game_mode_touch_boost 1        # 电竞触控加速

    # ---- C 类：刷新率 / 性能模式 ----
    settings put global oppo_screen_refresh_rate_mode 120
    settings put secure refresh_rate_mode 120
    settings put system peak_refresh_rate 120
    settings put system gamewatch_game_target_fps 0    # 不锁帧
    settings put secure speed_mode_enable 1            # 极致性能模式
    settings put global cached_apps_freezer enabled    # 后台冻结

    # ---- D 类：渲染 / SF 补充 ----
    settings put global debug.hwui.level 0             # HWUI 日志最低
    settings put global debug_gpu_overdraw 0           # 关 GPU Overdraw 调试
    settings put global background_process_limit 4     # 后台进程限制
    settings put global debug.egl.force_msaa 1         # 强制 4x MSAA（可选）
    # 注意：disable_hw_overlays 在 ColorOS14 上不一定存在，但无害
    settings put global disable_hw_overlays 1

    # ---- A 类：游戏白名单（从 game_list.txt 读取）----
    local pkg_list
    pkg_list=$(read_game_list)
    if [ -n "$pkg_list" ]; then
        write_a_whitelist "$pkg_list"
        echo "- 已应用游戏白名单：$pkg_list"
    else
        echo "- game_list.txt 为空或不存在，跳过白名单"
        echo "- 请在 $GAME_LIST 中添加游戏包名（每行一个）"
    fi
}

restore() {
    # ---- 还原原有 13 条 ----
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

    # ---- 还原 B 类 ----
    settings put system vtouch_switch 1
    settings put secure multi_press_timeout 300
    settings put secure long_press_timeout 400
    settings put global game_mode_touch_boost 0

    # ---- 还原 C 类 ----
    settings put global oppo_screen_refresh_rate_mode 60
    settings put secure refresh_rate_mode 60
    settings put system peak_refresh_rate 60
    settings put system gamewatch_game_target_fps 60
    settings put secure speed_mode_enable 0
    settings put global cached_apps_freezer disabled

    # ---- 还原 D 类 ----
    settings put global debug.hwui.level 1
    settings put global debug_gpu_overdraw 1
    settings put global background_process_limit 8
    settings put global debug.egl.force_msaa 0
    settings put global disable_hw_overlays 0

    # ---- 清空 A 类白名单 ----
    write_a_whitelist ""
}

# ==================== 主逻辑 ====================

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