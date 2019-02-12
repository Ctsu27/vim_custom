syn match CustomTypes /\<t_[a-z0-9_]\+\>/
syn match CustomTypes /\<s_[a-z0-9_]\+\>/

syn match cCustomConstant /\<SDL_[A-Z0-9_]\+\>/
syn match cCustomConstant /\<SDLK_[a-zA-Z0-9]\+\>/

syn match cCustomConstant /\<MLX_[A-Z0-9_]\+\>/


hi def link CustomTypes Type
hi def link cCustomConstant Constant
