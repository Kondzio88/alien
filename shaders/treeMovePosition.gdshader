// Godot 4.4 — CanvasItem shader: delikatny wiatr dla koron drzew (samo kołysanie)
shader_type canvas_item;

// === Parametry wiatru ===
uniform float wind_amp_px : hint_range(0.0, 4.0, 0.05) = 4.0; // siła w pikselach
uniform float wind_freq   : hint_range(0.0, 4.0, 0.01) = 4.0;  // częstotliwość kołysania
uniform float wind_turbulence : hint_range(0.0, 2.0, 0.01) = 0.5; // nieregularność
uniform float edge_sway_boost : hint_range(0.0, 2.0, 0.01) = 2.0; // brzegi poruszają się bardziej

// Różnicowanie między drzewami:
uniform vec2 seed = vec2(123.4, 567.8); // ustaw inne wartości per drzewo
uniform vec2 world_pos = vec2(0.0, 0.0); // (opcjonalnie) globalna pozycja drzewa

// --- proste funkcje pseudo-losowe ---
float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

vec2 wind_dir(vec2 uv, float t) {
    // bazowy kierunek z seeda, powoli rotujący w czasie
    float base_ang = hash21(seed) * 6.2831853 + t * 0.15;
    vec2 base = vec2(cos(base_ang), sin(base_ang));

    // lokalne zawirowanie wg UV i world_pos (lekka “szorstkość”)
    float n1 = sin(dot(uv * 7.0  + world_pos * 0.03 + seed,   vec2(3.1, 2.7)) + t * wind_freq);
    float n2 = cos(dot(uv * 11.0 + world_pos * 0.02 + seed.yx, vec2(1.7, 4.3)) - t * (wind_freq * 0.6));
    vec2 turb = normalize(base * 0.6 + vec2(n1, n2) * wind_turbulence + 1e-5);
    return turb;
}

void fragment(){
    float t = TIME;
    vec2 uv = UV;

    // Brzegi kołyszą się mocniej niż środek
    float edge_mask = smoothstep(0.2, 0.95, distance(uv, vec2(0.5)));
    edge_mask = mix(1.0, 1.0 + edge_sway_boost, edge_mask);

    vec2 dir = wind_dir(uv, t);
    float amp_mod = 0.6 + 0.4 * sin(t * (wind_freq * 0.5) + hash21(seed + 0.37) * 6.2831853);

    // UV-warp w pikselach -> konwersja przez TEXTURE_PIXEL_SIZE
    vec2 uv_warp = dir * wind_amp_px * TEXTURE_PIXEL_SIZE * amp_mod * edge_mask;

    COLOR = texture(TEXTURE, uv + uv_warp) * COLOR;
}
