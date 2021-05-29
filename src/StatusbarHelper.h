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

#ifndef NEDRYSOFT_STATUSBARHELPER_H
#define NEDRYSOFT_STATUSBARHELPER_H

#include <QAction>
#include <QMap>
#include <QWidget>
#include <QPixmap>

#include "MacMenubarIcon.h"

#import <AppKit/AppKit.h>

class QMenu;

//! @cond

@interface StatusbarHelper : NSObject <NSMenuDelegate> {
    NSStatusItem *m_statusbarItem;
    NSStatusBarButton *m_button;
    Nedrysoft::MacHelper::MacMenubarIcon *m_menubarIcon;
    id<NSMenuDelegate> m_delegate;
    QMenu *m_menu;
    NSMenu *m_nativeMenu;
    QMap<int, QAction *> m_actionMap;
}

//! @endcond

/**
 * @brief       Called when the menu bar icons button has been clicked.
 *
 * @param[in]   sender the button that was the source of the click.
 */
- (void) statusBarItemClicked:(NSStatusBarButton *) sender;

/**
 * @brief       Initialises a StatusbarHelper for a given menu bar icon.
 *
 * @param[in]   menuBarIcon the menu bar icon.
 *
 * @returns     the StatusBarHelper instance.
 */
- (id) initWithMenuBarIcon:(Nedrysoft::MacHelper::MacMenubarIcon *) menubarIcon;

/**
 * @brief       Returns the rectangle of the menu bar icons button.
 *
 * @returns     the menu bar buttons rectangle.
 */
- (NSRect) buttonRect;

/**
 * @brief       Returns the NSView of the button.
 *
 * @returns     the button.
 */
- (NSView *) button;

/**
 * @brief       Updates the pixmap.
 *
 * @note        retrieves the pixmap from the MenuBarIcon that was associated during construction and sets it
 *              to be the current icon.
 */
- (void) updatePixmap;

/**
 * @brief       Displays or hides the icon.
 *
 * @param[in]   visible true if the icon is to be shown; otherwise false.
 */
- (void) setVisible:(bool) visible;

/**
 * @brief       When responding to a click on the icon, this method can be used to show the menu.
 */
- (void) showMenu:(QMenu *) menu;

/**
 * @brief       Called when the menu is dismissed.
 *
 * @param[in]   menu the menu that was closed.
 */
- (void) menuDidClose:(NSMenu *) menu;

/**
 * @brief       Called when a menu item is selected.
 *
 * @param[id]   sender a pointer to the NSMenuItem that was selected.
 */
- (void) performAction:(id) sender;

@end

#endif // NEDRYSOFT_STATUSBARHELPER_H
