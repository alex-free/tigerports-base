#!/bin/bash

set -e
# Typically, if all software bootstrap installs for the OS X version is already
# found bootstrap won't rebuild all of them, unless $bootstrap_rebuld=true
# or if -f is passed to this script.
bootstrap_rebuild=false

cd "$(dirname "$0")"
echo $PWD

if [ "$(uname -r | cut -d. -f1)" = "8" ]; then
    tiger=true
else
    tiger=false
fi

# Mac $PATH, we don't want anything from anywhere else.
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
prefix=/opt/local

for arg
do
    case "$arg" in
        --prefix=*)
            prefix=${arg#--prefix=}
            ;;
        --force)
            bootstrap_rebuild=true 
            ;;
        -f)
            bootstrap_rebuild=true      
            ;;
    esac
done

echo "Using prefix: $prefix"

if [[ ! -w "$prefix" ]]; then
    sudo_needed=true
fi

bootstrap=$prefix/bootstrap

# Last version that builds without requiring a newer perl (5.8.6). Will probably# change this to 1.1.1 to get TLS v1.3 support and just add perl to bootstrap.
ssl=openssl-1.0.2u

# Last version to support OpenSSL v1.x.
curl=curl-8.17.0

# CA certificates extracted from Mozilla
# https://curl.se/docs/caextract.html
certs=cacert-2026-08-13.pem

# Straight from open source apple for 10.5.8, builds without modification.
make=gnumake-119

# Latest versions:
bzip2=bzip2-1.0.8
gzip=gzip-1.15

# Same versions as 10.5.8 (but we don't use open source apple releases from
# Apple (yet) as they need quite a bit of patching.
tar=tar-1.15.1
libarchive=libarchive-2.8.3

number_of_cpus=$(sysctl -n hw.ncpu)
tmp=$(mktemp -d /var/tmp/tigerports-bootstrap.XXX)
# Because this isn't /tmp, we need to make it rwx:
chmod -R 777 $tmp

# When this script exits, automatically delete the temp directory.
cleanup() 
{ 
    if [[ -e $tmp ]]; then
        echo "Clearing temp files..."  
        rm -rf $tmp   
    fi
}
trap cleanup EXIT

configure_base() {
    if [[ "$tiger" == "true" ]]; then
        ./configure \
            --prefix=$prefix \
            --with-curlprefix=$bootstrap \
            --with-gnumake=$bootstrap/bin/make \
            --with-make=$bootstrap/bin/make \
            --with-bzip2_bin=$bootstrap/bin/bzip2 \
            --with-tar=$bootstrap/bin/bsdtar \
            --with-gnutar=$bootstrap/bin/tar
    else
            --prefix=$prefix \
            --with-curlprefix=$bootstrap
    fi

    echo "$0 just ran configure, to finish installation:"
    if [[ "$sudo_needed" == "true" ]]; then
         echo "make -j$number_of_cpus && sudo make install"
    else
        echo "make -j$number_of_cpus && make install"
    fi
}

install_certs() {
    if [[ "$sudo_needed" == "true" ]]; then
       sudo mkdir -p $bootstrap/etc/ssl
       sudo cp -v bootstrap-src/$certs $bootstrap/etc/ssl/cacert.pem
    else
        mkdir -p $bootstrap/etc/ssl
        cp -v bootstrap-src/$certs $bootstrap/etc/ssl/cacert.pem
    fi
}

make_and_install() {
    make -j$number_of_cpus
    
    if [[ "$sudo_needed" == "true" ]]; then
        sudo make install  
    else
        make install
    fi
} 

echo "$(arch)"
if [[ "$(arch)" == ppc ]]; then
    ssl_config_val=darwin-ppc-cc
elif [[ "$(arch)" == i386 ]]; then
    ssl_config_val=darwin-i386-cc
else
    echo "Error: unsupported $arch"
    exit 1
fi

rebuild_bootstrap=true
if [[ "$tiger" == "true" ]]; then
    if [[ ! -e "$bootstrap/bin/make" ]] || \
        [[ ! -e "$bootstrap/bin/openssl" ]] || \
        [[ ! -e "$bootstrap/bin/curl" ]] || \
        [[ ! -e "$bootstrap/bin/bzip2" ]] || \
        [[ ! -e "$bootstrap/bin/gzip" ]] || \
        [[ ! -e "$bootstrap/bin/tar" ]] || \
        [[ ! -e "$bootstrap/bin/bsdtar" ]]; then 
            rebuild_bootstrap=true
    fi 
else
    if [[ ! -e "$bootstrap/bin/openssl" ]] || \
       [[ ! -e "$bootstrap/bin/curl" ]]; then
            rebuild_bootstrap=true
    fi
