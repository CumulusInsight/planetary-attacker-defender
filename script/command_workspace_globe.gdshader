shader_type canvas_item;
render_mode unshaded;
uniform float drift = 0.0;
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453); }
float noise(vec2 p) {
	vec2 i=floor(p), f=fract(p); f=f*f*(3.0-2.0*f);
	return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);
}
float terrain(vec2 p) {
	float n=0.0, a=0.5;
	for(int i=0;i<5;i++){n+=a*noise(p);p=mat2(vec2(1.6,1.2),vec2(-1.2,1.6))*p+3.7;a*=0.5;}
	return n;
}
void fragment() {
	vec2 pixel=UV*vec2(1600.0,900.0);
	vec2 p=(pixel-vec2(760.0,470.0))/325.0;
	float r=length(p);
	vec3 color=vec3(0);float alpha=0.0;
	if(r<1.0){
		float z=sqrt(max(0.0,1.0-dot(p,p)));
		vec3 sphere=vec3(p,z);
		vec2 map=vec2(atan(sphere.x,sphere.z),asin(sphere.y));
		float land=terrain(map*5.5+vec2(drift,0.0));
		vec3 ocean=mix(vec3(0.018,0.085,0.16),vec3(0.04,0.22,0.32),terrain(map*19.0));
		vec3 coast=mix(ocean,vec3(0.10,0.23,0.21),smoothstep(0.50,0.56,land));
		float clouds=smoothstep(0.49,0.71,terrain(map*vec2(15,29)+vec2(drift*1.4,2.0)));
		color=mix(coast,vec3(0.56,0.69,0.75),clouds*0.68);
		float light=0.35+0.65*max(0.0,dot(normalize(vec3(-0.4,-0.4,1.0)),sphere));
		color*=light;
		color+=vec3(0.10,0.36,0.48)*pow(1.0-z,12.0)*0.6;
		alpha=1.0;
	}else if(r<1.035){
		float glow=exp(-(r-1.0)*190.0);
		color=vec3(0.21,0.65,0.85);alpha=glow*0.5;
	}
	COLOR=vec4(color,alpha);
}
