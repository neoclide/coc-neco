# coc-neco

Vim completon source for [coc.nvim](https://github.com/neoclide/coc.nvim) using
[neco-vim](https://github.com/Shougo/neco-vim)

**Note:** this source invode vim function that could be quite slow, so make sure
your `coc.preferences.timeout` is not too low, otherwise it may timeout.

## Install

For vim-plug user, add:

```
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
```

to your `.vimrc` and run `:PlugInstall`

## LICENSE

MIT
