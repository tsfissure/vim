if exists("b:did_format")
    finish
endif
let b:did_format = 1

let b:leftSpace = ['{']
let b:rightSpace = ['}', ',', ';']
let b:space = ['^', '|', '='] "TODO +,-,>,<,&
let b:space2 = ['+=', '-=', '*=', '/=', '^=', '|=', '&&', '||', '==', '>>', '<<', '!=', '>=', '<=', '&=']

function IsSpace(char)
    return a:char == ' ' || a:char == "\t"
endfunction

function PreSpace(text)
    let b:rlt = ""
    for i in range(len(a:text))
        if IsSpace(a:text[i])
            let b:rlt = b:rlt.a:text[i]
        else
            break
        endif
    endfor
    return b:rlt
endfunction

function DeleteUnusedSpace(lineIdx)
    let b:upd = 0
    let b:text = getline(a:lineIdx)
    let b:newText = PreSpace(b:text)
    for i in range(len(b:newText), len(b:text))
        if IsSpace(b:text[i]) && IsSpace(b:text[i - 1])
            let b:upd = 1
            continue
        endif
        let b:newText = b:newText.b:text[i]
    endfor
    if b:upd
        call setline(a:lineIdx, b:newText)
    endif
endfunction

function AddLeftSpace(lineIdx)
    let b:upd = 0
    let b:text = getline(a:lineIdx)
    let b:newText = PreSpace(b:text)
    for i in range(len(b:newText), len(b:text))
        if count(b:leftSpace, b:text[i]) > 0 && count(b:leftSpace, b:text[i + 1]) < 1 && !IsSpace(b:text[i - 1])
            let b:upd = 1
            let b:newText = b:newText.' '
        endif
        let b:newText = b:newText.b:text[i]
    endfor
    if b:upd
        call setline(a:lineIdx, b:newText)
    endif
endfunction

function AddRightSpace(lineIdx)
    let b:upd = 0
    let b:text = getline(a:lineIdx)
    let b:newText = PreSpace(b:text)
    for i in range(len(b:newText), len(b:text))
        let b:newText = b:newText.b:text[i]
        if count(b:rightSpace, b:text[i]) > 0 && count(b:rightSpace, b:text[i + 1]) < 1 && !IsSpace(b:text[i + 1]) && b:text[i + 1] != ')'
            if i == len(b:text) - 1 "ignore the last char
                continue
            endif
            let b:upd = 1
            let b:newText = b:newText.' '
        endif
    endfor
    if b:upd
        call setline(a:lineIdx, b:newText)
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
    let b:upd = 0
    let b:text = getline(a:lineIdx)
    let b:newText = PreSpace(b:text)
    for i in range(len(b:newText), len(b:text))
        let b:add = 0
        if count(b:space, b:text[i]) > 0 && count(b:space, b:text[i - 1]) < 1 && count(b:space, b:text[i + 1]) < 1 && (IsSpace(b:text[i - 1]) || count(b:space2, b:text[i - 1].b:text[i]) < 1) && (IsSpace(b:text[i + 1]) || count(b:space2, b:text[i].b:text[i + 1]) < 1)
            let b:add = 1
        endif
        if b:add && !IsSpace(b:text[i - 1])
            let b:upd = 1
            let b:newText = b:newText." "
        endif
        let b:newText = b:newText.b:text[i]
        if b:add && !IsSpace(b:text[i + 1])
            let b:upd = 1
            let b:newText = b:newText." "
        endif
    endfor
    if b:upd
        call setline(a:lineIdx, b:newText)
    endif
endfunction

function AddTwoSpace(lineIdx)
    let b:upd = 0
    let b:text = getline(a:lineIdx)
    let b:newText = PreSpace(b:text)
    for i in range(len(b:newText), len(b:text))
        let b:add = 0
        if count(b:space2, b:text[i - 1].b:text[i]) > 0
            let b:add = 1
        endif
        if b:add && !IsSpace(b:text[i - 2])
            let b:upd = 1
            let b:newText = strpart(b:newText, 0, len(b:newText) - 1)." ".b:text[i - 1]
        endif
        let b:newText = b:newText.b:text[i]
        if b:add && !IsSpace(b:text[i + 1])
            let b:upd = 1
            let b:newText = b:newText." "
        endif
    endfor
    if b:upd
        call setline(a:lineIdx, b:newText)
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