fi

if [[ "$rebuild_bootstrap" == "false" ]]; then
    echo "Skipping full rebuild of bootstrap software as it is not needed."
    echo "Note: if you want to force rebuilding all bootstrap software anyways:"
    echo ""$0" -f"
    install_certs
    configure_base
    exit 0
else
    echo "Building bootstrap..."

    if [[ "$sudo_needed" ]]; then
        sudo rm -rf $bootstrap
    else
        rm -rf $bootstrap
    fi

    install_certs
fi

# OpenSSL 1.1.1x needs Perl 5.8.6 which tiger does not have, and bootstrap doesn't build (yet).
# OpenSSL 1.0.2 gets us TLSv1.2, which is good enough for gitlab, github, and most distfile sites for now in 2026.
# OpenSSL 1.1.1x will get us to TLSv1.3 if/when that is implemented in bootstrap.
# Using install_sw target skips docs that we don't need and take forever to generate.
# Mac OS X needs Configure not config, so we need to pass it the value it wants.
# Tiger Intel fails on asm so disable it.                     
# Tiger fails on async so disable it.                         
# Tiger fails on threads so disable it.                       
# Mac OS X ships with shared zlib.                            
echo "Building $ssl..."
tar zxf bootstrap-src/$ssl.tar.gz -C $tmp                     
(                                                             
    cd $tmp/$ssl                                              

    ./Configure \
        --prefix=$bootstrap \
        --openssldir=$bootstrap \
        enable-shared \
        zlib-dynamic \
        no-async \
        no-threads \
        no-asm \
        $ssl_config_val

    make -j$number_of_cpus                                    
    
    if [[ "$sudo_needed" == "true" ]]; then
        sudo make install_sw
    else
        make install_sw                                           
    fi
)                                                             
                                                              
# Last version of Curl that can use OpenSSL 1.1.1.x.
# The last version of Curl that can use Tiger system zlib is 8.11.0, but it
# segfaults with it enabled.
# Bootstrap doesn't (yet) build zlib, so disable zlib for now.
# Disable libpsl because Mac OS X doesn't ship with it.
echo "Building $curl..."
tar jxf bootstrap-src/$curl.tar.bz2 -C $tmp                   
(                                                             
    cd $tmp/$curl                                             
    ./configure \                                             
        CPPFLAGS="-I$bootstrap/include" \                     
        LDFLAGS="-L$bootstrap/lib" \                          
        --prefix=$bootstrap \                                 
        --with-ssl=$bootstrap \                               
        --with-ca-bundle=$bootstrap/etc/ssl/cacert.pem \      
        --without-zlib \                                      
        --without-libpsl                                  
                                                              
    make_and_install                                          
)

# Everything after this is tiger specific...
if [[ "$tiger" == false ]]; then
    configure_base
    exit 0
fi

# Patch for patch, bug for bug compatible, directly from open source apple circa 2009 for leopard:
# https://web.archive.org/web/20110707153724/https://opensource.apple.com/release/mac-os-x-1058/
# This uses Apple build infra, so make clean just makes sure /tmp/gnumake is clear.
echo "Building $make..."
tar zxf bootstrap-src/$make.tar.gz -C $tmp
(
    cd $tmp/$make
    make clean
    make

    if [[ "$sudo_needed" == "true" ]]; then
        sudo cp -v /tmp/gnumake/Build/make $bootstrap/bin/make
    else
        cp -v /tmp/gnumake/Build/make $bootstrap/bin/make    
    fi
)

echo "Building $bzip2..."
tar zxf bootstrap-src/$bzip2.tar.gz -C $tmp
(
    cd $tmp/$bzip2

    make -j$number_of_cpus

    if [[ "$sudo_needed" == "true" ]]; then
        sudo make install PREFIX=$bootstrap
    else
        make install PREFIX=$bootstrap
    fi
)

echo "Building $gzip..."
tar zxf bootstrap-src/$gzip.tar.gz -C $tmp
(
    cd $tmp/$gzip
    ./configure \
        --prefix=$bootstap

     make_and_install
)

# Goes off '$PATH' to pull gzip/bzip2.
export PATH=$bootstrap/bin:/bin:/sbin:/usr/bin:/usr/sbin
echo "Building $tar..."
tar zxf bootstrap-src/$tar.tar.gz -C $tmp
(
    cd $tmp/$tar
    ./configure \
        --prefix=$bootstrap

    make_and_install
)

# This actually is the bsdtar command for 10.5+.
echo "Building $libarchive..."
tar zxf bootstrap-src/$libarchive.tar.gz -C $tmp
(
    cd $tmp/$libarchive
    ./configure \
        --prefix=$bootstrap

    make_and_install
)

configure_base
