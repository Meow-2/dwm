#include <X11/XF86keysym.h>

static int showsystray                   = 1;         /* 是否显示托盘栏 */
static const int newclientathead         = 0;         /* 定义新窗口在栈顶还是栈底 */
static const unsigned int borderpx       = 2;         /* 窗口边框大小 */
static const unsigned int systraypinning = 0;         /* 托盘跟随的显示器 0代表不指定显示器 */
static const unsigned int systrayspacing = 2;         /* 托盘间距 */
static int gappi                         = 8;        /* 窗口与窗口 缝隙大小 */
static int gappo                         = 8;        /* 窗口与边缘 缝隙大小 */
static const int _gappo                  = 8;        /* 窗口与窗口 缝隙大小 不可变 用于恢复时的默认值 */
static const int _gappi                  = 8;        /* 窗口与边缘 缝隙大小 不可变 用于恢复时的默认值 */
static const int smartgaps               = 0;        /* 1 means no outer gap when there is only one window */
static const int overviewgappi           = 24;        /* overview时 窗口与边缘 缝隙大小 */
static const int overviewgappo           = 60;        /* overview时 窗口与窗口 缝隙大小 */
static const int showbar                 = 1;         /* 是否显示状态栏 */
static const int topbar                  = 1;         /* 指定状态栏位置 0底部 1顶部 */
static const float mfact                 = 0.6;       /* 主工作区 大小比例 */
static const int   nmaster               = 1;         /* 主工作区 窗口数量 */
static const unsigned int snap           = 32;        /* 边缘依附宽度 */
static const unsigned int baralpha       = 0xc0;      /* 状态栏透明度 */
static const unsigned int borderalpha    = 0xdd;      /* 边框透明度 */
static const char *fonts[]               = { "JetBrainsMono Nerd Font:style=medium:size=13", 
                                             "WenQuanYi Micro Hei Mono Regular:size=12" };
static const char *colors[][3]           = { 
    [SchemeNorm]      = { "#bbbbbb", "#333333", "#444444" },
    [SchemeSel]       = { "#ffffff", "#37474F", "#42A5F5" },
    // [SchemeHid]    = { "#dddddd", NULL, NULL },
    [SchemeHid]       = { "#dddddd", "#222222", "#42A5F5" },
    [SchemeSystray]   = { "#16213E", "#16213E", "#16213E" },
    [SchemeUnderline] = { "#42A5F5", "#42A5F5", "#42A5F5"}
};
static const unsigned int alphas[][3]    = { 
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]  = { OPAQUE, baralpha, borderalpha }
};


/* 自定义tag名称 */
/* 自定义特定实例的显示状态 */
static const char *tags[] = { "", "", "", "", "", "", "ﱅ", "", "", "", "﬐", "ﬄ", "", "", "", ""};

