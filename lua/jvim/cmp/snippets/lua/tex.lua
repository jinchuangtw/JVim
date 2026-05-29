local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

local snippets = {}

local function add(snippet)
  table.insert(snippets, snippet)
end

local function simple_env(trigger, env_name, default_body)
  add(s(
    { trig = trigger, name = env_name, dscr = "\\begin{" .. env_name .. "}" },
    fmta([[
\begin{]] .. env_name .. [[}
  <>
\end{]] .. env_name .. [[}
<>
]], {
      i(1, default_body or ""),
      i(0),
    })
  ))
end

local function opt_env(trigger, env_name, default_opt, default_body)
  add(s(
    { trig = trigger, name = env_name, dscr = "\\begin{" .. env_name .. "}[...]" },
    fmta([[
\begin{]] .. env_name .. [[}[<>]
  <>
\end{]] .. env_name .. [[}
<>
]], {
      i(1, default_opt or ""),
      i(2, default_body or ""),
      i(0),
    })
  ))
end

-- Generic environments --------------------------------------------------------

add(s(
  { trig = "env", name = "generic environment", dscr = "\\begin{env} ... \\end{env}" },
  fmta(
    [[
\begin{<>}
  <>
\end{<>}
<>
]],
    {
      i(1, "environment"),
      i(2),
      rep(1),
      i(0),
    }
  )
))

add(s(
  { trig = "doc", name = "document", dscr = "LaTeX document environment" },
  fmta(
    [[
\documentclass{<>}

\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{amssymb}

\title{<>}
\author{<>}
\date{\today}

\begin{document}

\maketitle

<>

\end{document}
]],
    {
      i(1, "article"),
      i(2, "Title"),
      i(3, "Author"),
      i(0),
    }
  )
))

simple_env("abs", "abstract")
simple_env("cen", "center")
simple_env("fl", "flushleft")
simple_env("fr", "flushright")
simple_env("quote", "quote")
simple_env("quotation", "quotation")
simple_env("comment", "comment")
simple_env("titlepage", "titlepage")
simple_env("appendices", "appendices")

-- Figure environments ---------------------------------------------------------

