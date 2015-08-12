alias ll='ls -l'

# for python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# for Golang
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# api env
export API_CONFDIR=~/repos/api/conf
