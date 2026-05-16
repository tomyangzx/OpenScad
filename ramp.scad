/* 扫地机器人斜坡模型 */
// 用于让机器人爬上一个高台

// ========== 参数（单位：mm） ==========
SLOPE_LENGTH = 200;  // 坡长（斜面长度）20cm
HEIGHT       = 50;   // 坡高 5cm
THICKNESS    = 10;   // 厚度 1cm
WIDTH        = 150;  // 坡宽 15cm
PLATFORM     = 20;   // 坡顶平台长度 2cm

// ========== 派生值 ==========
RUN = sqrt(pow(SLOPE_LENGTH, 2) - pow(HEIGHT, 2));  // 水平投影 ≈193.65mm

// 坡面的内法线方向（垂直于坡面，指向材料内部）
NX =  HEIGHT / SLOPE_LENGTH;   // 法线 x 分量
NY = -RUN    / SLOPE_LENGTH;   // 法线 y 分量（指向下方）

// 内坡面顶端点（坡面顶点沿法线方向偏移 THICKNESS）
INNER_TOP_X = RUN      + THICKNESS * NX;  // ≈196.15mm
INNER_TOP_Y = HEIGHT   + THICKNESS * NY;  // ≈40.32mm

// 内坡面与地面的交点（y=0）
INNER_BOTTOM_X = INNER_TOP_X - INNER_TOP_Y * RUN / HEIGHT;  // ≈38mm

// ========== 2D 截面 ==========
module cross_section() {
    polygon([
        [0, 0],                      // V1: 前端底部（地面）
        [RUN + PLATFORM, 0],         // V2: 后端底部（地面）
        [RUN + PLATFORM, HEIGHT],    // V3: 后端顶部（平台右上角）
        [RUN + PLATFORM, HEIGHT - THICKNESS],  // V4: 平台底部（厚度）
        [INNER_TOP_X, INNER_TOP_Y],  // V5: 内坡面顶端
        [INNER_BOTTOM_X, 0],         // V6: 内坡面与地面交点
    ]);
}

// ========== 3D 模型 ==========
linear_extrude(height = WIDTH)
    cross_section();