static const Rule rules[] = {
    /* class                 instance              title             tags mask     isfloating   noborder  monitor */
    {"float",                NULL,                 NULL,             0,              1,           0,        -1 },
    {"noborder",             NULL,                 NULL,             0,              1,           1,        -1 },
    {"utools",               NULL,                 NULL,             0,              1,           1,        -1 },
    {"Peek",                 NULL,                 NULL,             0,              1,           1,        -1 },
    {"Mailspring",           NULL,                 NULL,             0,              1,           1,        -1 },
    {"Zotero",               NULL,                 NULL,             0,              1,           1,        -1 },
    {"dolphin",              NULL,                 NULL,             0,              1,           1,        -1 },
    {"Pcmanfm",              NULL,                 NULL,             0,              1,           1,        -1 },
    {"Blueman-manager",      NULL,                 NULL,             0,              1,           1,        -1 },
    {"Nm-applet",            NULL,                 NULL,             0,              1,           1,        -1 },
    {"fcitx5-config-qt",     NULL,                 NULL,             0,              1,           1,        -1 },
    {"Safeeyes",             NULL,                 NULL,             0,              1,           1,        -1 },
    {"Parcellite",           NULL,                 NULL,             0,              1,           1,        -1 },
    {"Alacritty",            NULL,                 "temp",           0,              1,           0,        -1 },
    {"Alacritty",            NULL,                 "ssh",            1 << 1,         0,           0,        -1 },
    {"Code",                 "code",               NULL,             1 << 2,         0,           0,        -1 },
    {"obsidian",             NULL,                 NULL,             1 << 6,         0,           1,        -1 },
    {"wpsoffice",            "wpsoffice",          NULL,             1 << 7,         0,           1,        -1 },
    {"baidunetdisk",         NULL,                 NULL,             1 << 8,         0,           1,        -1 },
    {"transmission",         NULL,                 NULL,             1 << 8,         0,           1,        -1 },
    {"Google-chrome",        NULL,                 NULL,             1 << 9,         0,           1,        -1 },
    { "icalingua",           "icalingua",          "图片查看",       0,              1,           0,        -1 },
    { NULL,                  NULL,                 "图片预览",       0,              1,           0,        -1 },
    { NULL,                  NULL,                 "crx_",           0,              1,           0,        -1 },
    { NULL,                  "wechat.exe",         NULL,             1 << 10,        0,           1,        -1 },
    { NULL,                  "wxwork.exe",         NULL,             1 << 10,        0,           1,        -1 },
    {"icalingua",            NULL,                 NULL,             1 << 11,        0,           1,        -1 },
    { NULL,                  "tim.exe",            NULL,             1 << 11,        0,           1,        -1 },
    {"TelegramDesktop",      NULL,                 NULL,             1 << 12,        0,           1,        -1 },
    {"lx-music-desktop",     NULL,                 NULL,             1 << 13,        0,           1,        -1 },
    {"wemeetapp",            NULL,                 NULL,             1 << 13,        1,           1,        -1 },
    {"Steam",                NULL,                 NULL,             1 << 14,        0,           1,        -1 },
    {"Vmplayer",             "vmplayer",           NULL,             1 << 15,        1,           1,        -1 },
    {"Vmware",               "vmware",             NULL,             1 << 15,        1,           1,        -1 },
};
static const char *overviewtag = "OVERVIEW";
static const Layout overviewlayout = { "",  overview };

/* 自定义布局 */
static const Layout layouts[] = {
    { "﬿",  tile },         /* 主次栈 */
    { "﩯",  magicgrid },    /* 网格 */
};

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG, cmd1, cmd2) \
    { MODKEY,              KEY, view,       {.ui = 1 << TAG, .v = cmd1} }, \
    { MODKEY|ShiftMask,    KEY, tag,        {.ui = 1 << TAG, .v = cmd2} }, \
    { MODKEY|ControlMask,  KEY, toggleview, {.ui = 1 << TAG} }, \

