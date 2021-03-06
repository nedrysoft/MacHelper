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

#ifndef NEDRYSOFT_POPOVERHELPER_H
#define NEDRYSOFT_POPOVERHELPER_H

#include <QWidget>
#include <QSize>

#include "MacMenubarIcon.h"
#include "MacPopover.h"

#import <AppKit/AppKit.h>

//! @cond

@interface PopoverHelper : NSObject {
    QWidget *m_contentWidget;
    NSPopover *m_popover;
    NSView *m_nativeView;
    NSViewController *m_viewController;
}
//! @endcond

/**
 * @brief       Show the popover with the given parameters.
 *
 * @param[in]   contentWidget the widget that is used as the content of the popover.
 * @param[in]   view the view that the popover originates from.
 * @param[in]   sourceRect the rectangle of the view that the popover originates from.
 * @param[in]   size the size of the popover window.
 * @param[in]   preferredEdge the preferred edge that the popover should be relative to.
 */
- (void) show:(QWidget *) contentWidget
     withView:(NSView *) view
   sourceRect:(NSRect) rect
         size:(NSSize) size
preferredEdge:(Nedrysoft::MacHelper::MacPopover::Edge) preferredEdge;

@end

#endif // NEDRYSOFT_POPOVERHELPER_H
