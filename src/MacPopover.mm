/*
 * Copyright (C) 2021 Adrian Carpenter
 *
 * This file is part of the Nedrysoft MacHelper. (https://github.com/nedrysoft/MacHelper)
 *                                                                                           *
 * Created by Adrian Carpenter on 07/05/2021.
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

#include "MacMenubarIcon.h"
#include "MacPopover.h"
#include "PopoverHelper.h"

/*
 * TODO: need to add the direction of the popover for the general case
 */

auto Nedrysoft::MacHelper::MacPopover::show(
        Nedrysoft::MacHelper::MacMenubarIcon *menubarIcon,
        QWidget *contentWidget,
        QSize size,
        Nedrysoft::MacHelper::MacPopover::Edge edge) -> void {

    m_popover = [[PopoverHelper alloc] init];

    [m_popover show:contentWidget
           withView:menubarIcon->button()
         sourceRect:NSRectFromCGRect(menubarIcon->buttonRect().toCGRect())
               size:size.toCGSize()
      preferredEdge:edge];
}

auto Nedrysoft::MacHelper::MacPopover::show(
        QWidget *widget,
        QWidget *contentWidget,
        QSize size,
        Nedrysoft::MacHelper::MacPopover::Edge edge) -> void {

    m_popover = [[PopoverHelper alloc] init];

    [m_popover show:contentWidget
           withView:reinterpret_cast<NSView *>(widget->winId())
         sourceRect:NSRectFromCGRect(widget->rect().toCGRect())
               size:size.toCGSize()
      preferredEdge:edge];
}
