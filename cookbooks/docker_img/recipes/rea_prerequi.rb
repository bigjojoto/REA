os_type = node['platform_family']

if os_type == 'debian'
        docker_pkg = 'docker.io'
        apache_pkg = 'apache2'
else
        docker_pkg = 'docker'
        apache_pkg = 'httpd'
end

# Install general packages

#package [docker_pkg, apache_pkg, 'git', 'ruby', 'gcc']
package [apache_pkg, 'git', 'ruby', 'gcc']

# Install Bundler
gem_package 'bundler' do
        action [:install]
end

# Install sinatra
gem_package 'sinatra' do
        action [:install]
end

# Install Passenger
if os_type == 'debian'
        execute 'conf_keys' do
                command 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7'
        end

        package ['apt-transport-https', 'ca-certificates']

file '/etc/apt/sources.list.d/passenger.list' do
  owner 'root'
  group 'root'
  mode '0755'
  content 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main'
end

        execute 'conf_extra' do
                command 'apt-get update'
                command 'apt-get install -y libapache2-mod-passenger'
                end

        package ['libapache2-mod-passenger']
else
        #package ['yum-utils', 'epel-release']
        package ['yum-utils']
        #execute 'conf_epel' do
        #        command 'yum-config-manager --enable epel'
        #end

        package ['pygpgme', 'curl']

        execute 'conf_epel' do
                command 'curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo'
                command 'yum install mod_passenger -y'
        end
end
