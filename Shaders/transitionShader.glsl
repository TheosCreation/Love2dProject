extern Image trans;
extern number time;
extern number duration;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
{
    vec4 img_color = Texel(tex, tc);
    vec4 trans_color = Texel(trans, tc);
    number white_level = (trans_color.r + trans_color.g + trans_color.b) / 3.0;
    number max_white = time / duration;

    if (white_level <= max_white)
    {
        return img_color;
    }

    img_color.a = 0;
    return img_color;
}
