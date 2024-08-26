class Specinfra::Command::Pop < Specinfra::Command::Ubuntu
end
include_recipe "rust::user"
cargo_home = node[:rust][:cargo_home]
cargo_cmd = "#{cargo_home}/bin/cargo"
# define cargo_install command
define :cargo_install, version: nil, locked: true, path: nil, git: nil,
  features: nil, binname: nil do
  cargo_name = params[:name]
  binname = params[:binname] || params[:name]
  cmd = "#{cargo_cmd} install #{cargo_name}"
  cmd << " --version #{params[:version]}" if params[:version]
  cmd << " --path #{params[:path]}" if params[:path]
  cmd << " --git #{params[:git]}" if params[:git]
  cmd << " --features #{params[:features]}" if params[:features]
  cmd << " --locked" if params[:locked]
  execute "installing_cmd" do
    user node[:user]
    command cmd
    not_if "test -e #{cargo_home}/bin/#{binname}"
  end
end

cargo_install "sccache"

# add RUSTC_WRAPPER to .bashrc
execute "add RUSTC_WRAPPER to .bashrc" do
  command "echo 'export RUSTC_WRAPPER=#{ENV["HOME"]}/.cargo/bin/sccache' >> #{ENV["HOME"]}/.bashrc"
  command "source #{ENV["HOME"]}/.bashrc"
  not_if "grep 'export RUSTC_WRAPPER' #{ENV["HOME"]}/.bashrc"
end

cargo_install "cargo-update" do
  locked false
end

cargo_install "broot" do
  features "clipboard,trash"
end

cargo_install "du-dust"
cargo_install "ripgrep" do
  binname "rg"
end
cargo_install "fd-find" do
  binname "fd"
end
cargo_install "bottom" do
  binname "btm"
end

# install helix
git "helix" do
  repository "https://github.com/helix-editor/helix"
  destination "#{ENV["HOME"]}/src/helix"
  user node[:user]
  revision "HEAD"
end

execute "helix compile" do
  cwd "#{ENV["HOME"]}/src/helix"
  user node[:user]
  command "#{cargo_cmd} install --path helix-term --locked"
  not_if "which hx"
end

# add HELIX_RUNTIME to .bashrc
execute "add HELIX_RUNTIME to .bashrc" do
  command "echo 'export HELIX_RUNTIME=#{ENV["HOME"]}/src/helix/runtime' >> #{ENV["HOME"]}/.bashrc"
  not_if "grep 'export HELIX_RUNTIME' #{ENV["HOME"]}/.bashrc"
end
