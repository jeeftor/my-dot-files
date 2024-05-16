CERT_FILE := $(PWD)/nix.crt
WORK_CERT_FILE := $(PWD)/WORK-chain.crt



# ---- Nix OS Stuff -------
rebuild-os:
	sudo nixos-rebuild switch --flake .#imac


# -- Home Manager Section ---

rebuild-home:
	home-manager switch -b backup --flake ".#jstein@linux-64"


# Install a manual home manager install - useful on random linux systems
home-manager-standalone:
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	cp ~/.config/home-manager/home.nix .
	

home-manager-work:
	# Install Home manager on a WORK build
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager; nix-channel --update
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; nix-shell '<home-manager>' -A install
	cp ~/.config/home-manager/home.nix .
	home-manager switch --flake ".#jstein"


# ---- Work Stuff ---

work-certs:
	./getWorkCerts.sh
	@echo "# certificates.nix" > certificates.nix
	@echo "[ ''" >> certificates.nix
	@cat $(WORK_CERT_FILE) >> certificates.nix
	@echo "'' ]" >> certificates.nix
	


# --- OSX / Work Install ---

base-nix:
	@# Curl command to download and execute the Nix installer script from the specified URL.
	@# It uses strict SSL/TLS settings and specifies the certificate file.
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --ssl-cert-file $(CERT_FILE) --no-confirm
	sudo cp /etc/nix/nix.conf /etc/nix/nix_1.conf

	@# Build and possibly install the nix-darwin uninstaller from a GitHub repository.
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller

base-darwin:
	@git add certificates.nix	
	sudo mv /etc/nix/nix.conf /etc/nix/nix_init.conf || true
	sudo mv /etc/zshrc /etc/zshrc_init || true
	sudo mv /etc/bashrc /etc/bashrc_init || true
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; CURL_CA_BUNDLE=$(CERT_FILE) NIX_SSL_CERT_FILE=$(CERT_FILE) NIX_BUILD_USERS_GROUP=nixbld nix --experimental-features 'nix-command flakes repl-flake' run nix-darwin -- switch --flake .#work-mac

	@git restore --staged certificates.nix
uninstall-darwin:
	nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller

check-darwin:
	@git add certificates.nix	
	darwin-rebuild check --show-trace --flake .#work-mac 
	@git restore --staged certificates.nix

update-darwin:
	@git add certificates.nix	
	darwin-rebuild switch --show-trace --flake .#work-mac 
	@git restore --staged certificates.nix
	




# --- Lots of stuff i dont htink i use down there ---

# --- Nada --

update:
	nix flake update

check:
	nix flake check



work-mac: work-mac-nix work-mac-darwin
work-mac-nix: work-certs nix-install

work-mac-darwin:
	@# Build and possibly install the nix-darwin uninstaller from a GitHub repository.
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller


	@# Dangerously removing system-level shell configuration files, this can affect system behavior.
	@# Should be handled with care or further conditions/checks should be added.
	sudo rm -rf /etc/zshrc /etc/bashrc || true
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak || true

	@# Have to add this to git or it wont be read by nix
	@git add certificates.nix	
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; CURL_CA_BUNDLE=$(CERT_FILE) NIX_SSL_CERT_FILE=$(CERT_FILE) NIX_BUILD_USERS_GROUP=nixbld nix --experimental-features 'nix-command flakes repl-flake' run nix-darwin -- switch --flake .#work-mac

	@git restore --staged certificates.nix
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; nix run nix-darwin -- switch --flake .#work-mac

	

work-darwin:
	@# Build and possibly install the nix-darwin uninstaller from a GitHub repository.
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller


	# sudo rm -rf /etc/zshrc /etc/bashrc || true
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak || true
	CURL_CA_BUNDLE=$(CERT_FILE) NIX_SSL_CERT_FILE=$(CERT_FILE) NIX_BUILD_USERS_GROUP=nixbld nix --experimental-features 'nix-command flakes repl-flake' run nix-darwin -- switch --flake .#work-mac -v

nix-install:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
	@# Build and possibly install the nix-darwin uninstaller from a GitHub repository.


work-nix-install-user:
	cargo install nix-user-chroot
	mkdir -m 0755 ~/.nix
	nix-user-chroot ~/.nix bash -c "curl -L https://nixos.org/nix/install | bash"

work-nix-install-root:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --ssl-cert-file $(CERT_FILE) --no-confirm
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; CURL_CA_BUNDLE=$(CERT_FILE) NIX_SSL_CERT_FILE=$(CERT_FILE) NIX_BUILD_USERS_GROUP=nixbld  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller -v

work-linux: certs

format:
	nix shell nixpkgs#nixpkgs-fmt -c  find . -name '*.nix' -exec nixpkgs-fmt {} \;


encrypt:
	nix-shell -p sops --run "sops --encrypt --pgp D72C24C14255D974AAB88517E9105C06E1131017 ./user/secrets/secrets.txt > secrets.yaml"
decrypt:
	nix-shell -p sops --run "sops --decrypt secrets.yaml > ./user/secrets/secrets.txt"


uninstall-base:
uninstall-darwin:


repl:
	nix flake show         
	nix repl --expr "builtins.getFlake \"$$PWD\""