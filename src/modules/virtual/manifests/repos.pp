class virtual::repos {

 class { 'apt':
    always_apt_update => true,
    disable_keys => false,
    purge_sources_list => true,
    purge_sources_list_d => true,
    purge_preferences_d => true,
    update_timeout => 60,
  }

  if $::fqdn =~ /msk\.mirantis\.net$/ {
    # Moscow internal mirror
    $mirror = 'http://mirrors.msk.mirantis.net/ubuntu/'
  }
  elsif $::fqdn =~ /srt\.mirantis\.net$/ {
    # Saratov internal mirror
    $mirror = 'http://mirrors.srt.mirantis.net/ubuntu/'
  }
  elsif $::fqdn =~ /\.vm\.mirantis\.net$/ {
    # VMs, I hope they're in Moscow ;)
    $mirror = 'http://mirrors.msk.mirantis.net/ubuntu/'
  } else {
    # All other servers
    $mirror = 'http://archive.ubuntu.com/ubuntu/'
  }

  if $::fqdn =~ /(\.mirantis\.com|fuel-infra\.org)$/ {
    $devops = 'http://fuel-repository.mirantis.com/devops/ubuntu/'
  } else {
    $devops = 'http://osci-obs.vm.mirantis.net:82/qa-ubuntu/ubuntu/'
  }

  @apt::source { 'mirror':
    location => $mirror,
    release => $::lsbdistcodename,
    key => '437D05B5 C0B21F32',
    repos => 'main restricted universe multiverse',
    include_src => false,
  }

  @apt::source { 'mirror-updates':
    location => $mirror,
    release => "${::lsbdistcodename}-updates",
    key => '437D05B5 C0B21F32',
    repos => 'main restricted universe multiverse',
    include_src => false,
  }

  @apt::source { 'security':
    location => 'http://security.ubuntu.com/ubuntu/',
    release => "${::lsbdistcodename}-security",
    key => '437D05B5 C0B21F32',
    repos => 'main restricted universe multiverse',
  }

  @apt::source { 'devops':
    location => $devops,
    release => '/',
    key => 'D5A05778',
    key_source => "${devops}/Release.key",
    repos => '',
    include_src => false,
  }

  @apt::source { 'docker':
    location => 'http://mirrors-local-msk.msk.mirantis.net/docker',
    release => 'docker',
    key => 'A88D21E9',
    key_source => 'http://mirrors-local-msk.msk.mirantis.net/docker/DOCKER-GPG-KEY',
    repos => 'main',
    include_src => false,
  }

  @apt::source { 'jenkins':
    location => 'http://mirrors-local-msk.msk.mirantis.net/jenkins/debian-stable/',
    release => 'binary/',
    key => 'D50582E6',
    key_source => 'http://mirrors-local-msk.msk.mirantis.net/jenkins/debian-stable/Release.key',
    repos => '',
    include_src => false,
  }
}