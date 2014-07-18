class virtual::packages {
  # Package list
  @package {"atop" : ensure => present }
  @package {"bc" : ensure => present }
  @package {"build-essential" : ensure => present }
  @package {"coreutils": ensure => present}
  @package {"createrepo" : ensure => present }
  @package {"curl" : ensure => present}
  @package {"debootstrap" : ensure => present }
  @package {"dstat" : ensure => present }
  @package {"extlinux" : ensure => present }
  @package {"genisoimage" : ensure => present }
  @package {"git" : ensure => present }
  @package {"htop" : ensure => present }
  @package {"isomd5sum" : ensure => present }
  @package {"kpartx" : ensure => present }
  @package {"libconfig-auto-perl" : ensure => present }
  @package {"libffi-dev" : ensure => present }
  @package {"libmysqlclient-dev" : ensure => present }
  @package {"libparse-debian-packages-perl" : ensure => present }
  @package {"lrzip" : ensure => present }
  @package {"lxc-docker-0.10.0" : ensure => '0.10.0' }
  @package {"multistrap" : ensure => '2.1.6ubuntu3' }
  @package {"nodejs" : ensure => present }
  @package {"nodejs-legacy" : ensure => present }
  @package {"npm" : ensure => present }
  @package {"php5" : ensure => present}
  @package {"php5-fpm" : ensure => present}
  @package {"php5-mysql" : ensure => present}
  @package {"postgresql-server-dev-all" : ensure => present }
  @package {"python-anyjson" : ensure => present }
  @package {"python-dev" : ensure => present }
  @package {"python-devops" : ensure => present }
  @package {"python-daemon" : ensure => present }
  @package {"python-glanceclient" : ensure => present }
  @package {"python-ipaddr" : ensure => present }
  @package {"python-jinja2" : ensure => present }
  @package {"python-keystoneclient" : ensure => present }
  @package {"python-nose" : ensure => present }
  @package {"python-novaclient" : ensure => present }
  @package {"python-paramiko" : ensure => present }
  @package {"python-pip" : ensure => present }
  @package {"python-proboscis" : ensure => present }
  @package {"python-seed-cleaner" : ensure => present }
  @package {"python-seed-client" : ensure => present }
  @package {"python-setuptools" : ensure => present }
  @package {"python-virtualenv" : ensure => present }
  @package {"python-xmlbuilder" : ensure => present }
  @package {"python-yaml" : ensure => present }
  @package {"realpath" : ensure => present }
  @package {"ruby-builder" : ensure => present }
  @package {"ruby-bundler" : ensure => present }
  @package {"ruby-dev" : ensure => present }
  @package {"rubygems-integration" : ensure => present }
  @package {"sysstat" : ensure => present }
  @package {"unzip" : ensure => present }
  @package {"vncviewer" : ensure => present }
  @package {"yum" : ensure => present }
  @package {"yum-utils" : ensure => present }
  # /Package list

  # Meta(pinnings, holds, etc.)
  # apt::hold supported in puppetlabs-apt >= 1.5:
  # apt::hold { 'multistrap': version => '2.1.6ubuntu3' }
  apt::pin { 'multistrap' :
    packages => 'multistrap',
    version => '2.1.6ubuntu3',
    priority => 1000,
  }
  # /Meta(pinnings, holds, etc.)
}
