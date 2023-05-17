#!/bin/bash
# https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0

fonts_dir="${HOME}/.local/share/fonts"
if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

#nerd_ver='3.0.0'
#declare -a nerd_fonts=(
#    #BitstreamVeraSansMono
#    CascadiaCode
#    CodeNewRoman
#    # DejavuSansMono
#    DroidSansMono
#    FiraCode
#    FiraMono
#    IBMPlexMono
#    Inconsalata
#    Iosevka
#    IosevkaTerm
#    JetBrainsMono
#    LiberationMono
#    Meslo
#    Monoid
#    Mononoki
#    # NerdFontsSymbolsOnly
#    Noto
#    RobotoMono
#    SourceCodePro
#    SpaceMono
#    Terminus
#    Ubuntu
#    UbuntuMono
#)
#for font in "${nerd_fonts[@]}"; do
#    zip_file="${font}.zip"
#    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${nerd_ver}/${zip_file}"
#    echo "Downloading $download_url"
#    wget "$download_url"
#    unzip -uo "$zip_file" -d "$fonts_dir"
#    rm "$zip_file"
#done
#find "$fonts_dir" -name '*Windows Compatible*' -delete

sarasa_ver='0.40.7-0'
declare -a sarasa_fonts=(
    # sarasa-gothic-sc-nerd-font
    # sarasa-ui-sc-nerd-font
    # sarasa-mono-sc-nerd-font
    # sarasa-mono-slab-sc-nerd-font
    sarasa-term-sc-nerd-font
    # sarasa-term-slab-sc-nerd-font
    # sarasa-fixed-sc-nerd-font
    # sarasa-fixed-slab-sc-nerd-font
)
for font in "${sarasa_fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts/releases/download/v${sarasa_ver}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip -uo "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

fc-cache -fv # need fontconfig
