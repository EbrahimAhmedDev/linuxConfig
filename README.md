# linuxConfig

My Linux dotfiles & configuration — zsh, Oh My Zsh, starship prompt, and custom zsh plugins.

## Structure

```
├── starship.toml      → Starship prompt config (→ ~/.config/starship.toml)
└── zsh/
    ├── .zshrc         → Zsh config (→ ~/.zshrc)
    └── plugins/       → Custom zsh plugins (→ ~/.config/zsh/plugins/)
        ├── open.plugin.zsh
        └── yazi.plugin.zsh
```

## Install

```bash
git clone https://github.com/EbrahimAhmedDev/linuxConfig.git
mkdir -p ~/.config/zsh/plugins
cp linuxConfig/zsh/.zshrc ~/.zshrc
cp linuxConfig/starship.toml ~/.config/starship.toml
cp linuxConfig/zsh/plugins/*.plugin.zsh ~/.config/zsh/plugins/
```

## Requirements

- [zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) (with `zsh-autosuggestions`, `zsh-syntax-highlighting`)
- [Starship](https://starship.rs/)
- [eza](https://github.com/eza-community/eza) — modern `ls` replacement
- [fzf](https://github.com/junegunn/fzf)
