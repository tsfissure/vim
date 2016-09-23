
if exists("b:did_setting")
    finish
endif
let b:did_setting = 1

set tabstop=2
set shiftwidth=2
set noexpandtab
set tags+=$VIMRUNTIME/../../../BoostArchive/boost_1_61_0/boost/asio/tags