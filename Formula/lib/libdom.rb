class Libdom < Formula
  desc "Implementation of the W3C DOM"
  homepage "https://www.netsurf-browser.org/projects/libdom/"
  url "https://download.netsurf-browser.org/libs/releases/libdom-0.4.2-src.tar.gz"
  sha256 "d05e45af16547014c2b0a3aecf3670fa13d419f505b3f5fc7ac8a1491fc30f3c"
  license "MIT"

  depends_on "netsurf-buildsystem" => :build
  depends_on "libhubbub"
  depends_on "libwapcaplet"

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <dom/dom.h>
      #include <stdint.h>

      int main() {
        const uint8_t *data = (const uint8_t *)"test";
        dom_string *str;
        dom_exception ex = dom_string_create(data, 4, &str);
        return ex == DOM_NO_ERR ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-ldom"
    system "./test"
  end
end
