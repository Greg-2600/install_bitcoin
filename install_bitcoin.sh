#!/bin/bash 

install_dependencies() {

	dependencies="
		build-essential
		libtool
		autotools-dev
		automake
		pkg-config
		bsdmainutils
		python3
		libevent-dev
		libboost-system-dev
		libboost-filesystem-dev
		libboost-test-dev
		libboost-thread-dev
		"

	for dependency in $dependencies; do
		sudo apt install -y "$dependency"
	done
}


pull_compile() {

	repo='bitcoin'
	git clone "https://github.com/$repo/$repo.git"

	if [ -d "${repo}" ]; then


		cd ${repo} || exit 1

		#git pull

		./autogen.sh

		./configure --disable-wallet --without-gui --without-miniupnpc --enable-hardening

		cores=$(grep -c 'model name' /proc/cpuinfo)
		make -j "$cores"

		cd src || exit 1
	fi

}


main() { 
	install_dependencies && pull_compile 
	echo "Usage: $PWD/bitcoind"
}

main
