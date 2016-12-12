set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            let cmd = '""' . $VIMRUNTIME . '\diff"'
            let eq = '"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'd
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

""定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.python文件
    if &filetype == 'python'
        call setline(1, "\#coding=utf-8")
        call setline(2, "\'\'\'")
        call setline(3, "Created on ".strftime("%c"))
        call setline(4, "")
        call setline(5, "@author: tys")
        call setline(6, "\'\'\'")
        call setline(7, "")
    elseif &filetype == 'cpp' || &filetype == 'c'
        call setline(1, "/****************************************")
        call setline(2, "\ @Author: tsfissure")
        call setline(3, "")
        call setline(4, "\ @Created Time : ".strftime("%c"))
        call setline(5, "")
        call setline(6, " ****************************************/")
        call setline(7, "")
    endif
endfunc


" -------------------- Vundle 起始设置 -------------------- {
set nocompatible                    " 关闭兼容模式，Vundle必须
filetype off                        " 关闭类型检测，Vundle必须

" 设置Vundle的runtime path -- linux版本
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()

" 设置Vundle的runtime path -- win版本
set rtp+=$VIMRUNTIME/../vimfiles/Vundle/Vundle.vim/
call vundle#begin('$VIMRUNTIME/../vimfiles/Vundle/')  

" 让Vundle管理自己
Plugin 'gmarik/Vundle.vim'
" -------------------- Vundle 起始设置 -------------------- }

" -------------------- Vundle 所有插件 -------------------- {
" 用tab触发补全
" Plugin 'ervandew/supertab'
" 自动弹出补全
Plugin 'AutoComplPop'
" 文件浏览
Plugin 'scrooloose/nerdtree'
" 快速注释
Plugin 'scrooloose/nerdcommenter'
" 文件快速定位
Plugin 'kien/ctrlp.vim'
" 彩色状态栏
" Plugin 'Lokaltog/vim-powerline'
" 缩进对齐线
Plugin 'Yggdroot/indentLine'
" tags浏览
Plugin 'taglist.vim'
" -------------------- Vundle 所有插件 -------------------- }

" -------------------- Vundle 结束设置 -------------------- {
call vundle#end()                  
filetype plugin indent on           " 启用插件和缩进, Vundle必须
" -------------------- Vundle 结束设置 -------------------- }

" -------------------- Vundle 命令提示 -------------------- {
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
" -------------------- Vundle 命令提示 -------------------- }

" -------------------- Vim 基本设置 -------------------- {
set number							" 显示行号
" set mouse=a						" 使用鼠标(右键)
" set ruler							" 右下角光标位置
set autoread						" 文件外部修改时自动读取文件
set cindent							" c语言式缩进
set smartindent                     " 智能缩进
set showmatch						" 括号匹配
set hlsearch						" 高亮搜索
" set insearch						" 实时搜索
set ignorecase						" 搜索忽略大小写
set scrolloff=3                     " 光标保持离底边5行
set nobackup						" 不生成备份文件
set noswapfile                      " 不生成swap文件
set noundofile						" 不生成undo文件
"set nowrap                          " 设置不自动换行
set history=50                      " vim最多记住50条历史命令
" set noerrorbells                    " 关闭响铃
set cursorline						" 高亮当前行
set tabstop=4						" tab宽
set shiftwidth=4
set expandtab						" tab转空格
" set whichwrap=b,s,<,>,[,]           " 光标从行首和行末时可以跳到另一行去
set autochdir						" 自动cd到当前目录
set foldmethod=indent				" 折叠方式为缩进折叠
syntax enable						" 语法高亮
syntax on
" 主题
colorscheme delek-tys					" 主题
set guifont=source_code_pro:h12

" 设置编码
set fileencodings=utf-8,gbk,gbk2312,cp936,latin-1	" 打开文件时检测类型
set fileencoding=utf-8								" 保存

au GUIEnter * simalt ~x 			" 打开就最大化窗口
set guioptions-=m					" 关闭菜单栏
set guioptions-=T					" 关闭工具栏


" 打开文件时自动定位到上次位置
" autocmd BufReadPost *
"    \ if line("'\"") > 1 && line("'\"") <= line("$") |
"    \   exe "normal! g`\"" |
"    \ endif

" 默文件头
autocmd BufNewFile *.py,*.c,*.cc,*.cpp silent execute ':call SetTitle()' | normal G
" --------------------  Vim 基本设置   -------------------- }

" --------------------  Vim 键盘映射   -------------------- {

vmap <C-C> "+y  				" 选中状态下 Ctrl+C 复制到系统剪贴板
nmap <silent> <C-V> "+p  		" 从系统剪贴板粘贴 Ctrl+V  
" Ctrl+BackSpace删除单词
inoremap <C-BS> <ESC>dba<BS>
nnoremap <C-BS> dba<BS><ESC>
" 跳到最后
inoremap <silent><C-e> <ESC>A

" 窗口切换
map <C-TAB> <Esc>:tabn<CR>
map <S-TAB> <Esc>:tabp<CR>
map <C-S-h> <Esc><C-W><C-h>
map <C-S-l> <Esc><C-W><C-l>
map <C-S-k> <Esc><C-W><C-k>
map <C-S-j> <Esc><C-W><C-j>
nmap <C-F1> :q<CR>
nmap <F1> :wa <CR>

" 括号补全
inoremap ( ()<ESC>i
inoremap { {}<ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
" --------------------  Vim 键盘映射   -------------------- }

" --------------------  插件具体设置   -------------------- {
" AutoComplPop
let g:acp_behaviorKeywordLength = 3                     " 第3个字符触发补全
let g:acp_ignorecaseOption = 1							" 忽略大小写
let g:acp_completeOption = '.,w,b,u,t,i,k'              " complete的参数

" nerdtree 
nmap <F9> :NERDTreeToggle<CR>
let NERDTreeWinPos = 'left'                             " 窗口位置，or 'right'
let NERDTreeWinSize = 25                                " 窗口宽度
let NERDTreeDirArrows = 1                               " 目录前面显示箭头
let NERDTreeHighlightCursorline = 0                     " 不高亮光标行

" nerdcommenter
map <F7> <leader>cl
map <F8> <leader>cu

" ctrlp
let g:ctrlp_by_filename = 0                             " 只用文件名匹配
let g:ctrlp_regexp = 0                                  " 禁用正则匹配
let g:ctrlp_open_new_file = 'h'                         " 创建新文件时用水平split
let g:ctrlp_open_multiple_files = 'h'                   " 打开多个文件用水平split

" taglist
nmap <F10> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1                          " 窗口位置 
let Tlist_WinWidth = 25                                 " 窗口宽度
" --------------------  插件具体设置   -------------------- }

" --------------------   ctags 设置    -------------------- {
set tags=tags;
""set tags+=$VIMRUNTIME/../../../BoostArchive/boost_1_61_0/boost/asio/tags
""set tags+=D:/BoostArchive/boost_1_61_0/boost/asio/tags
" --------------------   ctags 设置    -------------------- }
