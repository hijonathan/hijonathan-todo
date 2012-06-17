Template.lists.lists = ->
  Lists.find {},
    sort:
      name: 1

Template.lists.events =
  "mousedown .list": (evt) ->
    Router.setList @_id

  "dblclick .list": (evt) ->
    Session.set "editing_listname", @_id
    Meteor.flush()
    focus_field_by_id "list-name-input"

Template.lists.events[okcancel_events("#list-name-input")] = make_okcancel_handler(
  ok: (value) ->
    Lists.update @_id,
      $set:
        name: value

    Session.set "editing_listname", null

  cancel: ->
    Session.set "editing_listname", null
)
Template.lists.events[okcancel_events("#new-list")] = make_okcancel_handler(ok: (text, evt) ->
  id = Lists.insert(name: text)
  Router.setList id
  evt.target.value = ""
)
Template.lists.selected = ->
  (if Session.equals("list_id", @_id) then "selected" else "")

Template.lists.name_class = ->
  (if @name then "" else "empty")

Template.lists.editing = ->
  Session.equals "editing_listname", @_id