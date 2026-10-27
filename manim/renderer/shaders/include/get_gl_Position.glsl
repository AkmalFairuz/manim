// Assumes the following uniforms exist in the surrounding context:
// uniform vec2 frame_shape;
// uniform float focal_distance;
// uniform float is_fixed_in_frame;
// uniform float is_fixed_orientation;
// uniform vec3 fixed_orientation_center;

// Frame shape from the config (unaffected by camera zoom), so fixed-in-frame
// mobjects also work for non-16:9 outputs such as vertical video.
uniform vec2 default_frame_shape;

float perspective_scale_factor(float z, float focal_distance){
    return max(0.0, focal_distance / (focal_distance - z));
}


vec4 get_gl_Position(vec3 point){
    vec4 result = vec4(point, 1.0);
    if(!bool(is_fixed_in_frame)){
        result.x *= 2.0 / frame_shape.x;
        result.y *= 2.0 / frame_shape.y;
        float psf = perspective_scale_factor(result.z, focal_distance);
        if (psf > 0){
            result.xy *= psf;
            // TODO, what's the better way to do this?
            // This is to keep vertices too far out of frame from getting cut.
            result.z *= 0.01;
        }
    } else{
        if (!bool(is_fixed_orientation)){
            result.x *= 2.0 / default_frame_shape.x;
            result.y *= 2.0 / default_frame_shape.y;
        } else{
            result.x *= 2.0 / frame_shape.x;
            result.y *= 2.0 / frame_shape.y;
        }
    }
    result.z *= -1;
    return result;
}
