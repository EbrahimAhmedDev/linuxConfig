# linuxConfig

My Linux dotfiles & configuration — zsh, Oh My Zsh, starship prompt, custom zsh plugins, and Hyprland desktop setup.

## Structure

```
├── starship.toml      → Starship prompt config (→ ~/.config/starship.toml)
├── zsh/
│   ├── .zshrc         → Zsh config (→ ~/.zshrc)
│   └── plugins/       → Custom zsh plugins (→ ~/.config/zsh/plugins/)
│       ├── open.plugin.zsh
│       └── yazi.plugin.zsh
└── hyprland/
    ├── hypr/          → Hyprland config in Lua (→ ~/.config/hypr/)
    ├── waybar/        → Waybar config, style & custom modules (→ ~/.config/waybar/)
    └── rofi/          → Rofi config & themes (→ ~/.config/rofi/)
```

## Install

```bash
git clone https://github.com/EbrahimAhmedDev/linuxConfig.git
mkdir -p ~/.config/zsh/plugins
cp linuxConfig/zsh/.zshrc ~/.zshrc
cp linuxConfig/starship.toml ~/.config/starship.toml
cp linuxConfig/zsh/plugins/*.plugin.zsh ~/.config/zsh/plugins/

# Hyprland setup
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/rofi
cp linuxConfig/hyprland/hypr/* ~/.config/hypr/
cp -r linuxConfig/hyprland/waybar/* ~/.config/waybar/
cp -r linuxConfig/hyprland/rofi/* ~/.config/rofi/
```

## Requirements

### Shell
- [zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) (with `zsh-autosuggestions`, `zsh-syntax-highlighting`)
- [Starship](https://starship.rs/)
- [eza](https://github.com/eza-community/eza) — modern `ls` replacement
- [fzf](https://github.com/junegunn/fzf)

### Hyprland desktop
- [Hyprland](https://hyprland.org/) (with the [hyprland.lua](https://github.com/hyprwm/hyprland-plugins) Lua config plugin)
- [Waybar](https://github.com/Alexays/Waybar) + `playerctl` / `playerctld` for the media modules
- [Rofi](https://github.com/davatorium/rofi) (wayland)
- [Mako](https://github.com/emersion/mako) — notifications
- Kitty, Nemo, Chromium (terminal, file manager & browser used in the keybinds)
- [Bibata-Modern-Ice](https://github.com/ful1e5/Bibata_Cursor) cursor theme
