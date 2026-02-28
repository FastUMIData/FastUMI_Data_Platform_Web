#!/bin/bash

# 定义目标端口
TARGET_PORT="8887"

# 脚本标题
echo "========================================"
echo "  终止占用 ${TARGET_PORT} 端口的所有进程"
echo "========================================"
echo

# 1. 查找占用目标端口的所有PID（去重、过滤无效值）
# 解析ss命令输出，提取pid字段，过滤空值和非数字（无sudo仅能看到当前用户的进程）
PIDS=$(ss -anpltr | grep -w "${TARGET_PORT}" | \
       grep -o 'pid=[0-9]*' | \
       awk -F '=' '{print $2}' | \
       sort -u | \
       grep -E '^[0-9]+$')

# 2. 校验是否找到PID
if [ -z "$PIDS" ]; then
    echo "✅ 未找到占用 ${TARGET_PORT} 端口的进程（当前用户权限范围内），无需终止。"
    echo "提示：若确认端口被占用但未查到，可能需要root权限（sudo）才能查看其他用户的进程。"
    exit 0
fi

# 3. 列出找到的PID并确认
echo "🔍 找到占用 ${TARGET_PORT} 端口的PID列表（当前用户权限范围内）："
echo "$PIDS"
echo
read -p "❓ 确认要终止以上所有进程吗？(y/N) " CONFIRM

# 4. 确认后执行终止操作
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo
    echo "🌀 开始终止进程..."
    for PID in $PIDS; do
        # 先检查进程是否存在
        if ps -p "$PID" > /dev/null 2>&1; then
            # 先尝试优雅终止（SIGTERM），失败则强制终止（SIGKILL）
            kill "$PID" > /dev/null 2>&1
            sleep 1
            # 检查是否还在运行，若在则强制kill -9
            if ps -p "$PID" > /dev/null 2>&1; then
                echo "⚠️  PID $PID 优雅终止失败，执行强制终止：kill -9 $PID"
                kill -9 "$PID" > /dev/null 2>&1
                # 再次检查强制终止结果
                if ps -p "$PID" > /dev/null 2>&1; then
                    echo "❌ PID $PID 强制终止失败（可能无权限）"
                else
                    echo "✅ PID $PID 已强制终止"
                fi
            else
                echo "✅ PID $PID 已成功终止"
            fi
        else
            echo "ℹ️  PID $PID 已不存在，无需处理"
        fi
    done
    echo
    echo "🎉 操作完成！"
    # 验证结果
    echo "🔍 验证：当前 ${TARGET_PORT} 端口占用情况（当前用户权限）："
    ss -anpltr | grep -w "${TARGET_PORT}" || echo "✅ ${TARGET_PORT} 端口已无占用（当前用户权限范围内）"
else
    echo "🚫 用户取消操作，未终止任何进程。"
    exit 1
fi
