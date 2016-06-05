# Recipe
# Lets configure Apache and deploy the sinatra application
#

os_type = node['platform_family']

#Clone REA repository to document root
git '/var/www/apps' do
        repository 'https://github.com/rea-cruitment/simple-sinatra-app.git'
        enable_checkout false
        action :sync
end

# Configure Apache
if os_type != 'debian'
        template '/etc/httpd/conf.d/passenger.conf' do
                source 'passenger.conf.erb'
        end
else
        template '/etc/apache2/sites-available/000-default.conf' do
                source '000-default.conf.erb'
        end
end

# Copy app content into DocumentRoot
bash 'cp_sources' do
  code <<-EOH
        mkdir -p /var/www/html/simple-sinatra-app
        cp /var/www/apps/* /var/www/html
        rm -rf /var/www/html/index.html
        EOH
end

# Install app with bundle
execute 'install_simpleApp' do
        cwd '/var/www/html'
        command 'bundle install'
        action :run
end
