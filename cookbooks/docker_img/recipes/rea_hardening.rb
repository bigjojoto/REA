# Load Iptables (Only port 80 and 22 allowed)
#
#
os_type = node['platform_family']

execute 'restore_iptables' do
        cwd '/usr/local/rea_richmond/cookbooks/docker_img/templates/default'
        command 'iptables-restore < rea_iptables.erb'
        action :run
end

if os_type == 'debian'
	apache_pkg = 'apache2'
	execute 'secure_services' do
        command 'echo "ServerTokens Prod" >> /etc/apache2/apache2.conf; echo "ServerSignature Off" >> /etc/apache2/apache2.conf'
        action :run
	end
else
	apache_pkg = 'httpd'
	execute 'secure_services' do
	command 'echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf; echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf'
	command 'iptables-save > /etc/sysconfig/iptables'
	action :run
	end
end

# Make sure apache is up and running
service apache_pkg do
        action [:enable, :restart]
end
