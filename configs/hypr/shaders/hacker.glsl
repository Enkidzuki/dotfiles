#version 320 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float CURVE = 0.03;
const float SCANLINE_STR = 0.4;
const float PHOSPHOR_GLOW = 0.15;

vec2 curve(vec2 uv) {
    vec2 cc = uv - 0.5;
    float dist = dot(cc, cc);
    return uv + cc * dist * CURVE;
}

void main() {
    vec2 uv = curve(v_texcoord);
    
    // Border check
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // Sample color
    vec3 col = texture(tex, uv).rgb;
    
    // Convert to monochrome green (Hacker Green)
    // Using luminance weights to keep contrast
    float lum = dot(col, vec3(0.299, 0.587, 0.114));
    
    // The "Hacker" color palette: pure phosphor green
    vec3 green = vec3(0.2, 1.0, 0.2);
    vec3 ambient = vec3(0.02, 0.1, 0.02); // Dark green background for contrast
    
    vec3 result = mix(ambient, green, lum);
    
    // Add phosphor glow (fake bloom by boosting highlights)
    result += green * pow(lum, 4.0) * PHOSPHOR_GLOW;

    // Scanlines
    float scanline = sin(uv.y * 800.0) * SCANLINE_STR;
    result -= scanline * lum;

    // Subtle horizontal "grille" pattern for that old monitor texture
    float grille = sin(uv.x * 1200.0) * 0.05;
    result += grille * lum;

    // Vignette
    float vig = 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    result *= pow(vig, 0.2);

    fragColor = vec4(result, 1.0);
}
