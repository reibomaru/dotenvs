local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- 現ディレクトリとgitブランチ名を取得
local function set_title(pane)

  local cwd_uri = pane:get_current_working_dir()

  local cwd_uri_string = wezterm.to_string(cwd_uri)
  local cwd = cwd_uri_string:gsub("^file://", "")

  if (not cwd) then
    return nil
  end

  -- Gitのブランチ名を取得
  local success, stdout, stderr = wezterm.run_child_process({
    "git", "-C", cwd, "branch", "--show-current"
  })

  local current_dir = cwd:match("^.*/(.*)$")

  local ret = current_dir

  -- Gitブランチ名を取得できたら「ブランチ名:ディレクトリ名」と表示できるようにする
  if success then
    local branch = stdout:gsub("%s+", "")
    ret = branch .. ':' .. current_dir
  end

  return ret

end

-- 各タブの「ブランチ名:ディレクトリ名」を記憶しておくテーブル
local title_cache = {}

-- 各タブ（正確にはpane）に「ブランチ名:ディレクトリ名」を記憶させる
wezterm.on("update-status", function(window, pane)

  local title = set_title(pane)
  local pane_id = pane:pane_id()
  
  title_cache[pane_id] = title
  
end)

-- タブのタイトルを変更
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

  local pane = tab.active_pane
  local pane_id = pane.pane_id

  -- 記憶させていた「ブランチ名:ディレクトリ名」を取り出す
  if title_cache[pane_id] then
    return title_cache[pane_id]
  else
    return tab.active_pane.title
  end

end)

-- ウィンドウのタイトルを変更
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)

  --[[
     以下サイトの書き方に従う
     https://wezfurlong.org/wezterm/config/lua/window-events/format-window-title.html
  ]]
  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  local title = tab.active_pane.title

  local pane_id = pane.pane_id

  -- 記憶させていた「ブランチ名:ディレクトリ名」を取り出す
  if title_cache[pane_id] then
    title = title_cache[pane_id]
  end

  return zoomed .. index .. title

end)


-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
-- config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)


----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys

config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config

