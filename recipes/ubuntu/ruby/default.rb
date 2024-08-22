include_recipe 'nm_chruby/system'

dotfile ".config/irb/irbc"
dotfile ".config/gem/gemrc"
# Ruby build dependencies
package "libffi-dev"
package "libreadline-dev"
package "libssl-dev"

# Ruby source build dependencies
package "autoconf"
package "bison"

%w(standardrb solargraph ruby-lsp).each do |gem|
  gem_package gem
end
