#version 320 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
uniform float time;
out vec4 fragColor;

float text(vec2 uv) {
    vec2 grid = floor(uv);
    vec2 subuv = fract(uv);
    float checksum = sin(grid.x * 123.45 + grid.y * 567.89);
    if (fract(checksum * 1000.0) > 0.5) return 0.0;
    
    // Random "character" shapes
    float char = smoothstep(0.5, 0.4, length(subuv - 0.5));
    char *= step(0.3, fract(sin(grid.x + grid.y) * 43758.5453));
    return char;
}

void main() {
    vec2 uv = v_texcoord;
    vec3 scene = texture(tex, uv).rgb;
    
    // Matrix parameters
    vec2 rain_uv = uv * vec2(60.0, 30.0); // Grid size
    float speed = 2.0;
    
    // Offset columns randomly
    float col_id = floor(rain_uv.x);
    float offset = sin(col_id * 789.123) * 10.0;
    rain_uv.y += time * (1.0 + fract(sin(col_id) * 10.0)) * speed + offset;
    
    // Calculate rain trail
    float trail = fract(-rain_uv.y);
    trail = pow(trail, 3.0); // Sharpen the "head" of the drop
    
    // Character glow
    float chars = text(rain_uv);
    vec3 matrix_color = vec3(0.0, 1.0, 0.3) * chars * trail;
    
    // Glow/Bloom for the rain
    matrix_color += vec3(0.0, 0.5, 0.1) * trail * 0.5;
    
    // Mix with original scene (Green-tinted)
    vec3 final = mix(scene * vec3(0.5, 1.0, 0.5), matrix_color, 0.5);
    
    fragColor = vec4(final, 1.0);
}
