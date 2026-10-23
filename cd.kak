define-command change-directory-current-buffer -docstring 'cd to current buffer dir' %{
  evaluate-commands %sh{
    printf %s\\n "cd '${kak_buffile%/*}'"
  }
}

define-command change-directory-project-root -docstring 'cd to project root dir' %{
  evaluate-commands %sh{
    buf_dir="${kak_buffile%/*}"
    if git -C "$buf_dir" rev-parse HEAD >/dev/null 2>&1; then
      project_root="$(git -C "$buf_dir" rev-parse --show-toplevel)"
    else
      project_root="$kak_client_env_PWD"
    fi
    printf %s\\n "cd '$project_root'; print-working-directory"
  }
}

define-command print-working-directory -docstring 'print working directory' %{
  evaluate-commands %sh{
    printf %s\\n "echo -markup {InlineInformation}$PWD"
  }
}

define-command -override edit-current-buffer-directory -docstring 'edit in current buffer dir' %{
  evaluate-commands %sh{
    buf_dir="${kak_buffile%/*}"
    if [ "$buf_dir" = "$PWD" ]; then
      printf %s\\n \
      "prompt -file-completion open: %{edit -existing %val{text}}"
    else
      printf %s\\n "cd '$buf_dir'" \
      "prompt -file-completion -on-abort %{cd '$PWD'} open: %{edit -existing %val{text}; cd '$PWD'}"
    fi
  }
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
