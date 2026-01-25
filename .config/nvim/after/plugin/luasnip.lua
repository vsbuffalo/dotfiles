-- Keymaps (expand/jump)
local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.choice_active() then ls.change_choice(1) end
end, { silent = true })

-- Bridge filetypes so "tex" snippets work in latex/plaintex
ls.filetype_extend("latex", { "tex" })
ls.filetype_extend("plaintex", { "tex" })

-- Snippets
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

-- Register for TEX ONLY; others inherit via filetype_extend above
ls.add_snippets("tex", {
  s("mathy", fmt([[
\documentclass[11pt]{{article}}
\RequirePackage{{fullpage}}
\RequirePackage{{amsmath,amssymb,amsthm}}
\RequirePackage{{graphicx}}
\RequirePackage[hidelinks]{{hyperref}}
\RequirePackage{{subcaption}}
\RequirePackage{{wasysym}}
\RequirePackage{{authblk}}
\RequirePackage{{bm}}
\RequirePackage{{bbm}}
\RequirePackage{{cleveref}}
\RequirePackage[bibstyle=authoryear,citestyle=authoryear-comp,
                date=year,
                maxbibnames=9,maxnames=5,maxcitenames=2,
                backend=biber,uniquelist=false,uniquename=false,
                sorting=nyt,
                hyperref=true]{{biblatex}}
\RequirePackage{{color}}
\RequirePackage{{nicefrac}}

% \addbibresource{{biblio.bib}}

\title{{{}}}
\author{{{}}}

\begin{{document}}
\maketitle

\begin{{abstract}}
{}
\end{{abstract}}

\section*{{Introduction}}
{}

% \printbibliography
\end{{document}}
]], {
    i(1, "Title"),
    i(2, "Author Name"),
    i(3, "Insert abstract here."),
    i(4, "Insert introduction here."),
  }))
})

-- (Optional) Rust snippet
ls.add_snippets("rust", {
  s("mdt", { t("#[cfg(test)]"), t({ "", "mod tests {", "    " }), i(1), t({ "", "}" }) }),
})

