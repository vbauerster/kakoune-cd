declare-option -hidden str oldpwd

define-command change-directory-current-buffer -docstring 'cd to current buffer dir' %{
  evaluate-commands %sh{
    printf "set global oldpwd '%s'; cd '%s'\n" "$PWD" "${kak_buffile%/*}"
  }
}

define-command change-directory-project-root -docstring 'cd to project root dir' %{
  evaluate-commands %sh{
    project_root=$(git -C "${kak_buffile%/*}" rev-parse --show-toplevel)
    printf "cd '%s'; print-working-directory\n" "$project_root"
  }
}

define-command print-working-directory -docstring 'print working directory' %{
  evaluate-commands %sh{
    printf "echo -markup {Information}$PWD\n"
  }
}

define-command edit-current-buffer-directory -docstring 'edit in current buffer dir' %{
  change-directory-current-buffer
  prompt -file-completion -on-abort 'cd "%opt{oldpwd}"' open: 'edit -existing "%val{text}"; cd "%opt{oldpwd}"'
}

declare-user-mode cd
map global cd b ':change-directory-current-buffer<ret>' -docstring 'current buffer dir'
map global cd c ':cd %val{config}; print-working-directory<ret>' -docstring 'config dir'
map global cd e ':edit-current-buffer-directory<ret>' -docstring 'edit in current buffer dir'
map global cd h ':cd; print-working-directory<ret>' -docstring 'home dir'
map global cd p ':cd ..; print-working-directory<ret>' -docstring 'parent dir'
map global cd r ':change-directory-project-root<ret>' -docstring 'project root dir'

# Suggested aliases

#alias global cdb change-directory-current-buffer
#alias global cdr change-directory-project-root
#alias global ecd edit-current-buffer-directory
#alias global pwd print-working-directory
