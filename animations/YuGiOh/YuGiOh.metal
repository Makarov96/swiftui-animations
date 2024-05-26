//
//  YuGiOh.metal
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 25/05/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}

//[[ stitchable ]] half4 chromatic_abberation_static(float2 position ,SwiftUI::Layer layer, float red, float blue) {
//
//    // FIRST, WE STORE THE ORIGINAL COLOR.
//    half4 original_color = layer.sample(position);
//    
//    // WE CREATE A NEW COLOR VARIABLE TO STORE THE MODIFIED COLOR.
//    half4 new_color = original_color;
//    
//    // WE MODIFY THE COLOR BY SHIFTING THE RED AND BLUE CHANNELS.
//    new_color.r = layer.sample( position - float2(red, -red)).r + 0.1;
//    
//    // GREEN IS OPTIONAL, BUT WE CAN USE IT TO CREATE A MORE REALISTIC EFFECT.
//    new_color.g = layer.sample(position).g + 0.1;
//    
//    new_color.b = layer.sample( position - float2(blue, -blue)).b + 0.1;
//
//    // WE RETURN THE NEW COLOR.
//  
//
//    return new_color;
//    
//}

[[ stitchable ]] 
half4 chromatic_abberation_static(
      float2 position,
      SwiftUI::Layer layer,
      float red,
      float blue) {


    half4 original_color = layer.sample(position);
    
    half4 new_color = original_color;
        
    new_color.r = layer.sample( position - float2(red, -red)).r + 0.1;
   
    new_color.g = layer.sample(position).g + 0.1;
    
    new_color.b = layer.sample( position - float2(blue, -blue)).b + 0.1;

    return new_color;
    
}



[[ stitchable ]] 
half4 timeVaryingColor(float2 position, half4 color, float2 size, float time) {
    return half4(oscillate(2 * time + position.x/size.x),
                 oscillate(4 * time + position.y/size.y),
                 oscillate(-2 * time + position.x/size.y),
                 1.0);
}

[[ stitchable ]]
half4 chromatic(float2 position, SwiftUI::Layer layer, float x, float y) {
    // FIRST, WE STORE THE ORIGINAL COLOR.
    half4 original_color = layer.sample(position);
    
    
    return half4(oscillate(2 * 13 + position.x/original_color.r),
                 original_color.g,
                 oscillate(-2 * 13 + position.x/original_color.b),
                 1.0);
}




