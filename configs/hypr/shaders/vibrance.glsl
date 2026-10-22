#version 320 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float VIBRANCE = 0.5; // Intensity of the effect (0.0 to 1.0+)

void main() {
    vec4 color = texture(tex, v_texcoord);
    
    // Calculate luminance
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Determine the average saturation of the pixel
    float average = (color.r + color.g + color.b) / 3.0;
    float mx = max(color.r, max(color.g, color.b));
    float amount = (mx - average) * (-VIBRANCE * 3.0);
    
    // Boost saturation
    color.rgb = mix(color.rgb, vec3(mx), amount);
    color.rgb = mix(color.rgb, vec3(luminance), -VIBRANCE);
    
    // Simple S-curve for contrast
    // color.rgb = pow(color.rgb, vec3(0.9)); 

    fragColor = color;
}
