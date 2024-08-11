#include <X11/XF86keysym.h>

static int showsystray                    = 1;         /* 是否显示托盘栏 */
static const int user_bh                  = 0;         /* 0 表示自动计算高度，非零表示指定高度 */
static const int newclientathead          = 0;         /* 定义新窗口在栈顶还是栈底 */
static const int managetransientwin       = 1;         /* 是否管理临时窗口 */
static const unsigned int borderpx        = 2;         /* 窗口边框大小 */
static const unsigned int systraypinning  = 0;         /* 托盘跟随的显示器 0代表不指定显示器,  */
static const unsigned int systrayspacing  = 2;         /* 托盘间距 */
static const unsigned int systrayspadding = 0;         /* 托盘和状态栏的间隙 */
static int gappi                          = 8;         /* 窗口与窗口 缝隙大小 */
static int gappo                          = 8;         /* 窗口与边缘 缝隙大小 */
static const int _gappo                   = 8;         /* 窗口与窗口 缝隙大小 不可变 用于恢复时的默认值 */
static const int _gappi                   = 8;         /* 窗口与边缘 缝隙大小 不可变 用于恢复时的默认值 */
static const int vertpad                  = 0;         /* vertical padding of bar */
static const int sidepad                  = 0;         /* horizontal padding of bar */
static const int overviewgappi            = 24;        /* overview时 窗口与边缘 缝隙大小 */
static const int overviewgappo            = 60;        /* overview时 窗口与窗口 缝隙大小 */
static const int showbar                  = 1;         /* 是否显示状态栏 */
static const int topbar                   = 1;         /* 指定状态栏位置 0底部 1顶部 */
static const float mfact                  = 0.6;       /* 主工作区 大小比例 */
static const int   nmaster                = 1;         /* 主工作区 窗口数量 */
static const int focusonwheel             = 0;
static const unsigned int snap            = 24;        /* 边缘依附宽度 */
static const unsigned int baralpha        = 0xc0;      /* 状态栏透明度 */
static const unsigned int borderalpha     = 0xdd;      /* 边框透明度 */

static const char *fonts[] = { "JetBrainsMono NF:style=Medium:size=13", 
                                             "MiSans:size=12" };

static const char *colors[][3] = {          /* 颜色设置 ColFg, ColBg, ColBorder */ 
    [SchemeNorm]      = { "#bbbbbb", "#333333", "#444444" },
    [SchemeSel]       = { "#ffffff", "#37474F", "#42A5F5" },
    [SchemeSelGlobal] = { "#ffffff", "#37474F", "#FF3B5D" },
    [SchemeHid]       = { "#dddddd", "#222222", "#42A5F5" },
    [SchemeSystray]   = { "#16213E", "#16213E", "#16213E" },
    [SchemeUnderline] = { "#42A5F5", "#42A5F5", "#42A5F5" },
    [SchemeNormTag]   = { "#bbbbbb", "#333333", NULL },
    [SchemeSelTag]    = { "#eeeeee", "#333333", NULL },
    [SchemeBarEmpty]  = { NULL, "#111111", NULL },
};

static const unsigned int alphas[][3] = {          /* 透明度设置 ColFg, ColBg, ColBorder */ 
    [SchemeNorm]       = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]        = { OPAQUE, baralpha, borderalpha },
    [SchemeSelGlobal]  = { OPAQUE, baralpha, borderalpha },
    [SchemeNormTag]    = { OPAQUE, baralpha, borderalpha },
    [SchemeSelTag]     = { OPAQUE, baralpha, borderalpha },
    [SchemeBarEmpty]   = { 0, 0x11, 0 },
    [SchemeStatusText] = { OPAQUE, 0x88, 0 },
};

/* 自启动脚本位置 */
static const char *autostartscript = "~/.config/dwm/scripts/autostart.sh";

/* 自定义tag名称 */
static const char *tags[] = { "","󰎧","","󰝇","󰇩","","","󰖳","","","󰘑","󰘅"};

/* 自定义窗口显示规则 */
/* class instance title 主要用于定位窗口适合哪个规则, 全部匹配则生效, 匹配采用的是子字符串形式匹配*/
/* tags mask 定义符合该规则的窗口的tag 0 表示当前tag */
/* isfloating 定义符合该规则的窗口是否浮动 */
/* isglobal 定义符合该规则的窗口是否全局浮动 */
/* isnoborder 定义符合该规则的窗口是否无边框 */
/* monitor 定义符合该规则的窗口显示在哪个显示器上 -1 为当前屏幕 */
/* floatposition 定义符合该规则的窗口显示的位置 0 中间，1到9分别为9宫格位置，例如1左上，9右下，3右上 */
/** 越在上面优先度越高 */

