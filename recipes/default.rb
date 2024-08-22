want = (node[:platform] == "pop") ? "ubuntu" : node[:platform]
puts "platform #{want}"
include_recipe "base"
include_recipe want
package "vim"
