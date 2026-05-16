/* 扫地机器人斜坡模型 - 改进版 */
// 用于让机器人爬上一个高台
// 特点：渐变厚度设计，节约材料；添加倒角，方便机器人上下

// ========== 参数（单位：mm） ==========
SLOPE_LENGTH = 200;    // 坡长（斜面长度）20cm
HEIGHT       = 40;     // 坡高 4cm
THICKNESS_MAX = 30;    // 最大厚度（后端）3cm
THICKNESS_MIN = 5;     // 最小厚度（前端）5mm，保证强度
WIDTH        = 150;    // 坡宽 15cm
PLATFORM     = 20;     // 坡顶平台长度 2cm
CHAMFER      = 3;      // 倒角大小 3mm

// ========== 派生值 ==========
RUN = sqrt(pow(SLOPE_LENGTH, 2) - pow(HEIGHT, 2));  // 水平投影 ≈196mm

// ========== 2D 截面（带倒角和渐变厚度）==========
module cross_section() {
    polygon([
        // 外轮廓（从前到后，逆时针）
        [CHAMFER, 0],                          // V1: 前端底部（倒角后）
        [0, CHAMFER],                          // V2: 前端底部倒角点
        [0, THICKNESS_MIN],                    // V3: 前端外侧面
        [RUN, HEIGHT],                         // V4: 斜坡顶端
        [RUN + PLATFORM - CHAMFER, HEIGHT],    // V5: 平台顶部（倒角前）
        [RUN + PLATFORM, HEIGHT - CHAMFER],    // V6: 平台顶部倒角点
        [RUN + PLATFORM, 0],                   // V7: 后端底部
        
        // 内轮廓（从后到前，继续逆时针闭合）
        [RUN + PLATFORM - THICKNESS_MAX, 0],   // V8: 后端内侧底部
        [RUN - 10, HEIGHT - THICKNESS_MAX],    // V9: 平台内侧（与斜坡交界）
        [30, THICKNESS_MIN],                   // V10: 前端内侧顶部
        [CHAMFER + 5, CHAMFER],                // V11: 前端内侧倒角过渡
    ]);
}

// ========== 3D 模型（沿宽度方向拉伸）==========
linear_extrude(height = WIDTH) {
    cross_section();
}

// ========== 可选：添加侧面倒角 ==========
// 如果需要侧面也有倒角，可以使用 minkowski 或者更复杂的造型
// 这里先实现基本的截面倒角
