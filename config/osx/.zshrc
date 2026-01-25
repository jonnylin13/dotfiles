source ~/.bash_profile

function load_sqrx_helper() {
  if [ -f ~/.sqrx_helper ]; then
    source ~/.sqrx_helper
    echo "Started sqrx alias helper ✅"
  else
    echo "Could not find sqrx helper 🚫"
  fi
}

alias lsh=load_sqrx_helper

