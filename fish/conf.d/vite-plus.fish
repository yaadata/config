# Vite+ bin (https://viteplus.dev)
while set -l __vp_idx (builtin contains -i -- "$HOME/.local/share/vite-plus/bin" $PATH)
    set -e PATH[$__vp_idx]
end
while set -l __vp_idx (builtin contains -i -- "$HOME/.local/share/vite-plus/fallback-bin" $PATH)
    set -e PATH[$__vp_idx]
end
set -gx PATH "$HOME/.local/share/vite-plus/bin" $PATH "$HOME/.local/share/vite-plus/fallback-bin"
