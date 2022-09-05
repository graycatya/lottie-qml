# Lottie QML

This provides a QML `Item` to render Adobe® After Effects™ animations exported as JSON with Bodymovin using the Lottie Web library.

See http://airbnb.io/lottie/

## How to use

You can use the `LottieAnimation` item just like any other `QtQuick` element, such as an `Image` and place it in your scene any way you please.

```
import org.kde.lottie 1.0

LottieAnimation {
    id: fancyAnimation
    anchors.fill: parent
    source: Qt.resolvedUrl("animations/fancy_animation.json")
    loops: Animation.Infinite
    fillMode: Image.PreserveAspectFit
    running: true
}
```

There is a testing application provided in this repository:

The teser project in the available case supports qmake and cmake

Just drag a Lottie JSON animation file into it and tweak the settings provided in the toolbar.
You can also add multiple files and switch between them using the ComboBox in the top left or Ctrl+(Shift)+Tab shortcuts.

### Property documentation

* `source` can be an absolute URL to an animation JSON file (including `qrc:/`), a JSON data string, or a JavaScript object.
    * Relative URLs are currently not supported, use `Qt.resolvedUrl`, if neccessary
* `status` can be `Image.Null`, `Image.Ready`, `Image.Loading`, or `Image.Error`. In the latter case `errorString` may contain error messages explaining the failure to load.
* `loops` (default 0) can be an integer number of loops, or `Animation.Infinite` to repeat the animation indefinitely
* `running` whether the animation is and should be running (you can also call `start()`, `pause()`, and `stop()`)
* `speed` (default 1.0) modifies the animation speed, e.g. 0.5x, 2.0x, …
* `reverse` runs the animation in reverse
* `clearBeforeRendering` (default true) Whether to clear the canvas before each frame, might improve performance on full-screen scenes but also cause unwanted rendering artefacts when disabled
* `fillMode` can be `Image.Stretch` (default), `Image.PreserveAspectFit`, `Image.PreserveAspectCrop`, or `Image.Pad`
* `renderStrategy` and `renderTarget` aliased to the internal `Canvas`

### Notes

* The item's `implicitWidth` and `implicitHeight` will be set to the animation's native canvas size.

## How to use Core Library


### qmake

* Usage of pri file

Use the core library only need to import, the'.pri' file under the module folder

The resources that GrayCatYa needs to use will be quoted in the form of qrc resources. Pay attention to the path name of the resource, and do not re-path with the new qrc resource file.

After importing pri, no additional compilation is required to generate dll or plug-in

>Steps

```
include(lottie-qml/lottie_qml.pri)
```

### cmake

1. Copy lottie_qml to your project directory, and note that it is at the same level as the module file

```
# Use the module in your CMakeLists.txt
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/lottie_qml lottie_qml.out)
target_link_libraries(${PROJECT_NAME} PRIVATE lottie_qml)
```

## Known issues

