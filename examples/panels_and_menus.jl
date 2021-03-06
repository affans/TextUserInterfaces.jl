using TextUserInterfaces

# Initialize the Text User Interface.
tui = init_tui()

# Do not echo the typed characters and do no show the cursor.
noecho()
curs_set(0)

# Create the side window that will contain the menu.
win_menu = create_window(LINES()-4, 20, 0, 0; border = true, title = " Menu ")

# Create the bottom window with the instructions.
win_inst = create_window(4, COLS(), LINES()-4, 0; border = false)

window_println(win_inst, """
Press ENTER to move the panel to top.
Press X to hide/show the panel.
Press F1 to exit.
""")

# Create the windows and panels.
win1 = create_window(10, 40, 0, 22; border = true, title = " Panel 1 ")
win2 = create_window(10, 40, 3, 32; border = true, title = " Panel 2 ")
win3 = create_window(10, 40, 6, 42; border = true, title = " Panel 3 ")
win4 = create_window(10, 40, 9, 52; border = true, title = " Panel 4 ")

panels = [create_panel(win1),
          create_panel(win2),
          create_panel(win3),
          create_panel(win4)]

# Add text to the windows.
window_println(win1, 0, "Text with multiple lines\nwith center alignment";
               alignment = :c, pad = 0)

window_println(win2, 0, "Text with multiple lines\nwith left alignment";
               alignment = :l, pad = 1)

window_println(win3, 0, "Text with multiple lines\nwith right alignment";
               alignment = :r, pad = 1)

window_println(win4, 0, "Line with right alignment";  alignment = :r, pad = 1)
window_println(win4,    "Line with center alignment"; alignment = :c, pad = 0)
window_println(win4,    "Line with left alignment";   alignment = :l, pad = 1)

# Create the menu.
menu = create_menu(["Panel 1", "Panel 2", "Panel 3", "Panel 4"])
set_menu_win(menu,win_menu)
post_menu(menu)

# Refresh all the windows.
refresh()
refresh_all_windows()
update_panels()

# Store which panels are hidden.
hidden_panels = [false; false; false; false]

# Wait for a key and process.
ch,k = jlgetch()

while k.ktype != :F1
    global ch,k

    if !menu_driver(menu, k)
        if ch == 10 || k.value == "x"
            item_name = current_item_name(menu)

            idx = 0

            if item_name == "Panel 1"
                idx = 1
            elseif item_name == "Panel 2"
                idx = 2
            elseif item_name == "Panel 3"
                idx = 3
            elseif item_name == "Panel 4"
                idx = 4
            end

            idx == 0 && continue

            if ch == 10
                !hidden_panels[idx] && move_panel_to_top(panels[idx])
            else
                if hidden_panels[idx]
                    show_panel(panels[idx])
                    hidden_panels[idx] = false
                else
                    hide_panel(panels[idx])
                    hidden_panels[idx] = true
                end
            end
        end
    else
        refresh_window(win_menu)
    end

    update_panels()
    doupdate()

    ch,k = jlgetch()
end

destroy_menu(menu)
destroy_tui()
