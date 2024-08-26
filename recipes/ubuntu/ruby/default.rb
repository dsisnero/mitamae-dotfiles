package "libffi-dev"
package "libreadline-dev"
package "libssl-dev"

# Ruby source build dependencies
package "autoconf"
package "bison"

node.reverse_merge!(
  ruby: {
    versions: %w[
      3.3.4
    ]
  },
  mruby: {
    versions: %w[
      3.3.0
    ]
  }
)

include_recipe "nm_chruby::user"

chruby_init = <<-EOS
  source /usr/local/share/chruby/chruby.sh 
  source /usr/local/share/chruby/auto.sh
EOS

chruby_init.split("\n").each do |line|
  execute "append #{line} to bashrc" do
    command "echo '#{line}' >> #{ENV["HOME"]}/.bashrc"
    not_if "grep 'chruby/auto.sh' #{ENV["HOME"]}/.bashrc"
  end
end

define :ruby_install, family: "ruby", path: nil do
  cmd = "ruby-install"
  install_dir = params[:path] || File.join(ENV["HOME"], ".rubies")
  cmd << "  --rubies-dir #{install_dir}"
  version = params[:name]
  family = params[:family]
  cmd << " "  # {version}
  execute "ruby-install #{family} #{version}" do
    user node[:user]
    not_if "test -e #{install_dir}/#{family}-#{version}"
  end
end

node[:ruby][:versions].each do |version|
  ruby_install version
end
node[:ruby][:versions].each do |version|
  execute "source /usr/local/share/chruby/chruby.sh ; chruby ruby-#{version}"
  node[:ruby][:packages].each do |pkg|
    gem_package pkg
  end
end

node[:mruby][:versions].each do |version|
  ruby_install version do
    family "mruby"
  end
end
# node[:ruby][:versions].each do |version|
# execute "ruby-install #{version}" do
# command "sh /usr/local/share/chruby/chruby.sh ;  ruby-install #{version}"
# # not_if  "#{ruby_init} ruby versions | grep #{version}"
# not_if  "ls ~/.rubies versions | grep ruby-#{version}"
# # user    node[:ruby][:user] if node[:ruby][:user]
# end
# end

# if node[:ruby][:global]
#   node[:ruby][:global].tap do |version|
#     execute "ruby global #{version}" do
#       command "#{ruby_init} ruby global #{version}"
#       not_if  "#{ruby_init} ruby version | grep #{version}"
#       user    node[:ruby][:user] if node[:ruby][:user]
#     end
#   end
# end

dotfile ".config/irb/irbc"
dotfile ".config/gem/gemrc"
# Ruby build dependencies
