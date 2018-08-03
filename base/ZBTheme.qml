pragma Singleton

import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

Item {
    id: objBaseTheme
    property alias accent: objMetaTheme.accent
    property alias background: objMetaTheme.background
    property alias foreground: objMetaTheme.foreground
    property alias primary: objMetaTheme.primary
    property alias secondary: objMetaTheme.secondary
    property alias theme: objMetaTheme.theme
    property alias imageBrightness: objMetaTheme.imageBrightness

    property string defaultFontFamily: "Ubuntu"
    property int defaultFontSize: 15

    /*Menu related settings*/
    property int menuWindowWidth: 200
    property int menuWindowHeight: 300
    property int menuItemHeight: 50
    property color menuWindowBackgroundColor: metaTheme.changeTransparency("black",200)

    property color itemColor: "white"
    property color itemBackgroundColor: "transparent"
    property color itemSelectedColor: "red"
    property color itemSelectedBackgroundColor: "black"

    property string itemFontFamily: "Ubuntu"
    property int itemFontSize: 15
    property bool itemFontBold: false
    property bool itemIconFontBold: false

    property string itemSelectedFontFamily: "Ubuntu"
    property int itemSelectedFontSize: 15
    property bool itemSelectedFontBold: false
    property bool itemSelectedIconFontBold: false


    /*Dock Related settings*/
    property int dockViewMode: zSingleColumn
    property int dockItemHeight: 50
    property int dockItemWidth: 50
    property int dockItemExpandedWidth: 150

    property color dockBackgroundColor: metaTheme.changeTransparency("black",200)

    property color dockItemColor: "white"
    property color dockItemBackgroundColor: "transparent"

    property string dockItemFontFamily: "Ubuntu"
    property int dockItemFontSize: 15
    property bool dockItemFontBold: false
    property bool dockItemIconFontBold: false


    property string dockItemSelectedFontFamily: "Ubuntu"
    property int dockItemSelectedFontSize: 15
    property bool dockItemSelectedFontBold: false
    property bool dockItemSelectedIconFontBold: false

    property color dockItemSelectedColor: "red"
    property color dockItemSelectedBackgroundColor: "black"
    /*END of Dock related settings */

    property int ribbonHeight: 3
    property color ribbonColor: "yellow"
    property color ribbonColorNonFocus: "grey"
    property bool useAnimation: true

    /*ENUMS scrollMode*/
    property int zInfiniteHeight: 0
    property int zInfiniteWidth: 1

    /*ENUMS SideDockView mode*/
    property int zSingleColumn: 0;
    property int zSingleColumnExpand: 1;
    property int zMultiColumn: 2;


    property alias metaTheme: objMetaTheme
    QbMetaTheme{
        id: objMetaTheme
    }
    /**********************************************************************************************
      All available metaTheme methods
      ---------------------------------------------------------------------------------------------
        void setImageFromPath(const QString &path);
        void setImageFromData(const QByteArray &data);
        void setImageFromBase64(const QByteArray &data);

        void setThemeFromFile(const QString &path);
        void setThemeFromJsonData(const QByteArray &data);

        bool isDark(const QColor &c);
        bool isDark2(const QColor &c);

        bool isBright(const QColor &c);
        bool isBright2(const QColor &c);

        int getBrightness(const QColor &c);
        int getBrightness2(const QColor &c);

        int getBrightnessFromRGB(int r,int g,int b);
        int getBrightnessFromRGB2(int r,int g,int b);

        int getBrightnessFromRGBInteger(QRgb c);
        int getBrightnessFromRGBInteger2(QRgb c);

        QVariantList colorPaletteList() const;

        QColor lighter(const QColor &c, int val = 255) const;
        QColor darker(const QColor &c, int val = 0) const;
        QColor textColor(const QColor &c);

        QColor changeTransparency(const QColor &c,int val = 140);

        QColor complementaryColor(const QColor &c) const;
        QColor monochromeColor(const QColor &c, const int &s, const int &v) const;

        QVariantList splitComplementaryColor(const QColor &c) const;
        QVariantList triadicColor(const QColor &c) const;
        QVariantList tetradicColor(const QColor &c) const;
        QVariantList analagousColor(const QColor &c) const;
    **********************************************************************************************/
}
