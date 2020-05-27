class Chickadee < Formula
  desc "Module for handling application configuration in a declarative way"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.5.0.tar.gz"
  sha256 "5d37903d417d2c2a8555a55bae384490badaeb62d079a511d11e3effc9057a78"

  bottle :unneeded

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "guile"
  depends_on "guile-opengl"
  depends_on "guile-sdl2"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "openal-soft"

  patch :DATA

  def install
    ENV["GUILE_AUTO_COMPILE"] = "0"

    # We need this so we can find other modules.
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"

    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
    EOS
  end

  test do
    chickadee = testpath/"chickadee.scm"
    chickadee.write <<~EOS
      (use-modules (chickadee))
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"

    system "guile", chickadee
  end
end

__END__
diff --git a/chickadee.scm b/chickadee.scm
index 4edeb03..1284f26 100644
--- a/chickadee.scm
+++ b/chickadee.scm
@@ -232,6 +232,9 @@ border is disabled, otherwise it is enabled.")
                    (controller-move (const #t))
                    error)
   (sdl-init)
+  (sdl2:set-gl-attribute! 'context-major-version 3)
+  (sdl2:set-gl-attribute! 'context-minor-version 2)
+  (sdl2:set-gl-attribute! 'context-profile-mask 1)
   (start-text-input)
   (init-audio)
   (let* ((window (sdl2:make-window #:opengl? #t
diff --git a/chickadee/render/particles.scm b/chickadee/render/particles.scm
index d8778da..9970a2f 100644
--- a/chickadee/render/particles.scm
+++ b/chickadee/render/particles.scm
@@ -116,7 +116,7 @@ indefinitely."
 (define (make-particles-shader)
   (strings->shader
    "
-#version 130
+#version 330
 
 in vec2 position;
 in vec2 tex;
@@ -142,16 +142,17 @@ void main(void) {
 }
 "
    "
-#version 130
+#version 330
 
 in vec2 frag_tex;
 in float t;
+out vec4 fragColor;
 uniform sampler2D color_texture;
 uniform vec4 startColor;
 uniform vec4 endColor;
 
 void main (void) {
-    gl_FragColor = mix(endColor, startColor, t) * texture2D(color_texture, frag_tex);
+    fragColor = mix(endColor, startColor, t) * texture(color_texture, frag_tex);
 }
 "))
 
diff --git a/chickadee/render/pbr.scm b/chickadee/render/pbr.scm
index 2738b77..650b3cf 100644
--- a/chickadee/render/pbr.scm
+++ b/chickadee/render/pbr.scm
@@ -91,7 +91,7 @@
   (delay
     (strings->shader
      "
-#version 130
+#version 330
 
 in vec3 position;
 in vec2 texcoord0;
@@ -106,15 +106,16 @@ void main(void) {
 }
 "
      "
-#version 130
+#version 330
 
 in vec2 fragTex;
+out vec4 fragColor;
 uniform vec3 baseColorFactor;
 uniform sampler2D baseColorTexture;
 
 void main (void) {
-  gl_FragColor = texture2D(baseColorTexture, fragTex) *
-    vec4(baseColorFactor, 1.0);
+  fragColor = texture(baseColorTexture, fragTex) *
+  vec4(baseColorFactor, 1.0);
 }
 ")))
 
diff --git a/chickadee/render/phong.scm b/chickadee/render/phong.scm
index 0f2a938..f14041f 100644
--- a/chickadee/render/phong.scm
+++ b/chickadee/render/phong.scm
@@ -114,7 +114,7 @@
   (delay
     (strings->shader
      "
-#version 130
+#version 330
 
 in vec3 position;
 in vec2 texcoord;
@@ -135,7 +135,7 @@ void main() {
 }
 "
      "
-#version 130
+#version 330
 
 struct Material {
   vec3 ambient;
@@ -162,6 +162,8 @@ struct DirectionalLight {
 in vec3 fragNorm;
 in vec2 fragTex;
 
+out vec4 fragColor;
+
 uniform Material material;
 uniform DirectionalLight directionalLight;
 
@@ -170,20 +172,20 @@ void main() {
     vec3 baseDiffuseColor;
     vec3 baseSpecularColor;
     if(material.useAmbientMap) {
-         baseAmbientColor = texture2D(material.ambientMap, fragTex).xyz;
+         baseAmbientColor = texture(material.ambientMap, fragTex).xyz;
     } else {
          baseAmbientColor = vec3(1.0, 1.0, 1.0);
     }
     if(material.useDiffuseMap) {
          // discard transparent fragments.
-         vec4 color = texture2D(material.diffuseMap, fragTex);
+         vec4 color = texture(material.diffuseMap, fragTex);
          if(color.a == 0.0) { discard; }
          baseDiffuseColor = color.xyz;
     } else {
          baseDiffuseColor = vec3(1.0, 1.0, 1.0);
     }
     if(material.useSpecularMap) {
-         baseSpecularColor = texture2D(material.specularMap, fragTex).xyz;
+         baseSpecularColor = texture(material.specularMap, fragTex).xyz;
     } else {
          baseSpecularColor = vec3(1.0, 1.0, 1.0);
     }
@@ -197,7 +199,7 @@ void main() {
         specularFactor = pow(max(dot(lightDir, reflectDir), 0.0), material.shininess);
     }
     vec3 specularColor = specularFactor * baseSpecularColor * material.specular;
-    gl_FragColor = vec4(ambientColor + diffuseColor + specularColor, 1.0);
+    fragColor = vec4(ambientColor + diffuseColor + specularColor, 1.0);
 }
 ")))
 
diff --git a/chickadee/render/shapes.scm b/chickadee/render/shapes.scm
index f7412e8..e593127 100644
--- a/chickadee/render/shapes.scm
+++ b/chickadee/render/shapes.scm
@@ -58,7 +58,7 @@
            (delay
              (strings->shader
               "
-#version 130
+#version 330
 
 in vec2 position;
 uniform mat4 mvp;
@@ -68,13 +68,14 @@ void main(void) {
 }
 "
               "
-#version 130
+#version 330
 
 in vec2 frag_tex;
+out vec4 fragColor;
 uniform vec4 color;
 
 void main (void) {
-    gl_FragColor = color;
+    fragColor = color;
 }
 ")))
          (mvp (make-null-matrix4)))
@@ -133,7 +134,7 @@ void main (void) {
            (delay
              (strings->shader
               "
-#version 130
+#version 330
 
 in vec2 position;
 in vec2 tex;
@@ -146,9 +147,10 @@ void main(void) {
 }
 "
               "
-#version 130
+#version 330
 
 in vec2 frag_tex;
+out vec4 fragColor;
 uniform vec4 color;
 uniform float r;
 uniform float w;
@@ -204,9 +206,9 @@ void main (void) {
   }
 
   if (d <= hw) {
-    gl_FragColor = color;
+    fragColor = color;
   } else {
-    gl_FragColor = vec4(color.rgb, color.a * (1.0 - ((d - hw) / r)));
+    fragColor = vec4(color.rgb, color.a * (1.0 - ((d - hw) / r)));
   }
 }
 "))))
diff --git a/chickadee/render/sprite.scm b/chickadee/render/sprite.scm
index b6a8232..c2eab96 100644
--- a/chickadee/render/sprite.scm
+++ b/chickadee/render/sprite.scm
@@ -49,7 +49,7 @@
   (delay
     (strings->shader
      "
-#version 130
+#version 330
 
 in vec2 position;
 in vec2 tex;
@@ -62,14 +62,15 @@ void main(void) {
 }
 "
      "
-#version 130
+#version 330
 
 in vec2 fragTex;
+out vec4 fragColor;
 uniform sampler2D colorTexture;
 uniform vec4 tint;
 
 void main (void) {
-    gl_FragColor = texture2D(colorTexture, fragTex) * tint;
+    fragColor = texture(colorTexture, fragTex) * tint;
 }
 ")))
 
@@ -380,7 +381,7 @@ may be specified via the TEXTURE-REGION argument."
   (delay
     (strings->shader
      "
-#version 130
+#version 330
 
 in vec2 position;
 in vec2 tex;
@@ -396,14 +397,15 @@ void main(void) {
 }
 "
      "
-#version 130
+#version 330
 
 in vec2 fragTex;
 in vec4 fragTint;
+out vec4 fragColor;
 uniform sampler2D colorTexture;
 
 void main (void) {
-    gl_FragColor = texture2D(colorTexture, fragTex) * fragTint;
+    fragColor = texture(colorTexture, fragTex) * fragTint;
 }
 ")))
 
diff --git a/doc/api.texi b/doc/api.texi
index 9cfa26a..9123916 100644
--- a/doc/api.texi
+++ b/doc/api.texi
@@ -3147,7 +3147,7 @@ Sample vertex shader:
 
 @example
 @verbatim
-#version 130
+#version 330
 
 in vec2 position;
 in vec2 tex;
@@ -3165,13 +3165,14 @@ Sample fragment shader:
 
 @example
 @verbatim
-#version 130
+#version 330
 
 in vec2 fragTex;
+out vec4 fragColor;
 uniform sampler2D colorTexture;
 
 void main (void) {
-    gl_FragColor = texture2D(colorTexture, fragTex);
+    fragColor = texture(colorTexture, fragTex);
 }
 @end verbatim
 @end example