add(s(
  { trig = "fig", name = "figure", dscr = "figure environment" },
  fmta(
    [[
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.95\textwidth]{Figure/<>}
  \caption{<>}
  \label{fig:<>}
\end{figure}
<>
]],
    {
      i(1, "filename"),
      i(2, "caption"),
      i(3, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "figs", name = "figure*", dscr = "two-column figure environment" },
  fmta(
    [[
\begin{figure*}[htbp]
  \centering
  \includegraphics[width=0.95\textwidth]{Figure/<>}
  \caption{<>}
  \label{fig:<>}
\end{figure*}
<>
]],
    {
      i(1, "filename"),
      i(2, "caption"),
      i(3, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "subfig", name = "subfigure", dscr = "figure with two subfigures" },
  fmta(
    [[
\begin{figure}[htbp]
  \centering
  \begin{subfigure}{0.48\textwidth}
    \centering
    \includegraphics[width=\textwidth]{Figure/<>}
    \caption{<>}
    \label{fig:<>}
  \end{subfigure}
  \hfill
  \begin{subfigure}{0.48\textwidth}
    \centering
    \includegraphics[width=\textwidth]{Figure/<>}
    \caption{<>}
    \label{fig:<>}
  \end{subfigure}
  \caption{<>}
  \label{fig:<>}
\end{figure}
<>
]],
    {
      i(1, "filename-a"),
      i(2, "caption-a"),
      i(3, "label-a"),
      i(4, "filename-b"),
      i(5, "caption-b"),
      i(6, "label-b"),
      i(7, "main caption"),
      i(8, "main-label"),
      i(0),
    }
  )
))

add(s(
  { trig = "subfloat", name = "subfloat figure", dscr = "figure with two subfloat images" },
  fmta(
    [[
\begin{figure}[htbp]
  \centering
  \subfloat[<>]{
    \includegraphics[width=0.48\textwidth]{Figure/<>}
    \label{fig:<>}
  }
  \hfill
  \subfloat[<>]{
    \includegraphics[width=0.48\textwidth]{Figure/<>}
    \label{fig:<>}
  }
  \caption{<>}
  \label{fig:<>}
\end{figure}
<>
]],
    {
      i(1, "caption-a"),
      i(2, "filename-a"),
      i(3, "label-a"),
      i(4, "caption-b"),
      i(5, "filename-b"),
      i(6, "label-b"),
      i(7, "main caption"),
      i(8, "main-label"),
      i(0),
    }
  )
))
-- Table environments ----------------------------------------------------------

add(s(
  { trig = "tab", name = "table", dscr = "table + tabular environment" },
  fmta(
    [[
\begin{table}[htbp]
  \centering
  \caption{<>}
  \label{tab:<>}
  \begin{tabular}{<>}
    \hline
    <>
    \hline
  \end{tabular}
\end{table}
<>
]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "c c c"),
      i(4, "Header 1 & Header 2 & Header 3 \\\\"),
      i(0),
    }
  )
))

add(s(
  { trig = "tabs", name = "table*", dscr = "two-column table environment" },
  fmta(
    [[
\begin{table*}[htbp]
  \centering
  \caption{<>}
  \label{tab:<>}
  \begin{tabular}{<>}
    \hline
    <>
    \hline
  \end{tabular}
\end{table*}
<>
]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "c c c"),
      i(4, "Header 1 & Header 2 & Header 3 \\\\"),
      i(0),
    }
  )
))

add(s(
  { trig = "tblr", name = "tabular", dscr = "tabular environment only" },
  fmta(
    [[
\begin{tabular}{<>}
  \hline
  <>
  \hline
\end{tabular}
<>
]],
    {
      i(1, "c c c"),
      i(2, "Header 1 & Header 2 & Header 3 \\\\"),
      i(0),
    }
  )
))

add(s(
  { trig = "tabx", name = "tabularx", dscr = "tabularx environment" },
  fmta(
    [[
\begin{tabularx}{\textwidth}{<>}
  \hline
  <>
  \hline
\end{tabularx}
<>
]],
    {
      i(1, "X X X"),
      i(2, "Header 1 & Header 2 & Header 3 \\\\"),
      i(0),
    }
  )
))

add(s(
  { trig = "longtab", name = "longtable", dscr = "longtable environment" },
  fmta(
    [[
\begin{longtable}{<>}
  \caption{<>}
  \label{tab:<>} \\

  \hline
  <>
  \hline
  \endfirsthead

  \hline
  <>
  \hline
  \endhead

  <>
\end{longtable}
<>
]],
    {
      i(1, "c c c"),
      i(2, "caption"),
      i(3, "label"),
      i(4, "Header 1 & Header 2 & Header 3 \\\\"),
      i(5, "Header 1 & Header 2 & Header 3 \\\\"),
      i(6, "content"),
      i(0),
    }
  )
))

-- Math environments -----------------------------------------------------------

add(s(
  { trig = "eq", name = "equation", dscr = "numbered equation" },
  fmta(
    [[
\begin{equation}
  <>
  \label{eq:<>}
\end{equation}
<>
]],
    {
      i(1, "equation"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "eqs", name = "equation*", dscr = "unnumbered equation" },
  fmta(
    [[
\begin{equation*}
  <>
\end{equation*}
<>
]],
    {
      i(1, "equation"),
      i(0),
    }
  )
))

add(s(
  { trig = "ali", name = "align", dscr = "numbered align environment" },
  fmta(
    [[
\begin{align}
  <> &= <>
  \label{eq:<>}
\end{align}
<>
]],
    {
      i(1, "lhs"),
      i(2, "rhs"),
      i(3, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "alis", name = "align*", dscr = "unnumbered align environment" },
  fmta(
    [[
\begin{align*}
  <> &= <>
\end{align*}
<>
]],
    {
      i(1, "lhs"),
      i(2, "rhs"),
      i(0),
    }
  )
))

simple_env("aligned", "aligned")
simple_env("split", "split")

add(s(
  { trig = "gather", name = "gather", dscr = "gather environment" },
  fmta(
    [[
\begin{gather}
  <>
  \label{eq:<>}
\end{gather}
<>
]],
    {
      i(1, "equation"),
      i(2, "label"),
      i(0),
    }
  )
))

simple_env("gathers", "gather*")
simple_env("multi", "multline")
simple_env("multis", "multline*")

add(s(
  { trig = "cases", name = "cases", dscr = "cases environment" },
  fmta(
    [[
\begin{cases}
  <>, & <> \\
  <>, & <>
\end{cases}
<>
]],
    {
      i(1, "value"),
      i(2, "condition"),
      i(3, "value"),
      i(4, "condition"),
      i(0),
    }
  )
))

add(s(
  { trig = "dcases", name = "dcases", dscr = "dcases environment" },
  fmta(
    [[
\begin{dcases}
  <>, & <> \\
  <>, & <>
\end{dcases}
<>
]],
    {
      i(1, "value"),
      i(2, "condition"),
      i(3, "value"),
      i(4, "condition"),
      i(0),
    }
  )
))

add(s(
  { trig = "arr", name = "array", dscr = "array environment" },
  fmta(
    [[
\begin{array}{<>}
  <>
\end{array}
<>
]],
    {
      i(1, "c c"),
      i(2, "content"),
      i(0),
    }
  )
))

simple_env("mat", "matrix")
simple_env("pmat", "pmatrix")
simple_env("bmat", "bmatrix")
simple_env("Bmat", "Bmatrix")
simple_env("vmat", "vmatrix")
simple_env("Vmat", "Vmatrix")

-- Lists -----------------------------------------------------------------------

add(s(
  { trig = "item", name = "itemize", dscr = "itemize environment" },
  fmta(
    [[
\begin{itemize}
  \item <>
\end{itemize}
<>
]],
    {
      i(1, "item"),
      i(0),
    }
  )
))

add(s(
  { trig = "enum", name = "enumerate", dscr = "enumerate environment" },
  fmta(
    [[
\begin{enumerate}
  \item <>
\end{enumerate}
<>
]],
    {
      i(1, "item"),
      i(0),
    }
  )
))

add(s(
  { trig = "desc", name = "description", dscr = "description environment" },
  fmta(
    [[
\begin{description}
  \item[<>] <>
\end{description}
<>
]],
    {
      i(1, "term"),
      i(2, "description"),
      i(0),
    }
  )
))

-- Theorem-like environments ---------------------------------------------------
-- These require your template to define them, e.g. via amsthm:
-- \newtheorem{theorem}{Theorem}
-- \newtheorem{lemma}{Lemma}
-- \newtheorem{definition}{Definition}

add(s(
  { trig = "thm", name = "theorem", dscr = "theorem environment" },
  fmta(
    [[
\begin{theorem}
  <>
  \label{thm:<>}
\end{theorem}
<>
]],
    {
      i(1, "statement"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "lem", name = "lemma", dscr = "lemma environment" },
  fmta(
    [[
\begin{lemma}
  <>
  \label{lem:<>}
\end{lemma}
<>
]],
    {
      i(1, "statement"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "prop", name = "proposition", dscr = "proposition environment" },
  fmta(
    [[
\begin{proposition}
  <>
  \label{prop:<>}
\end{proposition}
<>
]],
    {
      i(1, "statement"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "cor", name = "corollary", dscr = "corollary environment" },
  fmta(
    [[
\begin{corollary}
  <>
  \label{cor:<>}
\end{corollary}
<>
]],
    {
      i(1, "statement"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "defn", name = "definition", dscr = "definition environment" },
  fmta(
    [[
\begin{definition}
  <>
  \label{def:<>}
\end{definition}
<>
]],
    {
      i(1, "definition"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "ex", name = "example", dscr = "example environment" },
  fmta(
    [[
\begin{example}
  <>
  \label{ex:<>}
\end{example}
<>
]],
    {
      i(1, "example"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "rem", name = "remark", dscr = "remark environment" },
  fmta(
    [[
\begin{remark}
  <>
\end{remark}
<>
]],
    {
      i(1, "remark"),
      i(0),
    }
  )
))

add(s(
  { trig = "proof", name = "proof", dscr = "proof environment" },
  fmta(
    [[
\begin{proof}
  <>
\end{proof}
<>
]],
    {
      i(1, "proof"),
      i(0),
    }
  )
))

add(s(
  { trig = "asm", name = "assumption", dscr = "assumption environment" },
  fmta(
    [[
\begin{assumption}
  <>
  \label{asm:<>}
\end{assumption}
<>
]],
    {
      i(1, "assumption"),
      i(2, "label"),
      i(0),
    }
  )
))

add(s(
  { trig = "prob", name = "problem", dscr = "problem environment" },
  fmta(
    [[
\begin{problem}
  <>
\end{problem}
<>
]],
    {
      i(1, "problem"),
      i(0),
    }
  )
))

add(s(
  { trig = "sol", name = "solution", dscr = "solution environment" },
  fmta(
    [[
\begin{solution}
  <>
\end{solution}
<>
]],
    {
      i(1, "solution"),
      i(0),
    }
  )
))

-- Code environments -----------------------------------------------------------

simple_env("verb", "verbatim")

add(s(
  { trig = "lst", name = "lstlisting", dscr = "listings code block" },
  fmta(
    [[
\begin{lstlisting}[language=<>]
<>
\end{lstlisting}
<>
]],
    {
      i(1, "Python"),
      i(2, "code"),
      i(0),
    }
  )
))

add(s(
  { trig = "mint", name = "minted", dscr = "minted code block" },
  fmta(
    [[
\begin{minted}{<>}
<>
\end{minted}
<>
]],
    {
      i(1, "python"),
      i(2, "code"),
      i(0),
    }
  )
))

-- Algorithms ------------------------------------------------------------------

add(s(
  { trig = "alg", name = "algorithm", dscr = "algorithm float" },
  fmta(
    [[
\begin{algorithm}[htbp]
  \caption{<>}
  \label{alg:<>}
  <>
\end{algorithm}
<>
]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "algorithm body"),
      i(0),
    }
  )
))

add(s(
  { trig = "algic", name = "algorithmic", dscr = "algorithmic environment" },
  fmta(
    [[
\begin{algorithmic}[1]
  \State <>
\end{algorithmic}
<>
]],
    {
      i(1, "statement"),
      i(0),
    }
  )
))

add(s(
  { trig = "algfull", name = "algorithm + algorithmic", dscr = "algorithm with algorithmic body" },
  fmta(
    [[
\begin{algorithm}[htbp]
  \caption{<>}
  \label{alg:<>}
  \begin{algorithmic}[1]
    \Require <>
    \Ensure <>
    \State <>
  \end{algorithmic}
\end{algorithm}
<>
]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "input"),
      i(4, "output"),
      i(5, "statement"),
      i(0),
    }
  )
))

-- Layout environments ---------------------------------------------------------

add(s(
  { trig = "mini", name = "minipage", dscr = "minipage environment" },
  fmta(
    [[
\begin{minipage}{<>}
  <>
\end{minipage}
<>
]],
    {
      i(1, "0.48\\textwidth"),
      i(2, "content"),
      i(0),
    }
  )
))

add(s(
  { trig = "multicol", name = "multicols", dscr = "multicols environment" },
  fmta(
    [[
\begin{multicols}{<>}
  <>
\end{multicols}
<>
]],
    {
      i(1, "2"),
      i(2, "content"),
      i(0),
    }
  )
))

-- TikZ / PGFPlots -------------------------------------------------------------

add(s(
  { trig = "tikz", name = "tikzpicture", dscr = "tikzpicture environment" },
  fmta(
    [[
\begin{tikzpicture}
  <>
\end{tikzpicture}
<>
]],
    {
      i(1, "\\draw (0,0) -- (1,1);"),
      i(0),
    }
  )
))

add(s(
  { trig = "axis", name = "axis", dscr = "pgfplots axis environment" },
  fmta(
    [[
\begin{axis}[
  xlabel={<>},
  ylabel={<>},
]
  <>
\end{axis}
<>
]],
    {
      i(1, "x"),
      i(2, "y"),
      i(3, "\\addplot coordinates {(0,0) (1,1)};"),
      i(0),
    }
  )
))

-- Beamer ----------------------------------------------------------------------

add(s(
  { trig = "frame", name = "frame", dscr = "beamer frame" },
  fmta(
    [[
\begin{frame}{<>}
  <>
\end{frame}
<>
]],
    {
      i(1, "Title"),
      i(2, "content"),
      i(0),
    }
  )
))

add(s(
  { trig = "cols", name = "columns", dscr = "beamer columns" },
  fmta(
    [[
\begin{columns}
  \begin{column}{0.48\textwidth}
    <>
  \end{column}
  \begin{column}{0.48\textwidth}
    <>
  \end{column}
\end{columns}
<>
]],
    {
      i(1, "left content"),
      i(2, "right content"),
      i(0),
    }
  )
))

add(s(
  { trig = "col", name = "column", dscr = "beamer column" },
  fmta(
    [[
\begin{column}{<>}
  <>
\end{column}
<>
]],
    {
      i(1, "0.48\\textwidth"),
      i(2, "content"),
      i(0),
    }
  )
))

add(s(
  { trig = "block", name = "block", dscr = "beamer block" },
  fmta(
    [[
\begin{block}{<>}
  <>
\end{block}
<>
]],
    {
      i(1, "Title"),
      i(2, "content"),
      i(0),
    }
  )
))

add(s(
  { trig = "alert", name = "alertblock", dscr = "beamer alertblock" },
  fmta(
    [[
\begin{alertblock}{<>}
  <>
\end{alertblock}
<>
]],
    {
      i(1, "Title"),
      i(2, "content"),
      i(0),
    }
  )
))

add(s(
  { trig = "exblock", name = "exampleblock", dscr = "beamer exampleblock" },
  fmta(
    [[
\begin{exampleblock}{<>}
  <>
\end{exampleblock}
<>
]],
    {
      i(1, "Title"),
      i(2, "content"),
      i(0),
    }
  )
))

-- Bibliography-like -----------------------------------------------------------

add(s(
  { trig = "thebib", name = "thebibliography", dscr = "manual bibliography environment" },
  fmta(
    [[
\begin{thebibliography}{<>}
  \bibitem{<>}
  <>
\end{thebibliography}
<>
]],
    {
      i(1, "99"),
      i(2, "key"),
      i(3, "bibliography item"),
      i(0),
    }
  )
))

return snippets
