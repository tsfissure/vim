echo off
if not exist indent md indent
copy D:\EditMachine\Vim\vim80\indent\cpp.vim .\indent\cpp.vim
copy D:\EditMachine\Vim\vim80\indent\c.vim .\indent\c.vim
copy D:\EditMachine\Vim\vim80\indent\python.vim .\indent\python.vim
copy D:\EditMachine\Vim\_vimrc _vimrc

pause

