shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// To jest magia HDR - podkręć to, żeby błysk "wystrzelił" w Bloom!
uniform float shine_energy : hint_range(0.0, 10.0, 0.1) = 2.0; 
// Czas pauzy między błyskami w sekundach
uniform float pause_duration : hint_range(0.0, 10.0, 0.1) = 3.0; 
// Grubość paska światła
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.1;

void fragment() {
    // 1. Pobieramy oryginalny kolor obrazka
    vec4 base_color = texture(TEXTURE, UV);

    // 2. Matematyka czasu. Pętla trwa: 1 sekunda (ruch paska) + czas pauzy (np. 3s)
    float cycle = mod(TIME, 1.0 + pause_duration);

    // 3. Pozycja paska. W 1 sekundę przechodzi od -0.5 do 1.5. 
    // Przez resztę cyklu (pauzę) ucieka na wartość > 1.5, więc znika z obrazka.
    float current_pos = -0.5 + (cycle * 2.0);

    // 4. Kąt 45 stopni, żeby pasek szedł po ukosie
    float projection = (UV.x + UV.y) * 0.5;

    // 5. Rysowanie miękkiego paska (smoothstep zamiast twardego odcięcia)
    float distance = abs(projection - current_pos);
    float shine = smoothstep(shine_size, shine_size * 0.1, distance);

    // 6. Mnożymy przez przezroczystość (base_color.a), 
    // żeby pasek nie rysował się poza krawędziami skrzynki!
    vec3 final_shine = shine_color.rgb * shine_energy * shine * base_color.a;

    // 7. Dodajemy blask do oryginalnego koloru
    COLOR = vec4(base_color.rgb + final_shine, base_color.a);
}
