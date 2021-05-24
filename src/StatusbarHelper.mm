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

#include "MacHelper.h"

constexpr auto StatusbarIconSize = 20;

@implementation StatusbarHelper
#include <QDebug>
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

@end
