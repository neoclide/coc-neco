function! coc#source#neco#init() abort
  return {
        \ 'priority': 9,
        \ 'shortcut': 'NEC',
        \ 'filetypes': ['vim'],
        \}
endfunction

function! coc#source#neco#should_complete(opt) abort
  if !get(g:, 'loaded_necovim', 0) | return 0 | endif
  let ch = a:opt['line'][a:opt['col'] - 1]
  if ch ==# '"' || ch ==# "'" | return 0 | endif
  let synName = synIDattr(synID(a:opt['linenr'],a:opt['colnr'],1), 'name')
  if synName ==# 'vimString' || synName ==# 'vimLineComment' | return 0 | endif
  return 1
endfunction

function! coc#source#neco#get_startcol(opt) abort
  let colnr = a:opt['colnr']
  let part = colnr == 1 ? '' : a:opt['line'][0:colnr-2]
  let col = necovim#get_complete_position(part)
  let ch = a:opt['line'][col + 1]
  " Tell coc that we're going to start matching after the colon, even though
  " it's a lie. We'll fix this down below.
  if ch ==# ':'
    return col + 2
  endif
  return col
endfunction

function! coc#source#neco#complete(opt, cb) abort
  let colnr = a:opt['colnr']
  let part = a:opt['line'][0:colnr - 2]
  let changed = get(a:opt, 'changed', 0)
  if changed < 0
    let changed = 0
  endif

  " Get the complete position again in the case where we're prefixed by 
  let col = necovim#get_complete_position(part)
  let input = a:opt['line'][col :]

  let items = necovim#gather_candidates(part, input)
  call a:cb(s:Filter(input, items, changed))
endfunction

function! s:Filter(input, items, index)
  let ch = a:input[a:index]
  let colon = a:input =~# '\v^[bwtglsav]:'
  let res = []
  for item in a:items
    let word = item['word']
    if !empty(ch) && word[a:index] !=# ch
      continue
    endif
    if !colon && word[1:1] =~# ':'
      continue
    endif
    let o = {}
    for [key, value] in items(item)
      if key ==# 'word' && value =~# '($'
        let o[key] = value[0:-2]
      elseif key ==# 'word' && value =~# '()$'
        let o[key] = value[0:-3]
      else
        let o[key] = value
      endif
      if key ==# 'word' && colon
        let o[key] = o[key][2:]
      endif
    endfor
    call add(res, o)
  endfor
  return res
endfunction
