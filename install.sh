curl -L https://nixos.org/nix/install | sh
mkdir -p ~/.config
ln -s `pwd` ~/.config/nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Make more configs as appropriate. Remember to reopen the shell
home-manager -f ~/nix-home/hoss.nix switch