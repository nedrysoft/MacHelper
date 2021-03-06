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

#ifndef NEDRYSOFT_MACPOPOVER_H
#define NEDRYSOFT_MACPOPOVER_H

#include <QObject>
#include <QPixmap>

Q_FORWARD_DECLARE_OBJC_CLASS(PopoverHelper);

namespace Nedrysoft { namespace MacHelper {
    class MacMenubarIcon;

    /**
     * @brief       Displays a native macOS popover window.
     *
     * @class       Nedrysoft::MacHelper::MacPopover MacPopover.h <MacPopover>
     */
    class MacPopover :
            public QObject {

        private:
            Q_OBJECT

        public:
            /**
             * @brief       The list of edges that the popover can be aligned to.
             */
            enum class Edge {
                MaxXEdge,
                MaxYEdge,
                MinXEdge,
                MinYEdge
            };

        public:
            /**
             * @brief       Shows the popup relative to a menu bar icon.
             *
             * @note        The popover becomes the owner of the contentWidget, you must not delete it as it is
             *              the responsibility of the popover to manage the widget.
             *
             * @param[in]   menubarIcon the menu bar icon that the popover is relative to.
             * @param[in]   contentWidget the content to display in the popover.
             * @param[in]   size the size of the popover.
             * @param[in]   edge the edge that the popover should be attached to.
             */
            auto show(
                    Nedrysoft::MacHelper::MacMenubarIcon *menubarIcon,
                    QWidget *contentWidget,
                    QSize size,
                    Nedrysoft::MacHelper::MacPopover::Edge edge) -> void;

            /**
             * @brief       Shows the popup relative to a widget.
             *
             * @note        The popover becomes the owner of the contentWidget, you must not delete it as it is
             *              the responsibility of the popover to manage the widget.
             *
             * @param[in]   widget the widget that the popover is relative to.
             * @param[in]   contentWidget the content to display in the popover.
             * @param[in]   size the size of the popover.
             * @param[in]   edge the edge that the popover should be attached to.
             */
            auto show(
                    QWidget *widget,
                    QWidget *contentWidget,
                    QSize size,
                    Nedrysoft::MacHelper::MacPopover::Edge edge) -> void;

        public:
            /**
             * @brief       This signal is emitted when the popover has been closed.
             */
            Q_SIGNAL void closed();

        private:
            //! @cond

            PopoverHelper *m_popover;

            //! @endcond
    };
}}

#endif // NEDRYSOFT_MACPOPOVER_H
