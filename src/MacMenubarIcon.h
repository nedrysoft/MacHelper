/*
 * Copyright (C) 2021 Adrian Carpenter
 *
 * This file is part of the Nedrysoft MacHelper. (https://github.com/nedrysoft/MacHelper)
 *
 * Created by Adrian Carpenter on 04/05/2021.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef NEDRYSOFT_MACMENUBARICON_H
#define NEDRYSOFT_MACMENUBARICON_H

#include <QObject>
#include <QPixmap>

class QMenu;

Q_FORWARD_DECLARE_OBJC_CLASS(StatusbarHelper);
Q_FORWARD_DECLARE_OBJC_CLASS(NSView);

namespace Nedrysoft { namespace MacHelper {
    enum class MouseButton {
        Unknown,
        Left,
        Right
    };
    /**
     * @brief       Provides a menu bar icon under macOS.
     *
     * @class       Nedrysoft::MacHelper::MacMenubarIcon MacMenubarIcon.h <MacMenubarIcon>
     */
    class MacMenubarIcon :
            public QObject {

        private:
            Q_OBJECT

        public:
            /**
             * @brief       Constructs a new MacMenubarIcon with a pixmap.
             *
             * @param[in]   pixmap the pixmap to be used for the icon.
             */
            MacMenubarIcon(QPixmap pixmap);

            /**
             * @brief       Destroys the MenuBarIcon.
             */
            ~MacMenubarIcon() = default;

            /**
             * @brief       Returns the pixmap currently being used on the icon.
             *
             * @returns     the pixmap.
             */
            auto pixmap() -> QPixmap;

            /**
             * @brief       Returns the button rect of the icon on the menu bar.
             *
             * @returns     the rectangle of the icon.
             */
            auto buttonRect() -> QRect;

            /**
             * @brief       Returns the native NSVIew of the icons button.
             *
             * @returns     the icons button.
             */
            auto button() -> NSView *;

            /**
             * @brief       Sets the pixmap for the icon.
             *
             * @param[in]   pixmap the pixmap.
             */
            auto setPixmap(QPixmap pixmap) -> void;

            /**
             * @brief       Shows the menu bar icon.
             */
            auto show() -> void;

            /**
             * @brief       Hides the menu bar icon.
             */
            auto hide() -> void;

            /**
             * @brief       Shows the given menu from the status bar icon origin.
             *
             * @param[in]   menu the menu to open.
             */
            auto showMenu(QMenu *menu) -> void;

        public:
            /**
             * @brief       This signal is emitted when the icon is clicked.
             */
            Q_SIGNAL void clicked(Nedrysoft::MacHelper::MouseButton mouseButton);

            /**
             * @brief       This signal is emitted when the menu is closed.
             *
             * @param[in]   menu the menu that was closed.
             */
            Q_SIGNAL void menuClosed(QMenu *menu);

        private:
            //! @cond

            QPixmap m_pixmap;
            StatusbarHelper *m_statusbarHelper;

            //! @endcond
    };
}}


#endif // NEDRYSOFT_MACMENUBARICON_H
