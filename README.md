## Setup

> [!NOTE]
> You may delete `/etc/nixos/` just to keep things tidy

Rebuild the *system*:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

then proceed with *home-manager*:

```sh
home-manager switch --flake .#xir
```

### Git Config

Create a local file with name/email:

```sh
mkdir -p ~/.config/git

cat << 'EOF' > ~/.config/git/config.local
[user]
    name = Your Name
    email = your.email@example.com
EOF
```

## Sources

- Nix Manual: https://nix.dev/manual/nix/2.35/
- NixOS Manual: https://nixos.org/manual/nixos/stable/
- Jovian NixOS: https://nixos.wiki/wiki/Jovian_NixOS
