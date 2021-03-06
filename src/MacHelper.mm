/*
 * Copyright (C) 2020 Adrian Carpenter
 *
 * This file is part of the Nedrysoft MacHelper library. (https://github.com/nedrysoft/MacHelper)
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

#include "MacHelper.h"

#include <QDialog>
#include <QTimer>

#import <AppKit/AppKit.h>

constexpr auto BitsPerPixel = 8;
constexpr auto SamplesPerPixel = 4;
constexpr auto SystemFontSize = 12;

int Nedrysoft::MacHelper::MacHelper::m_appNapCount = 0;
NSObject *Nedrysoft::MacHelper::MacHelper::m_appNapActivity = nullptr;
QRecursiveMutex Nedrysoft::MacHelper::MacHelper::m_appNapMutex = QRecursiveMutex();

auto Nedrysoft::MacHelper::MacHelper::setTitlebarColour(QWidget *window, QColor colour, bool brightText) -> void {
    auto nativeView = reinterpret_cast<NSView *>(window->winId());

    if (!nativeView) {
        return;
    }

    Q_ASSERT_X([nativeView isKindOfClass:[NSView class]], static_cast<const char *>(__FUNCTION__),
               "Object was not a NSView");

    auto nativeWindow = [nativeView window];

    if (nativeWindow == nil) {
        return;
    }

    Q_ASSERT_X([nativeWindow isKindOfClass:[NSWindow class]], static_cast<const char *>(__FUNCTION__),
               "Object was not a NSWindow");

    [nativeWindow setTitlebarAppearsTransparent:true];

    [nativeWindow setBackgroundColor:[NSColor colorWithRed:colour.redF()
                                                     green:colour.greenF()
                                                      blue:colour.blueF()
                                                     alpha:colour.alphaF()]];

    if (brightText) {
        [nativeWindow setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
    } else {
        [nativeWindow setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
    }
}

auto Nedrysoft::MacHelper::MacHelper::clearTitlebarColour(QWidget *window, bool isDarkMode) -> void {
    auto nativeView = reinterpret_cast<NSView *>(window->winId());

    if (!nativeView) {
        return;
    }

    Q_ASSERT_X([nativeView isKindOfClass:[NSView class]], static_cast<const char *>(__FUNCTION__),
               "Object was not a NSView");

    auto nativeWindow = [nativeView window];

    if (nativeWindow == nil) {
        return;
    }

    Q_ASSERT_X([nativeWindow isKindOfClass:[NSWindow class]], static_cast<const char *>(__FUNCTION__),
               "Object was not a NSWindow");

    [nativeWindow setTitlebarAppearsTransparent:false];

    if (@available(macOS 10.14, *)) {
        if (isDarkMode) {
            [nativeWindow setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameDarkAqua]];
        } else {
            [nativeWindow setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
        }
    } else {
        [nativeWindow setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameAqua]];
    }
}

void Nedrysoft::MacHelper::MacHelper::enablePreferencesToolbar(QWidget *window) {
    if (@available(macOS 11, *)) {
        auto nativeView = reinterpret_cast<NSView *>(window->winId());

        if (!nativeView) {
            return;
        }

        Q_ASSERT_X([nativeView isKindOfClass:[NSView class]], static_cast<const char *>(__FUNCTION__),
                   "Object was not a NSView");

        auto nativeWindow = [nativeView window];

        if (nativeWindow == nil) {
            return;
        }

        Q_ASSERT_X([nativeWindow isKindOfClass:[NSWindow class]], static_cast<const char *>(__FUNCTION__),
                   "Object was not a NSWindow");

        if ([nativeWindow respondsToSelector:@selector(setToolbarStyle:)]) {
            [nativeWindow setToolbarStyle:NSWindowToolbarStylePreference];
        }
    }
}

auto Nedrysoft::MacHelper::MacHelper::standardImage(
        StandardImage::StandardImageName standardImage,
        QSize imageSize)->QPixmap {

    auto bitmapRepresentation = [[NSBitmapImageRep alloc]
            initWithBitmapDataPlanes: nullptr
                          pixelsWide: imageSize.width()
                          pixelsHigh: imageSize.height()
                       bitsPerSample: BitsPerPixel
                     samplesPerPixel: SamplesPerPixel
                            hasAlpha: YES
                            isPlanar: NO
                      colorSpaceName: NSDeviceRGBColorSpace
                        bitmapFormat: NSBitmapFormatAlphaFirst
                         bytesPerRow: 0
                        bitsPerPixel: 0
    ];

    NSString *nativeImageName = nullptr;

    switch(standardImage) {
        case Nedrysoft::MacHelper::StandardImage::NSImageNamePreferencesGeneral: {
            nativeImageName = NSImageNamePreferencesGeneral;
            break;
        }

        case Nedrysoft::MacHelper::StandardImage::NSImageNameUserAccounts: {
            nativeImageName = NSImageNameUserAccounts;
            break;
        }

        case Nedrysoft::MacHelper::StandardImage::NSImageNameAdvanced: {
            nativeImageName = NSImageNameAdvanced;
            break;
        }
    }

    auto nsImage = [NSImage imageNamed: nativeImageName];

    [NSGraphicsContext saveGraphicsState];

    [NSGraphicsContext setCurrentContext: [NSGraphicsContext graphicsContextWithBitmapImageRep: bitmapRepresentation]];

    [nsImage drawInRect: NSMakeRect(0, 0, imageSize.width(), imageSize.height())
               fromRect: NSZeroRect
              operation: NSCompositingOperationSourceOver
               fraction: 1];

    [NSGraphicsContext restoreGraphicsState];

    auto imageRef = [bitmapRepresentation CGImage];

    auto pixelData = CFDataGetBytePtr(CGDataProviderCopyData(CGImageGetDataProvider(imageRef)));

    auto image = QImage(pixelData,  imageSize.width(), imageSize.height(),QImage::Format_ARGB32);

    [bitmapRepresentation release];

    return QPixmap::fromImage(image);
}

auto Nedrysoft::MacHelper::MacHelper::nativeAlert(
        QWidget *parent,
        const QString &messageText,
        const QString &informativeText,
        const QStringList &buttons,
        std::function<void(Nedrysoft::MacHelper::AlertButton::AlertButtonResult)> alertFunction) -> void {

    Q_UNUSED(parent)

    // ok, this looks odd, but without the singleShot the dialog fails to display properly and flashes up on
    // screen briefly before closing itself, this only happens under certain circumstances but this fixes
    // the issue.

    QTimer::singleShot(0, [=]() {
        auto alert = [[NSAlert alloc] init];

        for (auto &button : buttons) {
            [alert addButtonWithTitle:button.toNSString()];
        }

        [alert setMessageText:messageText.toNSString()];
        [alert setInformativeText:informativeText.toNSString()];
        [alert setAlertStyle:NSAlertStyleInformational];

        auto returnValue = [alert runModal];

        [alert release];

        alertFunction(static_cast<Nedrysoft::MacHelper::AlertButton::AlertButtonResult>(returnValue));
    });
}

auto Nedrysoft::MacHelper::MacHelper::loadImage(
        const QString &filename,
        std::shared_ptr<char *> &data,
        unsigned int *length) -> bool {

    auto fileName = filename.toNSString();

    auto loadedImage = [[NSImage alloc] initWithContentsOfFile:fileName];

    if (loadedImage.isValid) {
        NSData *tiffData = [loadedImage TIFFRepresentation];

        data = std::make_shared<char *>(static_cast<char *>(malloc(tiffData.length)));

        *length = static_cast<unsigned int>(tiffData.length);

        memcpy(data.get(), tiffData.bytes, *length);

        [loadedImage release];

        return true;
    }

    [loadedImage release];

    return false;
}

auto Nedrysoft::MacHelper::MacHelper::imageForFile(
        const QString &filename,
        std::shared_ptr<char *> &data,
        unsigned int *length,
        int width,
        int height) -> bool {

    auto loadedImage = [[NSWorkspace sharedWorkspace] iconForFile:filename.toNSString()];

    [loadedImage setSize:NSMakeSize(width,height)];

    if (loadedImage.isValid) {
        NSData *tiffData = [loadedImage TIFFRepresentation];

        data = std::make_shared<char *>(static_cast<char *>(malloc(tiffData.length)));

        *length = static_cast<unsigned int>(tiffData.length);

        memcpy(data.get(), tiffData.bytes, *length);

        return true;
    }

    return false;
}

auto Nedrysoft::MacHelper::MacHelper::systemFontName() -> QString {
    auto font = [NSFont systemFontOfSize: SystemFontSize];

    return QString([[font fontName] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
}

auto Nedrysoft::MacHelper::MacHelper::fontFilename(const QString& fontName) ->QString {
    auto font = [NSFont fontWithName: [NSString stringWithCString: fontName.toLatin1().data() encoding: [NSString defaultCStringEncoding]] size: SystemFontSize];

    if (font) {
        auto fontRef = CTFontDescriptorCreateWithNameAndSize(reinterpret_cast<CFStringRef>([font fontName]), [font pointSize]);

        auto url = static_cast<CFURLRef>(CTFontDescriptorCopyAttribute(fontRef, kCTFontURLAttribute));

        auto fontPath = [NSString stringWithString: [(NSURL *) CFBridgingRelease(url) path]];

        return QString([fontPath cStringUsingEncoding: [NSString defaultCStringEncoding]]);
    }

    return QString();
}

auto Nedrysoft::MacHelper::MacHelper::hideApplication() -> void {
    [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyProhibited];
}

auto Nedrysoft::MacHelper::MacHelper::showApplication() -> void {
    NSApplication *applicationInstance = [NSApplication sharedApplication];

    [applicationInstance setActivationPolicy:NSApplicationActivationPolicyRegular];
    [applicationInstance activateIgnoringOtherApps:YES];
}

auto Nedrysoft::MacHelper::MacHelper::disableAppNap(const QString &reason) -> void {
    QMutexLocker mutexLocker(&m_appNapMutex);

    if (m_appNapActivity == nil) {
        if ([[NSProcessInfo processInfo] respondsToSelector:@selector(beginActivityWithOptions:reason:)]) {
            m_appNapActivity = [[NSProcessInfo processInfo] beginActivityWithOptions:NSActivityUserInitiatedAllowingIdleSystemSleep reason:reason.toNSString()];
        }

        if (m_appNapActivity) {
            m_appNapCount++;
        }
    }
}

auto Nedrysoft::MacHelper::MacHelper::enableAppNap() -> void {
    QMutexLocker mutexLocker(&m_appNapMutex);

    if (m_appNapCount) {
        m_appNapCount--;

        if (m_appNapCount == 0) {
            if (m_appNapActivity != nil) {
                [[NSProcessInfo processInfo] endActivity:m_appNapActivity];

                m_appNapActivity = nil;
            }
        }
    }
}