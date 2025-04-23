# Kanata Keyboard Configuration Guide

## Home Row Modifiers
When tapped, keys produce their normal character. When held, they act as modifiers:

| Key | Tap | Hold |
|-----|-----|------|
| A | a | Left Command (Meta) |
| S | s | Left Alt |
| D | d | Left Control |
| F | f | Left Shift |
| J | j | Right Shift |
| K | k | Right Control |
| L | l | Right Alt |
| ; | ; | Right Command (Meta) |
| Caps Lock | Escape | Left Control |

## Symbol Layer (Hold Space)
Hold the space bar to access the symbol layer:

### Top Row
```
grv  !    @    #    $    %    ^    &    *    (    )    _    +    bspc
```

### Second Row
```
_    [    ]    {    }    -    =    +    *    &    _    _    _    _
```

### Third Row
```
_    !    @    #    $    %    ^    \    |    `    ~    _    _
```

### Fourth Row
```
_    1    2    3    bspc 5    6    7    8    9    0    _
```

### Key Highlights
- **Backspace**: Space+V (very easy to reach position)
- **Brackets/Braces**: Space+W/E/R/T for [, ], {, }
- **Common Operators**: Space+Y/U/I for -, =, +
- **Numbers**: Available on bottom row in symbol layer

## Advanced Features
- **Auto Layer Disabling**: After tapping a mod key, the home row mods temporarily disable when typing quickly
- **Tap-Hold-Release**: Improved responsiveness for held modifiers
- **Same-Hand Early Tap**: Pressing another key on same half of keyboard activates tap action earlier

## Technical Settings
- Tap Time: 200ms
- Hold Time: 150ms

## Configuration Files
- Main Config: `home-row-mod-advanced.kbd`

## Keyboard Compatibility
Designed for standard Mac keyboard layout. Space bar activates the symbol layer.