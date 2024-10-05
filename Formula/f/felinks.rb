class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks"
  url "https://github.com/rkd77/elinks/releases/download/v0.17.1.1/elinks-0.17.1.1.tar.xz"
  sha256 "dc6f292b7173814d480655e7037dd68b7251303545ca554344d7953a57c4ba63"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ebdbb9519964c5d841d3de3adea1dd0bda1ca6bb1ad8d45ad33a68df6674552f"
    sha256 cellar: :any,                 arm64_sonoma:   "57f61582dadfbd450b6c904a1c660e880ea35c5cfab75ef7dab2b6d471d60161"
    sha256 cellar: :any,                 arm64_ventura:  "d30b4c6241c1486776e59e9c9b11c250ae41acbc3295c8d0edcde1722f46948e"
    sha256 cellar: :any,                 arm64_monterey: "3ac7aee0b13a45548e6c122f5f6b0cdb71f072ce515ea21d295285b7983529a3"
    sha256 cellar: :any,                 sonoma:         "f4eb30889668acca94dc26e9f1a307bb4c21825d6e62ab72cfb6b7969038cc51"
    sha256 cellar: :any,                 ventura:        "6d581731eaa6d41d08621adfa248966fb89e1c01b68c9216d8e1eb0ddf68d476"
    sha256 cellar: :any,                 monterey:       "76063ebe01b0b5bc44895113075afa877f7e7b443d18ac00e6127df62d0f8d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec20a05e457d72c74f13e12ce329f14f349488ee543e5e68fe2a1443acde547f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %w[
      -D256-colors=true
      -D88-colors=true
      -Dbittorrent=true
      -Dbrotli=true
      -Dcgi=true
      -Dexmode=true
      -Dfinger=true
      -Dgemini=true
      -Dgnutls=false
      -Dgopher=true
      -Dhtml-highlight=true
      -Dnls=false
      -Dnntp=true
      -Dopenssl=true
      -Dperl=false
      -Dspidermonkey=false
      -Dtre=true
      -Dtrue-color=true
      -Dx=false
      -Dxterm=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    EOS
    assert_match "Abracadabra", shell_output("#{bin}/elinks -dump test.html").chomp
  end
end
