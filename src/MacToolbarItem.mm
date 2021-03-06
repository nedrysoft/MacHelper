/*
 * Copyright (C) 2021 Adrian Carpenter
 *
 * This file is part of the Nedrysoft MacHelper. (https://github.com/nedrysoft/MacHelper)
 *
 * An open-source cross-platform traceroute analyser.
 *
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

#include "MacToolbarItem.h"

#import <AppKit/AppKit.h>

constexpr auto IconSize = 256;

Nedrysoft::MacHelper::MacToolbarItem::MacToolbarItem(
        const QIcon &icon, const QString &identifier, const QString &label, const QString &paletteLabel) :
            m_icon(icon),
            m_identifier(identifier),
            m_label(label.isEmpty()==false ? label:identifier),
            m_paletteLabel(paletteLabel.isEmpty()==false ? paletteLabel:identifier),
            m_toolbarItem(nullptr) {

}

auto Nedrysoft::MacHelper::MacToolbarItem::setIcon(QIcon icon) -> void {
    auto pixmap = icon.pixmap(IconSize, IconSize);

    NSImage *image = [[NSImage alloc] initWithCGImage: pixmap.toImage().toCGImage()
                                                 size: CGSizeMake(IconSize, IconSize)];

    [m_toolbarItem setImage:image];

    [image release];
}

auto Nedrysoft::MacHelper::MacToolbarItem::identifier() -> QString {
    return m_identifier;
}

auto Nedrysoft::MacHelper::MacToolbarItem::icon() -> QIcon {
    return m_icon;
}

auto Nedrysoft::MacHelper::MacToolbarItem::item() -> NSToolbarItem * {
    return m_toolbarItem;
}

auto Nedrysoft::MacHelper::MacToolbarItem::setToolbarItem(NSToolbarItem *item) -> void {
    m_toolbarItem = item;
}