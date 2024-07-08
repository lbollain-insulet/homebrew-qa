class LibusbmuxdAT202 < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libusbmuxd/archive/refs/tags/2.0.2.tar.gz"
  sha256 "8ae3e1d9340177f8f3a785be276435869363de79f491d05d8a84a59efc8a8fdc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  # libimobiledevice-glue is required for building future versions
  # Move outside of HEAD clause when there's a new release.
  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git", branch: "master"
    depends_on "libimobiledevice-glue"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  uses_from_macos "netcat" => :test

  def install
    system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port
    fork do
      exec bin/"iproxy", "-s", "localhost", "#{source}:#{dest}"
    end

    sleep(2)
    system "nc", "-z", "localhost", source
  end
end
