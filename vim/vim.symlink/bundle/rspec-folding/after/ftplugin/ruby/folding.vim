function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let numlines = line('$')
  let current = a:lnum + 1

  while current <= numlines
    if getline(current) =~? '\v\S'
      return current
    endif
    let current += 1
  endwhile

  return -2
endfunction

" function! RSpecFolds(lnum)
"     if getline(a:lnum) =~? '\v^\s*$'
"         return '-1'
"     endif

"     let this_indent = IndentLevel(a:lnum)
"     let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

"     if next_indent == this_indent
"         return this_indent
"     elseif next_indent < this_indent
"         return this_indent
"     elseif next_indent > this_indent
"         echomsg "hello"
"         return '>' . next_indent
"     endif
" endfunction

function! RSpecFolds(lnum)
  if getline(a:lnum) =~? '\v^\s*$'
    return '-1'
  endif

  let this_line = getline(a:lnum)
  let this_indent = IndentLevel(a:lnum)
  let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

  let previous_line_number = v:lnum - 1
  let previous_line = getline(l:previous_line_number)
  let previous_indent = IndentLevel(getline(l:previous_line_number))


  " echomsg "---->" l:previous_line_number l:previous_line
  if match(l:this_line, '\v^\s*(describe|context|it|before)') >= 0
    return l:this_indent + 1
  elseif match(l:previous_line, '\v^\s*end') >= 0
    return 0
    return l:previous_indent-1
  " elseif match(this_line, '\v^\s*end') >= 0
  "   return this_indent
  else
    return "="
  endif

  " if match(this_line, '\v^\s*describe') >= 0
  "   return this_indent+1
  " elseif match(this_line, '\v^\s*context') >= 0
  "   return this_indent+1
  " elseif match(this_line, '\v^\s*it') >= 0
  "   return this_indent+1
  " elseif match(this_line, '\v^\s*before') >= 0
  "   return this_indent+1
  " elseif match(this_line, '\v^\s*end') >= 0
  "   return this_indent
  " else
  "   return "="
  " endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=RSpecFolds(v:lnum)

function! RSpecFoldText()
  let foldsize = (v:foldend-v:foldstart)
  return getline(v:foldstart).' ('.foldsize.' lines)'
endfunction
setlocal foldtext=RSpecFoldText()
