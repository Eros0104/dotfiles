# Set powershell encoding to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Loads oh my posh theme
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/Eros0104/dotfiles/main/oh-my-posh/eros.omp.json' | Invoke-Expression

