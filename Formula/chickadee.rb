class Chickadee < Formula
  desc "Game development toolkit for Guile"
  homepage "https://dthompson.us/projects/chickadee.html"
  url "https://files.dthompson.us/chickadee/chickadee-0.8.0.tar.gz"
  sha256 "c02660b6799b9c30d7858e426dfbeb9f5dbbd58190d7cccd60969ef205ad4dcc"
  revision 3

  bottle do
    root_url "https://github.com/aconchillo/homebrew-guile/releases/download/chickadee-0.8.0_2"
    sha256 x86_64_linux: "5c88977029dffdbf8cda84e9e8c0b1358fb40f37c4be0d4dc9216897065db85c"
  end

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
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "./configure", "--prefix=#{prefix}"

    # Use Homebrew /usr/local/opt instead.
    inreplace buildpath/"chickadee/config.scm" do |s|
      s.gsub!(%r{".*/libopenal"}, "\"#{HOMEBREW_PREFIX}/opt/openal-soft/lib/libopenal\"")
      s.gsub!(%r{".*/libvorbisfile"}, "\"#{HOMEBREW_PREFIX}/opt/libvorbis/lib/libvorbisfile\"")
      s.gsub!(%r{".*/libmpg123"}, "\"#{HOMEBREW_PREFIX}/opt/mpg123/lib/libmpg123\"")
      s.gsub!(%r{".*/libfreetype"}, "\"#{HOMEBREW_PREFIX}/opt/freetype/lib/libfreetype\"")
      s.gsub!(%r{".*/libreadline"}, "\"#{HOMEBREW_PREFIX}/opt/readline/lib/libreadline\"")
    end

    system "make", "install"
  end

  def post_install
    # Touch config.go to avoid Guile recompilation.
    touch "#{lib}/guile/3.0/site-ccache/chickadee/config.go"
  end

  def caveats
    <<~EOS
      Remember to add the following to your .bashrc or equivalent in order to use this module:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
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
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", chickadee
  end
end

__END__
diff --git a/data/shaders/pbr-frag.glsl b/data/shaders/pbr-frag.glsl
index a211096..0986840 100644
--- a/data/shaders/pbr-frag.glsl
+++ b/data/shaders/pbr-frag.glsl
@@ -66,6 +66,9 @@ const float GAMMA = 2.2;
 vec4 texture(sampler2D tex, vec2 coord) {
   return texture2D(tex, coord);
 }
+vec4 texture(samplerCube tex, vec3 coord) {
+  return textureCube(tex, coord);
+}
 #endif

 float posDot(vec3 v1, vec3 v2) {
@@ -364,7 +367,7 @@ void main(void) {
   //
   // TODO: Use fancy PBR equations instead of these basic ones.
   float fresnel = pow(1.0 - clamp(dot(viewDirection, normal), 0.0, 1.0), 5);
-  vec3 ambientDiffuse = textureCube(skybox, normal).rgb;
+  vec3 ambientDiffuse = texture(skybox, normal).rgb;
   vec3 ambientSpecular = textureLod(skybox, reflection, roughness * 7.0).rgb;
   color += (ambientDiffuse * albedo + ambientSpecular * fresnel) * ambientOcclusion;
   // Apply Reinhard tone mapping to convert our high dynamic range
diff --git a/data/shaders/phong-frag.glsl b/data/shaders/phong-frag.glsl
index c1a19c1..2d70fda 100644
--- a/data/shaders/phong-frag.glsl
+++ b/data/shaders/phong-frag.glsl
@@ -50,6 +50,9 @@ const float GAMMA = 2.2;
 vec4 texture(sampler2D tex, vec2 coord) {
   return texture2D(tex, coord);
 }
+vec4 texture(samplerCube tex, vec3 coord) {
+  return textureCube(tex, coord);
+}
 #endif

 vec3 gammaCorrect(vec3 color) {
@@ -161,7 +164,7 @@ void main() {
   // Apply image based ambient lighting.
   float fresnel = pow(1.0 - clamp(dot(viewDir, normal), 0.0, 1.0), 5);
   float roughness = 1.0 - (material.shininess / 1000.0);
-  vec3 ambientDiffuse = textureCube(skybox, normal).rgb * diffuseColor;
+  vec3 ambientDiffuse = texture(skybox, normal).rgb * diffuseColor;
   vec3 ambientSpecular = textureLod(skybox, reflection, roughness * 7.0).rgb * fresnel;
   vec3 ambientColor = (ambientDiffuse + ambientSpecular) * ambientOcclusion;
   color += ambientColor;
