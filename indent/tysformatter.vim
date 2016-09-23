if exists("s:did_format")
    finish
endif
let s:did_format = 1

let s:leftSpace = ['{']
let s:rightSpace = ['}', ',', ';']
let s:space = ['^', '|', '='] "TODO +,-,>,<,&
let s:space2 = ['+=', '-=', '*=', '/=', '^=', '|=', '&&', '||', '==', '>>', '<<', '!=', '>=', '<=', '&=']

function IsSpace(char)
    return a:char == ' ' || a:char == "\t"
endfunction

function PreSpace(text)
    let s:rlt = ""
    for i in range(len(a:text))
        if IsSpace(a:text[i])
            let s:rlt = s:rlt.a:text[i]
        else
            break
        endif
    endfor
    return s:rlt
endfunction

function DeleteUnusedSpace(lineIdx)
    let s:upd = 0
    let s:text = getline(a:lineIdx)
    let s:newText = PreSpace(s:text)
    for i in range(len(s:newText), len(s:text))
        if IsSpace(s:text[i]) && IsSpace(s:text[i - 1])
            let s:upd = 1
            continue
        endif
        let s:newText = s:newText.s:text[i]
    endfor
    if s:upd
        call setline(a:lineIdx, s:newText)
    endif
endfunction

function AddLeftSpace(lineIdx)
    let s:upd = 0
    let s:text = getline(a:lineIdx)
    let s:newText = PreSpace(s:text)
    for i in range(len(s:newText), len(s:text))
        if count(s:leftSpace, s:text[i]) > 0 && count(s:leftSpace, s:text[i + 1]) < 1 && !IsSpace(s:text[i - 1])
            let s:upd = 1
            let s:newText = s:newText.' '
        endif
        let s:newText = s:newText.s:text[i]
    endfor
    if s:upd
        call setline(a:lineIdx, s:newText)
    endif
endfunction

function AddRightSpace(lineIdx)
    let s:upd = 0
    let s:text = getline(a:lineIdx)
    let s:newText = PreSpace(s:text)
    for i in range(len(s:newText), len(s:text))
        let s:newText = s:newText.s:text[i]
        if count(s:rightSpace, s:text[i]) > 0 && count(s:rightSpace, s:text[i + 1]) < 1 && !IsSpace(s:text[i + 1]) && s:text[i + 1] != ')'
            if i == len(s:text) - 1 "ignore the last char
                continue
            endif
            let s:upd = 1
            let s:newText = s:newText.' '
        endif
    endfor
    if s:upd
        call setline(a:lineIdx, s:newText)
    endif
endfunction

function IsDigit(char)
    return a:char >= '0' && a:char <= '9'
endfunction

function IsGetAddress(text, idx)
    if text[idx] != '&'
        return 0
    endif
endfunction

function AddSpace(lineIdx)
    let s:upd = 0
    let s:text = getline(a:lineIdx)
    let s:newText = PreSpace(s:text)
    for i in range(len(s:newText), len(s:text))
        let s:add = 0
        if count(s:space, s:text[i]) > 0 && count(s:space, s:text[i - 1]) < 1 && count(s:space, s:text[i + 1]) < 1 && (IsSpace(s:text[i - 1]) || count(s:space2, s:text[i - 1].s:text[i]) < 1) && (IsSpace(s:text[i + 1]) || count(s:space2, s:text[i].s:text[i + 1]) < 1)
            let s:add = 1
        endif
        if s:add && !IsSpace(s:text[i - 1])
            let s:upd = 1
            let s:newText = s:newText." "
        endif
        let s:newText = s:newText.s:text[i]
        if s:add && !IsSpace(s:text[i + 1])
            let s:upd = 1
            let s:newText = s:newText." "
        endif
    endfor
    if s:upd
        call setline(a:lineIdx, s:newText)
    endif
endfunction

function AddTwoSpace(lineIdx)
    let s:upd = 0
    let s:text = getline(a:lineIdx)
    let s:newText = PreSpace(s:text)
    for i in range(len(s:newText), len(s:text))
        let s:add = 0
        if count(s:space2, s:text[i - 1].s:text[i]) > 0
            let s:add = 1
        endif
        if s:add && !IsSpace(s:text[i - 2])
            let s:upd = 1
            let s:newText = strpart(s:newText, 0, len(s:newText) - 1)." ".s:text[i - 1]
        endif
        let s:newText = s:newText.s:text[i]
        if s:add && !IsSpace(s:text[i + 1])
            let s:upd = 1
            let s:newText = s:newText." "
        endif
    endfor
    if s:upd
        call setline(a:lineIdx, s:newText)
    endif
endfunction

function TryFormatCpp()
    for i in range(line('$'))
        call DeleteUnusedSpace(i + 1)
        call AddLeftSpace(i + 1)
        call AddRightSpace(i + 1)
        call AddSpace(i + 1)
        call AddTwoSpace(i + 1)
    endfor
    echo "Format Over"
endfunction

nnoremap <silent><F2>  :call TryFormatCpp()<CR>
