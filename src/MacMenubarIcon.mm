/*
 * Copyright (C) 2021 Adrian Carpenter
 *
 * This file is part of the Nedrysoft MacHelper. (https://github.com/nedrysoft/MacHelper)
 *                                                                                        *
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
#include "StatusbarHelper.h"

Nedrysoft::MacHelper::MacMenubarIcon::MacMenubarIcon(QPixmap pixmap) {
    m_pixmap = pixmap;

    m_statusbarHelper = [[StatusbarHelper alloc] initWithMenuBarIcon: this];
}

auto Nedrysoft::MacHelper::MacMenubarIcon::pixmap() -> QPixmap {
    return m_pixmap;
}

auto Nedrysoft::MacHelper::MacMenubarIcon::buttonRect() -> QRect {
    return QRectF::fromCGRect(NSRectToCGRect([m_statusbarHelper buttonRect])).toRect();
}

auto Nedrysoft::MacHelper::MacMenubarIcon::button() -> NSView * {
    return [m_statusbarHelper button];
}

auto Nedrysoft::MacHelper::MacMenubarIcon::setPixmap(QPixmap pixmap) -> void {
    m_pixmap = pixmap;

    [m_statusbarHelper updatePixmap];
}

auto Nedrysoft::MacHelper::MacMenubarIcon::show() -> void {
    [m_statusbarHelper setVisible: true];
}

auto Nedrysoft::MacHelper::MacMenubarIcon::hide() -> void {
    [m_statusbarHelper setVisible: false];
}