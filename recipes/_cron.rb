include_recipe "cron"
# install the cron job to run diff but doesn't do anything until it's setup with
# the routers/switch to query and groups etc.
cron_d "hourly-rancid-diff" do
  hour 1
  command "#{node[:rancid][:install_dir]}/bin/rancid-run"
  user node[:rancid][:user]
end

cron_d "daily-clean-up" do
  hour 23
  command "/usr/bin/find #{node[:rancid][:install_dir]}/var/rancid/logs -type f -mtime +2 -exec rm {} \;"
  user node[:rancid][:user]
end