static Key keys[] = {
    /* modifier             key          function          argument */
    { MODKEY,               XK_s,        togglesystray,    {0} },                     /* super s            |  切换 托盘栏显示状态 */
    { MODKEY|ShiftMask,     XK_s,        togglebar,        {0} },                     /* super shift s      |  开启/关闭 状态栏 */

    { MODKEY,               XK_Tab,      view,             {0} },                     /* super tab          |  本tag内切换聚焦窗口 */
    { MODKEY,               XK_k,        focusstack,       {.i = -1} },               /* super k            |  本tag内切换聚焦窗口 */
    { MODKEY,               XK_j,        focusstack,       {.i = +1} },               /* super j            |  本tag内切换聚焦窗口 */

    { MODKEY,               XK_h,        viewtoleft,       {0} },                     /* super h            |  聚焦到左边的tag */
    { MODKEY,               XK_l,        viewtoright,      {0} },                     /* super l            |  聚焦到右边的tag */
    { MODKEY|ShiftMask,     XK_h,        tagtoleft,        {0} },                     /* super shift h      |  将本窗口移动到左边tag */
    { MODKEY|ShiftMask,     XK_l,        tagtoright,       {0} },                     /* super shift l      |  将本窗口移动到右边tag */

    { MODKEY,               XK_a,        toggleoverview,   {0} },                     /* super a            |  显示所有tag 或 跳转到聚焦窗口的tag */

    { MODKEY,               XK_comma,    setmfact,         {.f = -0.05} },            /* super ,            |  缩小主工作区 */
    { MODKEY,               XK_period,   setmfact,         {.f = +0.05} },            /* super .            |  放大主工作区 */

    { MODKEY,               XK_d,        hidewin,          {0} },                     /* super d            |  隐藏 窗口 */
    { MODKEY|ShiftMask,     XK_d,        restorewin,       {0} },                     /* super shift d      |  取消隐藏 窗口 */

    { MODKEY,               XK_u,        zoom,             {0} },                     /* super shift u      |  将当前聚焦窗口置为主窗口 */

    { MODKEY,               XK_r,        togglefloating,   {0} },                     /* super r            |  开启/关闭 聚焦目标的float模式 */
    { MODKEY|ShiftMask,     XK_r,        toggleallfloating,{0} },                     /* super shift r      |  开启/关闭 全部目标的float模式 */
	{ MODKEY,               XK_f,        showonlyorall,    {0} },                     /* super f            |  切换 只显示一个窗口 / 全部显示 */
    { MODKEY|ShiftMask,     XK_f,        fullscreen,       {0} },                     /* super f            |  开启/关闭 全屏 */
    { MODKEY,               XK_p,        incnmaster,       {.i = +1} },               /* super p            |  改变主工作区窗口数量 (1 2中切换) */

    { MODKEY,               XK_n,        focusmon,         {.i = +1} },               /* super n            |  光标移动到另一个显示器 */
    { MODKEY|ShiftMask,     XK_n,        tagmon,           {.i = +1} },               /* super shift n      |  将聚焦窗口移动到另一个显示器 */

    { MODKEY,               XK_q,        killclient,       {0} },                     /* super q            |  关闭窗口 */
    { MODKEY|ControlMask,   XK_F12,      quit,             {0} },                     /* super ctrl f12     |  退出dwm */


	{ MODKEY,               XK_space,    selectlayout,     {.v = &layouts[1]} },      /* super space        |  切换到网格布局 */

    { MODKEY,               XK_equal,    setgap,           {.i = -6} },               /* super ctrl =       |  窗口增大 */
    { MODKEY,               XK_minus,    setgap,           {.i = +6} },               /* super ctrl -       |  窗口减小 */
    { MODKEY,               XK_BackSpace,setgap,           {.i = 0} },                /* super ctrl space   |  窗口重置 */

    { MODKEY|Mod1Mask,      XK_k,        movewin,          {.ui = UP} },              /* super alt k        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_j,        movewin,          {.ui = DOWN} },            /* super alt j        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_h,        movewin,          {.ui = LEFT} },            /* super alt h        |  移动窗口 */
    { MODKEY|Mod1Mask,      XK_l,        movewin,          {.ui = RIGHT} },           /* super alt l        |  移动窗口 */

    { MODKEY|ControlMask,   XK_k,        resizewin,        {.ui = V_REDUCE} },        /* super ctrl k       |  调整窗口 */
    { MODKEY|ControlMask,   XK_j,        resizewin,        {.ui = V_EXPAND} },        /* super ctrl j       |  调整窗口 */
    { MODKEY|ControlMask,   XK_h,        resizewin,        {.ui = H_REDUCE} },        /* super ctrl h       |  调整窗口 */
    { MODKEY|ControlMask,   XK_l,        resizewin,        {.ui = H_EXPAND} },        /* super ctrl l       |  调整窗口 */

    /* spawn + SHCMD 执行对 应命令 */
    { MODKEY|ShiftMask,     XK_q,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh killw") },
    { MODKEY,               XK_Return,   spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh terminal new") },
    { MODKEY|ControlMask,   XK_Return,   spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh terminal temp") },
    { MODKEY|ShiftMask,     XK_Return,   view,             {.ui = 1 << 1, .v = "~/Programs/dwm/scripts/app-starter.sh terminal ssh"} }, \

    { MODKEY,               XK_e,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh filemanager") },
    { MODKEY,               XK_b,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh changewallpaper") },
    { MODKEY,               XK_v,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh changevideo") },
    { Mod1Mask|ControlMask, XK_a,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh flameshot") },
    { Mod1Mask|ControlMask, XK_l,        spawn,            SHCMD("~/Programs/dwm/scripts/app-starter.sh blurlock") },

    { 0,                    XF86XK_MonBrightnessUp,        spawn,    SHCMD("~/Programs/dwm/scripts/app-starter.sh set_backlight up &") },
    { 0,                    XF86XK_MonBrightnessDown,      spawn,    SHCMD("~/Programs/dwm/scripts/app-starter.sh set_backlight down &") },
    { 0,                    XF86XK_AudioRaiseVolume,       spawn,    SHCMD("~/Programs/dwm/scripts/app-starter.sh set_vol up &") },
    { 0,                    XF86XK_AudioLowerVolume,       spawn,    SHCMD("~/Programs/dwm/scripts/app-starter.sh set_vol down &") },
    { 0,                    XF86XK_AudioMute,              spawn,    SHCMD("~/Programs/dwm/scripts/app-starter.sh set_vol toggle &") },

    /* super key : 跳转到对应tag */
    /* super shift key : 将聚焦窗口移动到对应tag */
    /* 若跳转后的tag无窗口且附加了cmd1或者cmd2就执行对应的cmd */
    /* key tag cmd1 cmd2 */
    TAGKEYS(XK_1, 0,  0,  0)
    TAGKEYS(XK_2, 1,  0,  0)
    TAGKEYS(XK_3, 2,  0,  0)
    TAGKEYS(XK_4, 3,  0,  0)
    TAGKEYS(XK_5, 4,  0,  0)
    TAGKEYS(XK_6, 5,  0,  0)
    TAGKEYS(XK_7, 6,  0,  0)
    TAGKEYS(XK_8, 7,  0,  0)
    TAGKEYS(XK_9, 8,  0,  0)
    TAGKEYS(XK_o , 6  , "~/Programs/dwm/scripts/app-starter.sh obsidian"  , "~/Programs/dwm/scripts/app-starter.sh obsidian")
    TAGKEYS(XK_c , 9  , "~/Programs/dwm/scripts/app-starter.sh chrome"    , "~/Programs/dwm/scripts/app-starter.sh chrome")
    TAGKEYS(XK_w , 10 , "~/Programs/dwm/scripts/app-starter.sh wechat"    , "~/Programs/dwm/scripts/app-starter.sh wechat")
    TAGKEYS(XK_i , 11 , "~/Programs/dwm/scripts/app-starter.sh qq"        , "~/Programs/dwm/scripts/app-starter.sh qq")
    TAGKEYS(XK_t , 12 , "~/Programs/dwm/scripts/app-starter.sh Telegram"  , "~/Programs/dwm/scripts/app-starter.sh Telegram")
    TAGKEYS(XK_m , 13 , "~/Programs/dwm/scripts/app-starter.sh wemeet"    , "~/Programs/dwm/scripts/app-starter.sh wemeet")
    TAGKEYS(XK_g , 14 , "~/Programs/dwm/scripts/app-starter.sh steam"     , "~/Programs/dwm/scripts/app-starter.sh steam")
};
static Button buttons[] = {
    /* click               event mask       button            function       argument  */
	{ ClkStatusText,       0,               Button1,          spawn,         SHCMD("~/Programs/dwm/scripts/app-starter.sh terminal temp") }, // 左键        |  点击状态栏   |  打开float st
    { ClkWinTitle,         0,               Button1,          hideotherwins, {0} },                                   // 左键        |  点击标题     |  隐藏其他窗口仅保留该窗口
    { ClkWinTitle,         0,               Button3,          togglewin,     {0} },                                   // 右键        |  点击标题     |  切换窗口显示状态
    { ClkTagBar,           0,               Button1,          view,          {0} },                                   // 左键        |  点击tag      |  切换tag
	{ ClkTagBar,           0,               Button3,          toggleview,    {0} },                                   // 右键        |  点击tag      |  切换是否显示tag
    { ClkClientWin,        MODKEY,          Button1,          movemouse,     {0} },                                   // super+左键  |  拖拽窗口     |  拖拽窗口
    { ClkClientWin,        MODKEY,          Button3,          resizemouse,   {0} },                                   // super+右键  |  拖拽窗口     |  改变窗口大小
    { ClkTagBar,           MODKEY,          Button1,          tag,           {0} },                                   // super+左键  |  点击tag      |  将窗口移动到对应tag
};
