shader_type canvas_item;

uniform float wind_strength = 4.0; // Сила ветра
uniform float wind_speed = 2.0;    // Скорость ветра
uniform vec2 wind_direction = vec2(1.0, 0.0); // Направление ветра

void vertex() {
    // Случайное смещение для каждой вершины
    float random_offset = fract(sin(dot(VERTEX.xy, vec2(12.9898, 78.233))) * 43758.5453);
    
    // Волнообразное движение с учётом случайного смещения
    float wave = sin(TIME * wind_speed + VERTEX.x * 10.0 + random_offset) * wind_strength;
    
    // Применение анимации к вершинам
    VERTEX.x += wave * wind_direction.x;
    VERTEX.y += wave * wind_direction.y;
}