cd ~ && wget https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases

cat >> .bashrc<<EOF
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
# function kubectl() { echo "+ kubectl $@"; command kubectl $@; }
EOF
source .bashrc