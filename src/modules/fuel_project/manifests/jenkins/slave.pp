# Class: fuel_project::jenkins_slave
#
class fuel_project::jenkins::slave (
  $external_host         = false,
  $build_fuel_iso        = false,
  $run_tests             = false,
  $simple_syntax_check   = false,
  $verify_fuel_web       = false,
  $verify_fuel_astute    = false,
  $verify_fuel_docs      = false,
  $ldap                  = false,
  $fuelweb_iso           = false,
  $ldap_uri              = '',
  $ldap_base             = '',
  $tls_cacertdir         = '',
  $pam_password          = '',
  $pam_filter            = '',
  $sudoers_base          = '',
  $bind_policy           = '',
  $ldap_ignore_users     = '',
) {
  class { '::fuel_project::common' :
    external_host     => $external_host,
    ldap              => $ldap,
    ldap_uri          => $ldap_uri,
    ldap_base         => $ldap_base,
    tls_cacertdir     => $tls_cacertdir,
    pam_password      => $pam_password,
    pam_filter        => $pam_filter,
    sudoers_base      => $sudoers_base,
    bind_policy       => $bind_policy,
    ldap_ignore_users => $ldap_ignore_users,
  }
  include venv
  include system_tests
  include transmission_daemon

  if $external_host == true {
    include ::jenkins::slave
  } else {
    include ::jenkins::swarm_slave
  }

  # Run system tests
  if $run_tests == true {
    class { '::libvirt' :
      listen_tls         => false,
      listen_tcp         => true,
      auth_tcp           => 'none',
      mdns_adv           => false,
      unix_sock_group    => 'libvirtd',
      unix_sock_rw_perms => '0777',
      python             => true,
      qemu               => true,
      deb_default        => {
        'libvirtd_opts' => '-d -l',
      }
    }

    libvirt_pool { 'default' :
      ensure    => 'present',
      type      => 'dir',
      autostart => true,
      target    => '/var/lib/libvirt/images',
      require   => Class['libvirt'],
    }

    if ! defined(Package['qemu-kvm']) {
      package { 'qemu-kvm' :
        ensure => installed
      }
    }
  }

  # Buiid ISO
  if $build_iso == true {
    class { '::build_fuel_iso' :
      external_host => $external_host,
    }
  }

  # *** Custom tests ***

  # Web tests by verify-fuel-web, stackforge-verify-fuel-web
  if $verify_fuel_web {
    $verify_fuel_web_packages = [
      'inkscape',
      'rst2pdf',
      'python2.6',
      'python2.6-dev',
      'python-all-dev',
      'python-sphinx',
      'python-cloud-sptheme',
      'python-virtualenv',
      'python-tox',
      'postgresql',
      'nodejs-legacy',
      'npm',
      'libxslt1-dev',
    ]
    each($verify_fuel_web_packages) |$package| {
      if ! defined(Package[$package]) {
        package { $package :
          ensure => installed,
        }
      }
    }
    if ! defined(Class['postgresql::server']) {
      class { 'postgresql::server' : }
    }
    postgresql::server::db { 'nailgun':
      user     => 'nailgun',
      password => 'nailgun',
    }
    exec { 'install_global_npm' :
      command => '/usr/bin/npm -g install grunt-cli casperjs phantomjs',
      require => Package['npm'],
    }
    file { '/var/log/nailgun' :
      ensure  => directory,
      owner   => 'jenkins',
      require => User['jenkins'],
    }
  }

  # Astute tests require only rvm package
  if $verify_fuel_astute {
    class { 'rvm' : }
    rvm::system_user { 'jenkins': }
    rvm_system_ruby { 'ruby-2.1.2' :
      ensure      => 'present',
      default_use => true,
      require     => Class['rvm'],
    }
    rvm_gem { 'bundler' :
      ensure       => 'installed',
      ruby_version => 'ruby-2.1.2',
      require      => Rvm_system_ruby['ruby-2.1.2'],
    }
    # FIXME: remove this hack, create package raemon?
    $raemon_file = '/tmp/raemon-0.3.0.gem'
    file { $raemon_file :
      source => 'puppet:///modules/fuel_project/gems/raemon-0.3.0.gem',
    }
    rvm_gem { 'raemon' :
      ensure       => 'installed',
      ruby_version => 'ruby-2.1.2',
      source       => $raemon_file,
      require      => [ Rvm_system_ruby['ruby-2.1.2'], File[$raemon_file] ],
    }

    if $simple_syntax_check {
      rvm_gem { 'puppet-lint' :
        ensure       => 'installed',
        ruby_version => 'ruby-2.1.2',
        require      => Rvm_system_ruby['ruby-2.1.2'],
      }
    }
  }

  # Simple syntax check by:
  # - verify-fuel-devops
  # - fuellib_review_syntax_check (puppet tests)
  if $simple_syntax_check {
    $syntax_check_packages = [
      'python-flake8',
      'python-tox',
      'puppet-lint',
      'libxslt1-dev'
    ]
    each($syntax_check_packages) |$package| {
      if ! defined(Package[$package]) {
        package { $package :
          ensure => installed,
        }
      }
    }
  }

  if $verify_fuel_docs {
    $verify_fuel_docs_packages =  [
      'inkscape',
      'rst2pdf',
      'make',
      'python-sphinx',
      'python-cloud-sptheme',
      'plantuml',
      'python-sphinxcontrib.plantuml',
    ]
    each($verify_fuel_docs_packages) |$package| {
      if ! defined(Package[$package]) {
        package { $package :
          ensure => installed,
        }
      }
    }
  }

  if $fuelweb_iso {
    class { '::nginx::share' :
      fuelweb_iso_create => true,
    }
  }
}
