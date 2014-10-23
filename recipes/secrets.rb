include_recipe "chef-vault"

a = chef_vault_item("secrets", "sjc1")

puts a

rancid_git_sshkey "rancid"