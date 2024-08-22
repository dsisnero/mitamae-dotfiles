include_recipe "rust::user"

# define cargo_install command
define :cargo_install, version: nil, locked: true, path: nil, git: nil, features: nil do
  cargo_name = params[:name]
  cmd = "cargo install #{cargo_name}"
  cmd << " --version #{params[:version]}" if params[:version]
  cmd << " --path #{params[:path]}" if params[:path]
  cmd << " --git #{params[:git]}" if params[:git]
  cmd << " --features #{params[:features]}" if params[:features]
  cmd << " --locked" if params[:locked]
  execute cmd
end

cargo_install "sccache"
# add RUSTC_WRAPPER to .bashrc
execute "add RUSTC_WRAPPER to .bashrc" do
  command "echo 'export RUSTC_WRAPPER=#{ENV["HOME"]}/.cargo/bin/sccache' >> #{ENV["HOME"]}/.bashrc"
  not_if "grep 'export RUSTC_WRAPPER' #{ENV["HOME"]}/.bashrc"
end

cargo_install "cargo-update", locked: false
cargo_install "broot", features: "clipboard,trash"
cargo_install "du-dust"
cargo_install "ripgrep"
cargo_install "fd-find"
cargo_install "bottom"

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
  command "cargo install --path helix-term --locked --release"
  not_if "test -f #{ENV["HOME"]}/bin/helix"
end

# add HELIX_RUNTIME to .bashrc
execute "add HELIX_RUNTIME to .bashrc" do
  command "echo 'export HELIX_RUNTIME=#{ENV["HOME"]}/src/helix/runtime' >> #{ENV["HOME"]}/.bashrc"
  not_if "grep 'export HELIX_RUNTIME' #{ENV["HOME"]}/.bashrc"
end
