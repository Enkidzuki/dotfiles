#version 320 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec3 c = color.rgb;
    
    // 1. Crush blacks slightly to make neon pop
    c = pow(c, vec3(1.2)); 
    
    // 2. Color Grading
    // Push shadows towards cool deep blue/purple
    // Push highlights towards cyan/magenta
    
    vec3 shadows = vec3(0.1, 0.0, 0.2); // Deep purple/blue
    vec3 highlights = vec3(0.0, 1.0, 1.0); // Cyan
    
    float lum = dot(c, vec3(0.299, 0.587, 0.114));
    
    vec3 grading = mix(shadows, highlights, lum);
    
    // Blend original with grading
    c = mix(c, grading, 0.3); // 30% grading strength
    
    // 3. Boost Magenta/Pink specifically
    if (c.r > c.g && c.b > c.g) {
        c.r *= 1.2;
        c.b *= 1.2;
    }
    
    fragColor = vec4(c, 1.0);
}
