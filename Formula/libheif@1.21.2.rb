class LibheifAT1212 < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "shared-mime-info"
  depends_on "webp"
  depends_on "x265"
  depends_on "dav1d"
  depends_on "Zelatrixx/libvips/svt-av1@4.0.1"

  def install
    patch_file = Pathname.new(__dir__).parent/"patches"/"libheif-1.21.2-svt_av1_build_fix-1_gpt-2.patch"
    system "patch", "-p1", "-i", patch_file

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_DAV1D=ON
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=ON
      -DWITH_AOM_DECODER=OFF
      -DWITH_AOM_ENCODER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"

    inreplace lib/"pkgconfig/libheif.pc", prefix, opt_prefix
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end
end
