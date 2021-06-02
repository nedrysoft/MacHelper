/*
 * Copyright (C) 2020 Adrian Carpenter
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

#include "StatusbarHelper.h"

#include <QMenu>

constexpr auto StatusbarIconSize = 20;

@implementation StatusbarHelper

- (void) statusBarItemClicked:(NSStatusBarButton *) sender {
    NSEventType eventType = [[[NSApplication sharedApplication] currentEvent] type];

    Nedrysoft::MacHelper::MouseButton button = Nedrysoft::MacHelper::MouseButton::Unknown;

    if (eventType==NSEventTypeRightMouseUp) {
        button = Nedrysoft::MacHelper::MouseButton::Right;
    } else if (eventType==NSEventTypeLeftMouseUp) {
        button = Nedrysoft::MacHelper::MouseButton::Left;
    }

    Q_EMIT m_menubarIcon->clicked(button);
}

- (id) initWithMenuBarIcon:(Nedrysoft::MacHelper::MacMenubarIcon *) menubarIcon {
    self = [super init];

    if (!self) {
        return nil;
    }

    NSStatusBar *systemStatusBar = [NSStatusBar systemStatusBar];

    m_menubarIcon = menubarIcon;

    m_statusbarItem = [systemStatusBar statusItemWithLength:NSSquareStatusItemLength];

    CGImageRef imageRef;

    if (menubarIcon->pixmap().width() != StatusbarIconSize) {
        imageRef = menubarIcon->pixmap().scaled(StatusbarIconSize, StatusbarIconSize).toImage().toCGImage();
    } else {
        imageRef = menubarIcon->pixmap().toImage().toCGImage();
    }

    m_button = [m_statusbarItem button];

    NSImage *nativeImage = [[NSImage alloc] initWithCGImage:imageRef
                                                       size:NSMakeSize(StatusbarIconSize, StatusbarIconSize)];

    [m_button setImage:nativeImage];

    [m_button setTarget:self];
    [m_button setAction:@selector(statusBarItemClicked:)];
    [m_button sendActionOn: NSEventMaskLeftMouseUp | NSEventMaskRightMouseUp];

    [nativeImage release];

    return self;
}

- (NSRect) buttonRect {
    return [m_button visibleRect];
}

- (NSView *) button {
    return m_button;
}

- (void) updatePixmap {
    CGImageRef imageRef;

    if (m_menubarIcon->pixmap().width() != StatusbarIconSize) {
        imageRef = m_menubarIcon->pixmap().scaled(StatusbarIconSize, StatusbarIconSize).toImage().toCGImage();
    } else {
        imageRef = m_menubarIcon->pixmap().toImage().toCGImage();
    }

    NSImage *nativeImage = [[NSImage alloc] initWithCGImage:imageRef
                                                       size:NSMakeSize(StatusbarIconSize, StatusbarIconSize)];

    [m_button setImage:nativeImage];

    [nativeImage release];
}

- (void) setVisible:(bool) visible {
    [m_button setHidden: !visible];
}

- (void) showMenu:(QMenu *) menu {
    m_nativeMenu = [[NSMenu alloc] init];

    auto itemIndex = 1;

    int previousISeparatorItem = false;

    for (auto action : menu->actions()) {
        NSMenuItem *menuItem;

        if (action->isSeparator()) {
            if (previousISeparatorItem) {
                continue;
            }

            menuItem = [NSMenuItem separatorItem];

            previousISeparatorItem = true;
        } else {
            menuItem = [[NSMenuItem alloc] init];

            [menuItem setTitle: action->text().toNSString()];
            [menuItem setTarget: self];
            [menuItem setAction: @selector(performAction:)];

            previousISeparatorItem = false;
        }

        m_actionMap[itemIndex] = action;

        [menuItem setTag: itemIndex++];

        [m_nativeMenu addItem:menuItem];
    }

    m_delegate = [m_nativeMenu delegate];

    [m_nativeMenu setDelegate: self];

    [m_statusbarItem setMenu: m_nativeMenu];

    [m_button performClick:nil];
}

- (void) menuDidClose:(NSMenu *) menu {
    [m_statusbarItem setMenu: nil];

    [menu release];

    Q_EMIT m_menubarIcon->menuClosed(m_menu);
}

- (void) performAction:(id) sender {
    NSMenuItem *menuItem = (NSMenuItem *) sender;

    if (menuItem!=nil) {
        int itemIndex = [menuItem tag];

        if (itemIndex) {
            auto action = m_actionMap[itemIndex];

            if (action) {
                action->trigger();
            }
        }
    }
}

@end
