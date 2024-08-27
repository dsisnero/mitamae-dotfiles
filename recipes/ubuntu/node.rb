cargo_install "fnm"

fnm_init = <<~EOS
  %[eval "$(fnm env --use-on-cd --shell bash)"]
EOS

execute("add fnm env to bashrc") do
  command %(echo '#{fnm_init}' >> #{ENV["HOME"]}/.bashrc)
  not_if %[grep '$(fnm env)' #{ENV["HOME"]}/.bashrc]
end

# execute("install latest node") do
#   command %(sh '#{fnm_init}' ; fnm install --latest)
# end

# execute("set default node to latest") do
#   command %(#{fnm_init} ; fnm default --latest)
# end
