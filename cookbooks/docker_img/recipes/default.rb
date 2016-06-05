#
# Cookbook Name:: docker_img
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
#
#

# OS Family version variable
#

include_recipe 'docker_img::rea_prerequi'
include_recipe 'docker_img::rea_conf_app'
include_recipe 'docker_img::rea_services'
include_recipe 'docker_img::rea_hardening'
