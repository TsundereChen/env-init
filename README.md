# env-init
Repo to initialize my work environment by Ansible Playbook.

The Neovim configuration uses lazy.nvim and the `main` branch of nvim-treesitter.
It requires Neovim 0.12.0+ and tree-sitter CLI 0.26.1+. The playbook checks both
versions before copying the configuration; if your distribution packages are
older, install newer versions first.

The package task also installs ripgrep for Telescope search, Node.js/npm for
Mason's language servers, and GCC, curl, tar and unzip for plugin/parser and
language-server installation. Package names must be available in the target
machine's package repositories.

On first launch, lazy.nvim downloads plugins, Mason installs the configured
language servers, and Treesitter installs parsers. This requires internet access;
parser installation is asynchronous, so reopen a file after installation finishes
to enable its Treesitter highlighting and indentation.
