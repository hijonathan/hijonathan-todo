okcancel_events = (selector) ->
    "keyup " + selector + ", keydown " + selector + ", focusout " + selector

make_okcancel_handler = (options) ->
    ok = options.ok or ->

    cancel = options.cancel or ->

    (evt) ->
        if evt.type is "keydown" and evt.which is 27
            cancel.call this, evt
        else if evt.type is "keyup" and evt.which is 13 or evt.type is "focusout"
            value = String(evt.target.value or "")
            if value
                ok.call this, value, evt
            else
                cancel.call this, evt

focus_field_by_id = (id) ->
    input = document.getElementById(id)
    if input
        input.focus()
        input.select()