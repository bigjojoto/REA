
os_type = node['platform_family']

if os_type == 'debian'
        docker_pkg = 'docker.io'
        apache_pkg = 'apache2'
else
        docker_pkg = 'docker'
        apache_pkg = 'httpd'
end


# Make sure apache is up and running
service apache_pkg do
        action [:enable, :restart]
end
