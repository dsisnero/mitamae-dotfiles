local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

local wezterm = require 'wezterm'
local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
    )
  do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 Native Tools VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files (x86)/'
          .. vsvers
          .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end
end
table.insert(launch_menu, {
  label = 'btm',
  args = { 'btm'},
})
config.launch_menu = launch_menu


-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'DjangoSmooth'
-- config.color_scheme = 'duckbones'
-- config.color_scheme = 'Earthsong'
-- config.color_scheme = 'Elemental (Gogh)'
-- config.color_scheme = 'Eqie6 (terminal.sexy)'

-- config.color_scheme = 'Espresso (Gogh)'

-- config.color_scheme = 'ForestBlue' -- ended on hemisu dark

config.color_scheme = 'Hemisu Dark (Gogh)'
config.font_size = 10.5

config.default_cwd = 'c:/windows_home/documents'
config.enable_scroll_bar = true

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  

  -- Set a workspace for coding on a current project
  -- Top pane is for the editor, bottom pane is for the build tool
  -- local project_dir = config.default_cwd .. '/../src'
  -- local tab, build_pane, window = mux.spawn_window {
  --   workspace = 'coding',
  --   cwd = project_dir,
  --   args = args,
  -- }
  -- local editor_pane = build_pane:split {
  --   direction = 'Top',
  --   size = 0.8,
  --   cwd = project_dir,
  -- }
  -- -- may as well kick off a build in that pane
  -- build_pane:send_text 'cargo build\n'

  -- A workspace for interacting with a local machine that
  -- runs some docker containners for home automation
  -- local tab, pane, window = mux.spawn_window {
  --   workspace = 'automation',
  --   args = { 'ssh', 'vault' },
  -- }

  -- We want to startup in the coding workspace
  -- mux.set_active_workspace 'coding'
end)
-- and finally, return the configuration to wezterm
return config
