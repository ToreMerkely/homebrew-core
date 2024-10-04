class Glycin < Formula
  desc "Sandboxed and extendable image loading"
  homepage "https://gitlab.gnome.org/sophie-h/glycin"
  url "https://download.gnome.org/sources/glycin/1.1/glycin-1.1.1.tar.xz"
  sha256 "560ee42167c1ed22826618e61d83e49140db5bf47a65a9ba8ece2cd73d2a4aa8"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  head "https://gitlab.gnome.org/sophie-h/glycin.git", branch: "main"

  # We use a common regex because glycin doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/glycin[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "gperf" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "rust" => :build
  depends_on "vala" => :build # for vapigen
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "little-cms2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"glycin-test.c").write <<~C
      #include "glycin-1/glycin.h"
      int main() {
        GlyLoader *loader = gly_loader_new("#{test_fixtures("test.png")}");
        return loader == 0;
      }
    C
    ENV.append_to_cflags shell_output("pkg-config --cflags glycin-1 gtk4 cairo").strip
    ENV.append "LDFLAGS", shell_output("pkg-config --libs-only-L glycin-1").strip
    ENV.append "LDLIBS", shell_output("pkg-config --libs-only-l glycin-1").strip
    system "make", "glycin-test"
    system "./glycin-test"
  end
end
