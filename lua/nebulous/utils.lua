local set_options = require("nebulous.config").set_options
local theme = require("nebulous.scheme")
local color = require("nebulous.colors")

local api = vim.api
local utils = {}

---Apply colors in the editor
--@param group string: group name
--@param cols string: color name to be applied to the groups
local function set_highlights(group, cols)
  api.nvim_command(string.format('highlight %s gui=%s guifg=%s guibg=%s guisp=%s',
    group,
    cols.style or "NONE",
    cols.fg    or "NONE",
    cols.bg    or "NONE",
    cols.sp    or "NONE"
  ))

  if cols.link then
    api.nvim_command(string.format("highlight! link %s %s", group, cols.link))
  end
end

---Load colorscheme
--@param scheme table: editor elements with its colors
--@param custom_tab table: custom color table
local function load_colorscheme(scheme, custom_tab)
  local color_table = scheme or {}
  local overrides = custom_tab or {}

  api.nvim_command("highlight clear")
  if vim.fn.exists("sintax_on") then
    api.nvim_command("syntax reset")
  end

  vim.opt.termguicolors = true
  vim.g.colors_name = "nebulous"
  api.nvim_command("silent! colorscheme nebulous~" ..
    vim.g.nebulous_variant_loaded) -- reset blank colors during variant changeover

  if type(overrides) == "table" then
    if next(overrides) ~= nil then
      color_table = vim.tbl_deep_extend("force", {}, color_table, overrides)
    end
  end

  --Load editor colors
  for grp, col in pairs(color_table) do
    set_highlights(grp, col)
  end
end

--- Set and load the color scheme
--@param opts table: custom options to be applied to the editor
function utils.setup_scheme(opts)
  local conf = set_options(opts)
  local scheme = color.set_scheme(conf.variant)
  local colors = theme.load_colors(scheme)

  load_colorscheme(colors, conf.custom_colors)
end

return utils
