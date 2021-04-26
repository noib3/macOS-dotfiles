The `folds.vim` file contains the functions `LaTeXFoldsExpr` and
`LaTeXFoldsText` that enable auto code folding in TeX documents based on their
sectioning structure, i.e. their division into `\chapters{..}`,
`\sections{..}`, `\subsections{..}`, etc..

The end result looks something like this:

![tex-code-folding](./screenshots/2021-04-11@17:37:07.png)

The main features are:

* auto detection of folding levels avoiding the need to litter the whole
  `.tex` file with editor-dependent fold markers (i.e. `{{{` and `}}}`);

* section numbers inside fold titles, e.g. the `1` inside `1: A nice title` or
  the `3.1.1` inside `3.1.1: The first subsection of the last chapter` in the
  screenshot above. These are taken from the `.toc` file generated by compiling
  the document, they require the `vimtex` plugin to be active and need to be
  explicitly turned on by setting the `g:LaTeXFolds_use_vimtex_section_numbers`
  global variable equal to 1.

* ability to hide the preamble of a document (i.e. everything before
  `\begin{document}`) by setting `g:LaTeXFolds_fold_preamble` equal to 1.

**Note:** the actual formatting of the fold titles is highly dependent on the
end user's taste and can be modified by changing the `return` statement of the
`LaTeXFoldsExpr` function
([L125](https://github.com/noib3/dotfil3s/blob/master/defaults/neovim/after/ftplugin/tex/folds.vim#L125)).

For example, the formatting function used in the screenshot above is autoloaded
from `folds#format_fold_title` and it's defined
[here](https://github.com/noib3/dotfil3s/blob/master/defaults/neovim/autoload/folds.vim#L10).