* [QTBUG-68278](https://bugreports.qt.io/browse/QTBUG-68278): `requestAnimationFrame` passes seconds to its callback
causing the animations to not advance properly. There is currently a workaround in place that uses the current time
to advance the animations.
* [QTBUG-71524](https://bugreports.qt.io/browse/QTBUG-71524): You cannot use the non-minified `lottie.js` as Qt chokes on reserved keywords used as function names and arguments inside.

## License

This library is licensed under either version 2.1 of the GNU Lesser General Public License, or (at your option) version 3, or any later version accepted by the membership of KDE e.V. (or its successor approved by the membership of KDE e.V.), see `COPYING.LGPL-2.1`, except for:

## lottie-web

```
The MIT License (MIT)

Copyright (c) 2015 Bodymovin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Lottie-QML modified Lottie-Web part of the source code

1. Modify the beginning of the source code

before modification

```javascript
(typeof navigator !== "undefined") && (function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, global.lottie = factory());
})(this, (function () { 'use strict';
```

after modification

```javascript
(typeof navigator !== "undefined") && (function(root, factory) {
  if (typeof define === "function" && define.amd) {
      define(function() {
          return factory(root);
      });
  } else if (typeof module === "object" && module.exports) {
      module.exports = factory(root);
  } else {
      root.lottie = factory(root);
      root.bodymovin = root.lottie;
  }
}((window || {}), function(window) {
```

2. Enable addColorStop transparency

before modification

```javascript
  CVShapeElement.prototype.renderGradientFill = function (styleData, itemData, groupTransform) {
    var styleElem = itemData.style;
    var grd;

    if (!styleElem.grd || itemData.g._mdf || itemData.s._mdf || itemData.e._mdf || styleData.t !== 1 && (itemData.h._mdf || itemData.a._mdf)) {
      var ctx = this.globalData.canvasContext;
      var pt1 = itemData.s.v;
      var pt2 = itemData.e.v;

      if (styleData.t === 1) {
        grd = ctx.createLinearGradient(pt1[0], pt1[1], pt2[0], pt2[1]);
      } else {
        var rad = Math.sqrt(Math.pow(pt1[0] - pt2[0], 2) + Math.pow(pt1[1] - pt2[1], 2));
        var ang = Math.atan2(pt2[1] - pt1[1], pt2[0] - pt1[0]);
        var percent = itemData.h.v;

        if (percent >= 1) {
          percent = 0.99;
        } else if (percent <= -1) {
          percent = -0.99;
        }

        var dist = rad * percent;
        var x = Math.cos(ang + itemData.a.v) * dist + pt1[0];
        var y = Math.sin(ang + itemData.a.v) * dist + pt1[1];
        grd = ctx.createRadialGradient(x, y, 0, pt1[0], pt1[1], rad);
      }

      var i;
      var len = styleData.g.p;
      var cValues = itemData.g.c;
      var opacity = 1;

      for (i = 0; i < len; i += 1) {
        if (itemData.g._hasOpacity && itemData.g._collapsable) {
          opacity = itemData.g.o[i * 2 + 1];
        }

        grd.addColorStop(cValues[i * 4] / 100, 'rgba(' + cValues[i * 4 + 1] + ',' + cValues[i * 4 + 2] + ',' + cValues[i * 4 + 3] + ',' + opacity + ')');
      }

      styleElem.grd = grd;
    }

    styleElem.coOp = itemData.o.v * groupTransform.opacity;
  };
```

after modification

```javascript
  CVShapeElement.prototype.renderGradientFill = function (styleData, itemData, groupTransform) {
    var styleElem = itemData.style;
    var grd;

    if (!styleElem.grd || itemData.g._mdf || itemData.s._mdf || itemData.e._mdf || styleData.t !== 1 && (itemData.h._mdf || itemData.a._mdf)) {
      var ctx = this.globalData.canvasContext;
      var pt1 = itemData.s.v;
      var pt2 = itemData.e.v;

      if (styleData.t === 1) {
        grd = ctx.createLinearGradient(pt1[0], pt1[1], pt2[0], pt2[1]);
      } else {
        var rad = Math.sqrt(Math.pow(pt1[0] - pt2[0], 2) + Math.pow(pt1[1] - pt2[1], 2));
        var ang = Math.atan2(pt2[1] - pt1[1], pt2[0] - pt1[0]);
        var percent = itemData.h.v;

        if (percent >= 1) {
          percent = 0.99;
        } else if (percent <= -1) {
          percent = -0.99;
        }

        var dist = rad * percent;
        var x = Math.cos(ang + itemData.a.v) * dist + pt1[0];
        var y = Math.sin(ang + itemData.a.v) * dist + pt1[1];
        grd = ctx.createRadialGradient(x, y, 0, pt1[0], pt1[1], rad);
      }

      var i;
      var len = styleData.g.p;
      var cValues = itemData.g.c;
      var opacity = 1;

      for (i = 0; i < len; i += 1) {
        if(itemData.g.o[i * 2 + 1] !== null)
        {
          opacity = itemData.g.o[i * 2 + 1];
        }
        if (itemData.g._hasOpacity && itemData.g._collapsable) {
          opacity = itemData.g.o[i * 2 + 1];
        }
        grd.addColorStop(cValues[i * 4] / 100, 'rgba(' + cValues[i * 4 + 1] + ',' + cValues[i * 4 + 2] + ',' + cValues[i * 4 + 3] + ',' + opacity + ')');
      }

      styleElem.grd = grd;
    }

    styleElem.coOp = itemData.o.v * groupTransform.opacity;
  };
```