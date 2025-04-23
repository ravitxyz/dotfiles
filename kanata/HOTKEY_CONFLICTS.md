# Kanata and Tmux Hotkey Conflict Analysis

## Identified Conflicts

1. **Ctrl-Space**: 
   - Tmux: Used as prefix key (Line 13: `set -g prefix C-Space`)
   - Kanata: If any keys in your home row mod setup use Control, they might interfere

2. **Ctrl-H/J/K/L**:
   - Tmux: Used for pane navigation (Lines 98-101)
   - Kanata: If using home row mods with D as Left Control, pressing D+H/J/K/L would trigger these commands

3. **Space as Leader/Layer Key**:
   - Neovim: Space is set as leader key (Line 2 in keymaps.lua)
   - Kanata: Space is used to access the symbol layer
   - Potential conflict when trying to use leader commands in Neovim vs. accessing symbol layer

4. **Ctrl-W**:
   - Neovim: Mapped for word deletion in insert mode (Line 51 in keymaps.lua)
   - Kanata: Might be affected if using home row mods (D+W with D as Control)

## Resolution Strategies

1. **Adjust Tmux Prefix**:
   - Consider changing Tmux prefix to something that doesn't conflict with Kanata's home row mods
   - Example: Use Alt-Space instead of Ctrl-Space

2. **Adjust Neovim Leader Timing**:
   - Since Space is both Neovim leader and Kanata layer toggle, adjust the timing threshold
   - Make Kanata's hold time slightly longer to give priority to Neovim's leader key for quick taps

3. **Use Separate Modes**:
   - Configure a toggle in Kanata to temporarily disable certain mods when in Tmux/Neovim
   - This would let you switch between "Normal" and "Application-specific" modes

4. **Layer-Specific Overrides**:
   - Create a dedicated Tmux layer in Kanata that handles Tmux commands differently
   - Activate with a special key combo before using Tmux commands

## Immediate Solutions

1. **For Tmux Navigation Conflicts**:
   ```tmux
   # Add to tmux.conf - use Alt instead of Ctrl for navigation
   bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
   bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
   bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
   bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'
   ```

2. **For Space Layer Conflicts**:
   - Adjust Kanata's tap-time value (currently 200ms) to be slightly longer (e.g., 250ms)
   - This gives you more time to use Space as a Neovim leader before it activates as a layer shift

3. **For Home Row Control Conflicts**:
   - Consider remapping the home row key that provides Left Control to a different modifier
   - Or create a special Tmux escape sequence for commands that typically use Ctrl

## Testing Your Setup

After making changes, test these key combinations:
- Space (tap) followed quickly by another key (Neovim leader)
- Space (hold) + Symbol keys (Symbol layer)
- D + hjkl for navigation (if D is your Control mod)
- Tmux prefix followed by commands