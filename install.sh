#!/bin/bash

printf "\033[32m ======================= Compile dwm ======================= \033[0m\n"
# dwm compile and install
make clean install || exit 1

# for hot reload
echo "#!/bin/bash

while true; do
    # Log stderror to a file
    /usr/local/bin/dwm 2>~/.dwm.log
    # No error logging
    /usr/local/bin/dwm >/dev/null 2>&1
done" | sudo tee /usr/local/bin/startdwm >/dev/null
sudo chmod +x /usr/local/bin/startdwm

# add dwm to xsessions (with hot reload)
echo "[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=Dynamic Window Manager
Exec=/usr/local/bin/startdwm
Icon=dwm
Type=XSession" | sudo tee /usr/share/xsessions/dwm.desktop >/dev/null

# dwmblocks-async compile and install
printf "\033[32m ================= Compile dwmblocks-async ================= \033[0m\n"

cd ./dwmblocks-async/ || exit 1
sudo make clean install || exit 1
