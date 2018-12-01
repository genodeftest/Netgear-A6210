# Maintainer: Nagefire <nagefire.dev@gmail.com>

pkgname=netgear-a6210
pkgver=2.5.0
pkgrel=1
pkgdesc="A driver for Ralink Mediatek mt766u, mt7632u, and mt7612u chipsets"
arch=('any')
url="https://github.com/kaduke/NetGear-A6210"
license=('GPL')

depends=('linux-headers')

optdepends=('dkms: Automatically rebuild drivers upon updating the kernel')

source=("${pkgname}-${pkgver}.tar.gz::https://gitlab.com/Nagefire/${pkgname}/raw/master/tar/${pkgname}-${pkgver}.tar.gz")

#build() {
	cd ${pkgname}-${pkgver}
	make
#}

package() {
	cd ${pkgname}-${pkgver}
	sudo make install
	install.sh dkms_add
}
