# Cargo environment
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Zscaler AI Protect hook if present
_zsx_apphook_boot="/Library/Application Support/ZscalerAIProtect/apphook/zsx_apphook_bootstrap.js"
if [ -f "$_zsx_apphook_boot" ]; then
  case ":${NODE_OPTIONS:-}:" in
    *"--require \"$_zsx_apphook_boot\""*) ;;
    *) NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--require \"$_zsx_apphook_boot\""; export NODE_OPTIONS ;;
  esac
fi
unset _zsx_apphook_boot

# Load local / private zshenv if present
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