static const Rule rules[] = {
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"mpv",                    NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"PeaZip",                 NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"Snipaste",               NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"Nm-applet",              NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"Nm-connection-editor",   NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"Parcellite",             NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"Lxappearance",           NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"Blueman",                NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"fcitx5-config-qt",       NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"org.gnome.Nautilus",     NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"feh",                   "feh",                 NULL,          0,          1,        0,        0,        -1,        0 },
    {"qt5ct",                 "qt5ct",               NULL,          0,          1,        0,        0,        -1,        0 },
    {"uTools",                "utools",              NULL,          0,          1,        0,        0,        -1,        0 },
    {"gdm-settings",          "gdm-settings",        NULL,          0,          1,        0,        0,        -1,        0 },
    {"qqmusic",               "qqmusic",            "歌词",         0,          1,        1,        1,        -1,        0 },
    {"Plank",                 "plank",               NULL,          0,          1,        1,        1,        -1,        0 },
    {"ksmoothdock",           "ksmoothdock",         NULL,          0,          1,        1,        1,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"Safeeyes",              "safeeyes",           "插件设置",     0,          1,        0,        0,        -1,        0 },
    {"Safeeyes",              "safeeyes",           "Safe Eyes",    0,          1,        0,        0,        -1,        0 },
    {"Safeeyes",               NULL,                 NULL,          0,          1,        0,        1,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"floatkitty",            "floatkitty",          NULL,          0,          1,        0,        0,        -1,        0 },
    {"kitty",                 "kitty",               NULL,          0,          0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"obsidian",              "obsidian",            NULL,          1 << 3,     0,        0,        0,        -1,        0 },
    {"Microsoft-edge-dev",    "microsoft-edge-dev",  NULL,          1 << 4,     0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"jetbrains-idea",        "jetbrains-idea",      NULL,          1 << 5,     0,        0,        0,        -1,        0 },
    {"jetbrains-webstorm",    "jetbrains-webstorm",  NULL,          1 << 6,     0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"Code",                  "code",                NULL,          1 << 6,     0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"Vmware-netcfg",         "vmware-netcfg",       NULL,          1 << 7,     0,        0,        0,        -1,        0 },
    {"Vmware",                "vmware",              NULL,          1 << 7,     0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"baidunetdisk",           NULL,                 NULL,          1 << 9,     0,        0,        0,        -1,        0 },
    {"qqmusic",               "qqmusic",             NULL,          1 << 9,     0,        0,        0,        -1,        0 },
    {"listen1",               "listen1",            "Listen1",      0,          1,        1,        1,        -1,        8 },
    {"listen1",               "listen1",             NULL,          1 << 9,     0,        0,        0,        -1,        0 },
    {"Steam",                  NULL,                 NULL,          1 << 9,     1,        0,        1,        -1,        0 },
    {"obs",                   "obs",                "OBS",          1 << 9,     1,        0,        0,        -1,        0 },
    {"Vmplayer",              "vmplayer",            NULL,          1 << 9,     0,        0,        0,        -1,        0 },
    {"wemeetapp",              NULL,                 NULL,          1 << 9,     1,        0,        1,        -1,        0 },
    {"ToDesk",                 NULL,                 NULL,          1 << 9,     1,        0,        1,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"wechat",                "wechat",             "微信",         1 << 10,    0,        0,        1,        -1,        0 },
    {NULL,                     NULL,                "微信",         1 << 10,    1,        0,        0,        -1,        0 },
    {"wechat",                "wechat",              NULL,          1 << 10,    1,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"QQ",                    "qq",                 "QQ",           1 << 11,    0,        0,        0,        -1,        0 },
    {"QQ",                    "qq",                  NULL,          1 << 11,    1,        0,        0,        -1,        0 },
    { NULL,                   "tim.exe",             NULL,          1 << 11,    0,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {"wps",                   "wps",                "WPS文字",      1 << 8,     0,        0,        0,        -1,        0 },
    {"wps",                    NULL,                 NULL,          1 << 8,     1,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    // 所有带settings的窗口都应该放在这条规则之上                            
    {"et",                    "et",                 "WPS 表格",     1 << 8,     0,        0,        0,        -1,        0 },
    {"et",                     NULL,                 NULL,          1 << 8,     1,        0,        0,        -1,        0 },
    {"wpp",                   "wpp",                "WPS 演示",     1 << 8,     0,        0,        0,        -1,        0 },
    {"wpp",                    NULL,                 NULL,          1 << 8,     1,        0,        0,        -1,        0 },
    {"pdf",                   "wpspdf",             "WPS PDF",      1 << 8,     0,        0,        0,        -1,        0 },
    {"pdf",                   "wpspdf",              NULL,          1 << 8,     1,        0,        0,        -1,        0 },
    {"qing",                  "wpscloudsvr",         NULL,          1 << 8,     1,        0,        0,        -1,        0 },
                                                                             
    /*class                    instance              title      tags mask   isfloating isglobal isnoborder monitor floatposition */
    {NULL,                     NULL,                 NULL,          0,          1,        0,        0,        -1,        0 },
};

static const char *overviewtag = "LookUp";
static const Layout overviewlayout = { "󰕮",  overview };

/* 自定义布局 */
static const Layout layouts[] = {
    { "󰙀",  tile },         /* 主次栈 */
    { "󰕰",  magicgrid },    /* 网格 */
};

#define STATUSBAR "dwmblocks"
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG, cmd) \
    { MODKEY,              KEY, view,       {.ui = 1 << TAG, .v = cmd} }, \
    { MODKEY|ShiftMask,    KEY, tag,        {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,  KEY, toggleview, {.ui = 1 << TAG} }, \

static Key keys[] = {
    /* modifier             key          function          argument */
    { MODKEY,               XK_k,        focusstack,       {.i = -1} },                  /* super k            |  本tag内切换聚焦窗口 */
    { MODKEY,               XK_j,        focusstack,       {.i = +1} },                  /* super j            |  本tag内切换聚焦窗口 */
    { MODKEY,               XK_q,        killclient,       {0} },                        /* super q            |  关闭窗口 */

    { MODKEY,               XK_d,        hidewin,          {0} },                        /* super d            |  切换隐藏 窗口 */
    { MODKEY|ShiftMask,     XK_d,        restorewin,       {0} },                        /* super d            |  切换隐藏 窗口 */

    { MODKEY,               XK_r,        togglefloating,   {0} },                        /* super d            |  开启/关闭 聚焦目标的float模式 */
    { MODKEY|ShiftMask,     XK_r,        toggleallfloating,{0} },                        /* super shift d      |  开启/关闭 全部目标的float模式 */
    { MODKEY,               XK_f,        zoom,             {0} },                        /* super d            |  将当前聚焦窗口置为主窗口 */
	{ MODKEY,               XK_m,        showonlyorall,    {0} },                        /* super m            |  切换 只显示一个窗口 / 全部显示 */
    { MODKEY,               XK_p,        toggleglobal,     {0} },                        /* super p            |  pin 窗口置顶到所有tag */
    { MODKEY,               XK_g,        incnmaster,       {.i = +1} },                  /* super g            |  改变主工作区窗口数量 (1 2中切换) */

    { MODKEY,               XK_comma,    setmfact,         {.f = -0.05} },               /* super ,            |  缩小主工作区 */
    { MODKEY,               XK_period,   setmfact,         {.f = +0.05} },               /* super .            |  放大主工作区 */

    { MODKEY,               XK_h,        viewtoleft,       {0} },                        /* super h            |  聚焦到左边的tag */
    { MODKEY,               XK_l,        viewtoright,      {0} },                        /* super l            |  聚焦到右边的tag */
    { MODKEY|ShiftMask,     XK_h,        tagtoleft,        {0} },                        /* super shift h      |  将本窗口移动到左边tag */
    { MODKEY|ShiftMask,     XK_l,        tagtoright,       {0} },                        /* super shift l      |  将本窗口移动到右边tag */

    { MODKEY,               XK_Tab,      view,             {0} },                        /* super tab          |  回到上一个tag */
    { MODKEY,               XK_a,        toggleoverview,   {0} },                        /* super a            |  显示所有tag 或 跳转到聚焦窗口的tag */
	{ MODKEY,               XK_space,    selectlayout,     {.v = &layouts[1]} },         /* super space        |  切换到网格布局 */

    { MODKEY,               XK_s,        togglesystray,    {0} },                        /* super s            |  切换 托盘栏显示状态 */
    { MODKEY|ShiftMask,     XK_s,        togglebar,        {0} },                        /* super shift s      |  开启/关闭 状态栏 */

    { MODKEY,               XK_n,        focusmon,         {.i = +1} },                  /* super n            |  光标移动到另一个显示器 */
    { MODKEY|ShiftMask,     XK_n,        tagmon,           {.i = +1} },                  /* super shift n      |  将聚焦窗口移动到另一个显示器 */

    { MODKEY,               XK_equal,    setgap,           {.i = -15} },                 /* super =            |  窗口增大 */
    { MODKEY,               XK_minus,    setgap,           {.i = +15} },                 /* super -            |  窗口减小 */
    { MODKEY,               XK_BackSpace,setgap,           {.i = 0} },                   /* super backspace    |  窗口重置 */

    { MODKEY|ControlMask,   XK_k,        resizewin,        {.ui = V_REDUCE} },           /* super ctrl k       |  调整窗口 */
    { MODKEY|ControlMask,   XK_j,        resizewin,        {.ui = V_EXPAND} },           /* super ctrl j       |  调整窗口 */
    { MODKEY|ControlMask,   XK_h,        resizewin,        {.ui = H_REDUCE} },           /* super ctrl h       |  调整窗口 */
    { MODKEY|ControlMask,   XK_l,        resizewin,        {.ui = H_EXPAND} },           /* super ctrl l       |  调整窗口 */

    { MODKEY|Mod1Mask,      XK_k,        movewin,          {.ui = UP} },                 /* super alt k        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_j,        movewin,          {.ui = DOWN} },               /* super alt j        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_h,        movewin,          {.ui = LEFT} },               /* super alt h        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_l,        movewin,          {.ui = RIGHT} },              /* super alt l        |  移动窗口 */

    { MODKEY,               XK_F5,       quit,             {0} },                               /* super f5           |  配合startdwm实现热重载*/
    { MODKEY,               XK_F11,      fullscreen,       {0} },                               /* super f            |  开启/关闭 全屏 */
    { MODKEY,               XK_F12,      spawn,            SHCMD("killall startdwm") },         /* super ctrl f12     |  退出dwm */
    { MODKEY,               XK_F2,       spawn,            SHCMD("betterlockscreen -l dim") },  /* super ctrl f12     |  退出dwm */

    /* spawn + SHCMD 执行对 应命令 */
    { MODKEY|ShiftMask,     XK_q,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh killw") },
    { MODKEY,               XK_x,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh getinfo") },
    { MODKEY,               XK_Return,   spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh terminal current") },
    { MODKEY|ControlMask,   XK_Return,   spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh terminal temp") },
    { MODKEY|ShiftMask,     XK_Return,   view,             {.ui = 1 << 4, .v = "~/.config/dwm/scripts/app-starter.sh terminal ssh"} },

    { MODKEY,               XK_e,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh filemanager") },
    { MODKEY,               XK_v,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh clipboard") },
    { MODKEY,               XK_b,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh changewallpaper") },
    { MODKEY|ShiftMask,     XK_b,        spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh changevideo") },
    { ControlMask|ShiftMask,XK_Escape,   spawn,            SHCMD("~/.config/dwm/scripts/app-starter.sh terminal btop") },

    { 0,                    XF86XK_MonBrightnessUp,        sigstatusbar,    {.i = 4,.ui = 5} }, // i 代表按键，ui 代表对应按钮的信号量
    { 0,                    XF86XK_MonBrightnessDown,      sigstatusbar,    {.i = 5,.ui = 5} },
    { 0,                    XF86XK_AudioRaiseVolume,       sigstatusbar,    {.i = 4,.ui = 6} },
    { 0,                    XF86XK_AudioLowerVolume,       sigstatusbar,    {.i = 5,.ui = 6} },
    { 0,                    XF86XK_AudioMute,              sigstatusbar,    {.i = 1,.ui = 6} },

    /* super key : 跳转到对应tag */
    /* super shift key : 将聚焦窗口移动到对应tag */
    /* 若跳转后的tag无窗口且附加了cmd1或者cmd2就执行对应的cmd */
    /* key tag cmd1 cmd2 */
    TAGKEYS(XK_1, 0,  0)
    TAGKEYS(XK_2, 1,  0)
    TAGKEYS(XK_3, 2,  0)
    TAGKEYS(XK_4, 3,  0)
    TAGKEYS(XK_5, 4,  0)
    TAGKEYS(XK_6, 5,  0)
    TAGKEYS(XK_7, 6,  0)
    TAGKEYS(XK_8, 7,  0)
    TAGKEYS(XK_9, 8,  0)
    TAGKEYS(XK_0, 9,  0)
    TAGKEYS(XK_c , 4  , "~/.config/dwm/scripts/app-starter.sh browser")
    TAGKEYS(XK_o , 3  , "~/.config/dwm/scripts/app-starter.sh obsidian")
    TAGKEYS(XK_w , 10 , "~/.config/dwm/scripts/app-starter.sh wechat")
    TAGKEYS(XK_i , 11 , "~/.config/dwm/scripts/app-starter.sh qq")
};

#define Button6 6
#define Button7 7
#define Button8 8
#define Button9 9

static Button buttons[] = {
    /* click               event mask  button          function       argument  */

    /* 点击窗口标题栏*/
    { ClkWinTitle,         0,          Button1,        togglewin,       {0} },       // 左键       |  点击标题  | 切换窗口显示状态
    { ClkWinTitle,         0,          Button2,        killclient,      {0} },       // 中键       |  点击标题  | 关闭窗口
    { ClkWinTitle,         0,          25,             killclient,      {0} },       // 中键bug    |  点击标题  | 关闭窗口
    { ClkWinTitle,         0,          Button3,        togglefloating,  {0} },  // 右键       |  点击标题  | 切换是否浮动
    { ClkWinTitle,         0,          Button4,        focusstack,      {.i = -1, .ui = 1}},  // 鼠标滚轮上 |  点击标题  | 切换聚焦窗口
    { ClkWinTitle,         0,          Button5,        focusstack,      {.i = +1, .ui = 1}},  // 鼠标滚轮下 |  点击标题  | 切换聚焦窗口
    { ClkWinTitle,         0,          Button9,        viewtoleft,      {0} },       // 鼠标侧键前 |  tag       | 向前切换tag
	{ ClkWinTitle,         0,          Button8,        viewtoright,     {0} },       // 鼠标侧键后 |  tag       | 向后切换tag

    /* 点击窗口操作 */
    { ClkClientWin,        MODKEY,     Button1,        movemouse,       {0} },       // super+左键 |  拖拽窗口  | 拖拽窗口
    { ClkClientWin,        0,          Button2,        togglefloating,  {0} },       // super+左键 |  拖拽窗口  | 拖拽窗口
    { ClkClientWin,        MODKEY,     Button3,        resizemouse,     {0} },       // super+右键 |  拖拽窗口  | 改变窗口大小

    { ClkClientWin,        0,          Button9,        movemouse,       {0} },       // 鼠标侧键前 |  拖拽窗口  | 拖拽窗口    
	{ ClkClientWin,        0,          Button8,        resizemouse,     {0} },       // 鼠标侧键后 |  拖拽窗口  | 改变窗口大小
	//
    { ClkRootWin,          0,          Button9,        viewtoleft,      {0} },       // 鼠标侧键前 |  tag       | 向前切换tag
	{ ClkRootWin,          0,          Button8,        viewtoright,     {0} },       // 鼠标侧键后 |  tag       | 向后切换tag

    /* 点击tag操作 */
    { ClkTagBar,           0,          Button1,        view,            {0} },       // 左键       |  点击tag   | 切换tag
	{ ClkTagBar,           0,          Button3,        toggleview,      {0} },       // 右键       |  点击tag   | 切换是否显示tag
    { ClkTagBar,           ShiftMask,  Button1,        tag,             {0} },       // super+左键 |  点击tag   | 将窗口移动到对应tag
    { ClkTagBar,           0,          Button4,        viewtoleft,      {0} },       // 鼠标滚轮上 |  tag       | 向前切换tag
	{ ClkTagBar,           0,          Button5,        viewtoright,     {0} },       // 鼠标滚轮下 |  tag       | 向后切换tag
    { ClkTagBar,           0,          Button9,        viewtoleft,      {0} },       // 鼠标侧键前 |  tag       | 向前切换tag
	{ ClkTagBar,           0,          Button8,        viewtoright,     {0} },       // 鼠标侧键后 |  tag       | 向后切换tag

    /* 点击状态栏操作 */
	{ ClkStatusText,       0,         Button1,         sigstatusbar,    {.i = 1} },  // 左键       |  状态栏    | 根据blocks发送信号
	{ ClkStatusText,       0,         Button2,         sigstatusbar,    {.i = 2} },  // 中键       |  状态栏    | 根据blocks发送信号
	{ ClkStatusText,       0,         Button3,         sigstatusbar,    {.i = 3} },  // 右键       |  状态栏    | 根据blocks发送信号
	{ ClkStatusText,       0,         Button4,         sigstatusbar,    {.i = 4} },  // 鼠标滚轮上 |  状态栏    | 根据blocks发送信号
	{ ClkStatusText,       0,         Button5,         sigstatusbar,    {.i = 5} },  // 鼠标滚轮下 |  状态栏    | 根据blocks发送信号

    /* 点击bar空白处 */
    { ClkBarEmpty,         0,         Button9,         viewtoleft,      {0} },       // 鼠标侧键前 |  tag       | 向前切换tag
	{ ClkBarEmpty,         0,         Button8,         viewtoright,     {0} },       // 鼠标侧键后 |  tag       | 向后切换tag
};
