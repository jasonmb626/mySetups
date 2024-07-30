#Keyboard shortcuts
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 1" "Meta+U,Ctrl+F1,Switch to Desktop 1"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 2" "Meta+I,Ctrl+F2,Switch to Desktop 2"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 3" "Meta+O,Ctrl+F3,Switch to Desktop 3"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 4" "Meta+Alt+U,Ctrl+F4,Switch to Desktop 4"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 5" "Meta+Alt+I,,Switch to Desktop 5"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Switch to Desktop 6" "Meta+Alt+O,,Switch to Desktop 6"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 1" "Meta+Shift+U,,Window to Desktop 1"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 2" "Meta+Shift+I,,Window to Desktop 2"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 3" "Meta+Shift+O,,Window to Desktop 3"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 4" "Meta+Alt+Shift+U,,Window to Desktop 4"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 5" "Meta+Alt+Shift+I,,Window to Desktop 5"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window to Desktop 6" "Meta+Alt+Shift+O,,Window to Desktop 6"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window Maximize" "Meta+Up,Meta+PgUp,Maximize Window"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window Minimize" "Meta+Down,Meta+PgDown,Minimize Window"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window Quick Tile Bottom" "Meta+PgDown,Meta+Down,Quick Tile Window to the Bottom"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window Quick Tile Top" "Meta+PgUp,Meta+Up,Quick Tile Winndow to the Top"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="kwin" --key="Window Fullscreen" "Meta+F,,Make Window Fullscreen"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="services" --group="org.kde.krunner.desktop" --key="_launch" "Meta+Space"
kwriteconfig6 --file=$HOME/.config/kglobalshortcutsrc --group="services" --group="Alacrittydesktop" --key="_launch" "Meta+Return"

kwriteconfig6 --file=$HOME/.config/kwinrc --group="Effect-overview" --key="BorderActivate" 9 #Remove hot corner

#Virtual Desktops
#kwriteconfig6 --file=$HOME/.config/.kwinrc --group="Desktops" --key="Id_1" "8f4d53c1-323f-4369-97c8-afb0774f2bf3"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Id_2" "aa97e102-6221-4ea3-a8ae-c4663bd83f65"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Id_3" "e8053d89-9d38-4f04-8487-c3c8b10be96c"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Id_4" "219eb681-3ddb-4ea1-bf75-0fc52ac6c2e2"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Id_5" "d941d48b-3910-45a5-a9ea-3b369de81620"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Id_6" "0b6a8f7d-6d30-4728-8184-a67624cc0afb"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Number" 6
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Desktops" --key="Rows" 2
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Plugins" --key="diminactiveEnabled" true
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Plugins" --key="slidebackEnabled" true
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Plugins" --key="cubeEnabled" true
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Plugins" --key="wobblywindowsEnabled" true
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Plugins" --key="magiclampEnabled" true

kwriteconfig6 --file=$HOME/.config/kwinrc --group="Effect-wobblywindows" --key="WobblynessLevel" 3
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Effect-wobblywindows" --key="Stiffness" 3
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Effect-wobblywindows" --key="MoveFactor" 20
kwriteconfig6 --file=$HOME/.config/kwinrc --group="Effect-wobblywindows" --key="Drag" 92

kwriteconfig6 --file=$HOME/.config/kwinrc --group="org.kde.kdecoration2" --key="ButtonsOnLeft" "XIAM"
kwriteconfig6 --file=$HOME/.config/kwinrc --group="org.kde.kdecoration2" --key="ButtonsOnRight" "H"

qdbus org.kde.KWin /KWin reconfigure
