--this is a lua script for use in conky
require 'cairo'

function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display,
                                            conky_window.drawable,
                                            conky_window.visual,
                                            conky_window.width,
                                            conky_window.height)

    local cr = cairo_create(cs)

    -- actural draw
    rings_stat(cr)

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr = nil
end
