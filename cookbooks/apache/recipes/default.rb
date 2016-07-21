#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
if node["platform"] == "ubuntu"
	execute "apt-get update -y" do
	end
end
#define package resource
package "apache2" do
	package_name node["apache"]["package"]
	#action :install
end
#for each attribute that has apache and sites on it do the following
node["apache"]["sites"].each do |sitename, data|
  #define document root
  document_root = "/content/sites/#{sitename}"
  # set directory resource
  directory document_root do
  	mode "0755"
  	recursive true
  end

# set template_location variable
if node["platform"] == "ubuntu"
  template_location = "/etc/apache2/sites-enabled/#{sitename}.conf"
elsif node['platform'] == 'centos'
  template_location = '/etc/httpd/conf.d/#{sitename}.conf'
end
#use template resource to define where apache configuration file will be
template template_location do
	#define what template within my cookbook to use
	source "vhost.erb"
	mode "0644"
	variables(
		:document_root => document_root,
		:port => data["port"],
		:domain => data["domain"]
	)
	
	notifies :restart, "service[httpd]"	
end
#populate another template
template "/content/sites/#{sitename}/index.html" do
	source "index.html.erb"
	mode "0644"
	variables(
		:site_title => data["site_title"],
		:comingsoon => "Coming Soon!"
	)	
end
end
#create execute resource
execute "rm /etc/httpd/conf.d/welcome.conf" do
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end
service "httpd" do
	service_name node["apache"]["package"]
	action [:enable, :start]
end

#include_recipe "php::default"
