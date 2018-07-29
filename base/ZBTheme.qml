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

    property color dockBackgroundColor: "black"

    property color dockItemColor: "black"
    property color dockItemBackgroundColor: "white"

    property color dockItemSelectedColor: "white"
    property color dockItemSelectedBackgroundColor: "blue"

    property color ribbonColor: "red"
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
