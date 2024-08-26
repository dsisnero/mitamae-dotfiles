github_binary "uv" do
  repository "astral-sh/uv"
  version "0.3.1"
  ext = ((node[:platform] == "darwin") ? "zip" : "tar.gz")
  archive "uv-x86_64-unknown-linux-gnu.#{ext}"
  binary_path "uv-x86_64-unknown-linux-gnu/uv"
end

execute "uv install python" do
  command "uv python install"
end
