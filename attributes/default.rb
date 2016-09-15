default['bwa']['version'] = '0.7.15'
default['bwa']['filename'] = "bwa-#{node['bwa']['version']}.tar.bz2"
default['bwa']['url'] = "http://sourceforge.net/projects/bio-bwa/files/#{node['bwa']['filename']}"
default['bwa']['install_path'] = '/usr/local'
default['bwa']['dir'] = default['bwa']['install_path'] + '/' + 'bwa-' + default['bwa']['version']
default['bwa']['bin_path'] = '/usr/local/bin'
